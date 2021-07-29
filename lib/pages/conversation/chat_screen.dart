import 'dart:async';
import 'dart:convert';

import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remark_app/apis/conversation/change_chat_message_status_api.dart';
import 'package:remark_app/apis/conversation/change_room_status_api.dart';
import 'package:remark_app/apis/conversation/get_all_message.dart';
import 'package:remark_app/apis/conversation/get_all_rooms.dart';
import 'package:remark_app/apis/conversation/send_chat_message_api.dart';
import 'package:remark_app/components/empty/empty_data.dart';
import 'package:remark_app/components/loading/circular_loading.dart';
import 'package:remark_app/config/appSetting.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/main.dart';
import 'package:remark_app/model/conversation/get_all_messages_model.dart';
import 'package:remark_app/model/conversation/get_single_room_model.dart';
import 'package:remark_app/model/conversation/send_chat_message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class ChatScreen extends StatefulWidget {

  final roomId;
  final userImage;
  final userName;
  final imageHero;
  final senderID;
  final receiverID;

  const ChatScreen({Key key, this.roomId, this.imageHero, this.userImage, this.userName, this.senderID, this.receiverID}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final scrollController = ScrollController();
  Future<GetAllMessageModel> _futureConversation;
  Future<GetSingleChatRoomModel> _getSingleRoom;
  bool isConversationAvailable = false;
  List<Datum> _conversationList = <Datum>[];
  String userID;
  String userType;
  String roomStatus = "1";
  bool switchBtn = false;
  String userToken;
  TextEditingController newMessage = TextEditingController();
  AdvancedSwitchController _advancedSwitchController;

  @override
  void initState() {
    // TODO: implement initState
    _advancedSwitchController = AdvancedSwitchController(false);
    getRoom(widget.roomId);

    _advancedSwitchController.addListener(() {
      var roomValue;
      if(_advancedSwitchController.value){
        roomValue = "0";
      }else{
        roomValue = "1";
      }

      updateRoom(roomValue);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message Received ${message.data['message_id']}");

      addMessageToConversation(message);

    });

    getUserData();
    super.initState();

  }


  Future<GetSingleChatRoomModel> getRoom(roomID) async {
    _getSingleRoom = GetRoom().getSingleChatRoom(roomID);
    print("room got $roomID");
    print("Now Status $roomStatus");

      await _getSingleRoom.then((value) {
        print(value.toJson());
        setState(() {
          if(value.data.roomStatus == "0"){
             _advancedSwitchController.value = true;
          }else{
            _advancedSwitchController.value = false;
          }
          roomStatus = value.data.roomStatus;
        });


      });

    print("After Status $roomStatus");
    return _getSingleRoom;
  }

  addMessageToConversation(RemoteMessage message) {
    print("message received");

    if(message.data['notification_type'] == 'newMessage'){
      setState(() {
        _futureConversation.then((value) {
          value.data.add(
              Datum(
                  messageId: message.data['message_id'],
                  message: message.data['body'],
                  roomId: widget.roomId,
                  senderId: widget.senderID,
                  receiverId: widget.receiverID,
                  messageStatus: "2",
                  messageCreatedAt: DateTime.now()
              )
          );
          changeMessageStatus(message.data['message_id']);
        });


      });
    }else if(message.data['notification_type'] == 'roomStatus'){
        var roomValue = message.data['room_status'];
        setState(() {
          roomStatus = roomValue;
        });
    }

  }



  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userID = pref.getString("userID");
      userType = pref.getString("userType");
      userToken = pref.getString("userToken");
      _futureConversation = GetAllMessages().getAllMessages(widget.senderID, widget.receiverID);
      // GETTING MY CONVERSATION
    });
  }


  changeMessageStatus(messageID) async {
    await ChangeChatMessageStatusApi().changeChatMessage(widget.receiverID, "2", messageID).then((value) => {
      if(value.status){
        print("Status Changed")
      }else{
        print("not changed $messageID")
    }
    });

  }

  // changeMessageStatus() async {
  //     _futureConversation.then((value) => {
  //         value.data.forEach((element) async {
  //            await ChangeChatMessageStatusApi().changeChatMessage(widget.senderID, "3", element.messageId);
  //         })
  //     });
  // }

  changeConversationAvailability() {
    setState(() {
      isConversationAvailable = true;
    });
  }

  sendMessageToServer(senderID, receiverID, roomID, message) async {

    var response = SendChatMessageApi().sendChatMessage(senderID, receiverID, roomID, message);

      response.then((value) => {
          if(value.status){
            print("Message Sent")
          }else{
            print("Message not sent")
    }
      });

  }

  updateRoom(roomValue) async {
      await ChangeRoomStatusApi().changeRoomStatus(widget.senderID, widget.roomId, roomValue , userToken).then((value) => {
        print("Room Status Changed"),
      });
      setState(() {
        roomStatus = roomValue;
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [

            Container(
              width: size.width,
              height: size.height,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 5
                    ),
                    alignment: Alignment.centerLeft,
                    color: kDarkColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell( 
                          onTap: () => Navigator.pop(context) ,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10
                            ),
                            child: Icon(Icons.arrow_back , color: Colors.white, size: 25,),
                          ),
                        ),
                        Hero(
                          tag: widget.imageHero,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: widget.userImage != null ? NetworkImage(base_url+widget.userImage) : AssetImage(application_logo),
                          ),
                        ),
                        SizedBox(width: 5,),
                        Text(widget.userName != null ? "${widget.userName}" : "No name" , style: GoogleFonts.lora(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),),
                        Spacer(),
                        if(userType == "2")
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AdvancedSwitch(
                            controller: _advancedSwitchController,
                            activeColor: Colors.white,
                            inactiveColor: Colors.grey,
                            enabled: true,
                            width: 45,
                            height: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: FutureBuilder<GetAllMessageModel>(
                      future: _futureConversation,
                      builder: (_, AsyncSnapshot<GetAllMessageModel> snapshot) {
                        if(snapshot.hasError){
                          print("Error");
                          return Center(
                            child: Text("${snapshot.error}"),
                          );
                        }else if(snapshot.hasData){
                          print('Data Got');

                          if(snapshot.data.status){
                            isConversationAvailable = true;
                          }

                          if(isConversationAvailable){

                            List<Datum> reversedData = snapshot.data.data.reversed.toList();
                            return Expanded(
                              child: Container(
                              padding: EdgeInsets.only(bottom: 80),
                                child: ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  reverse: true,
                                  controller: scrollController,
                                  itemCount: snapshot.data.data.length,
                                  itemBuilder: (_, index) {
                                    var chats = reversedData[index];
                                    bool isSender = false;
                                    if(chats.receiverId != userID){
                                      isSender = true;
                                    }else{
                                      isSender = false;
                                    }



                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10
                                      ),
                                      child: ChatBubble(
                                        isSender: isSender,
                                        message: chats.message,
                                        messageTime: chats.messageCreatedAt,
                                      )
                                    );
                                  },
                                ),
                              ),
                            );
                          }else{
                            print("No Message Found");
                            return Stack(
                              children: [
                                Container(
                                    width: size.width,
                                    height: size.height * 0.8,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Center(
                                        child: EmptyData(message: "No Message Found"))),
                              ]
                            );
                          }
                        }else{
                          return Expanded(child: CircularLoading());
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            if(roomStatus == "0")
            Container(
              child: Column(
                children: [
                  Spacer(),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15) , topRight: Radius.circular(15)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: size.width * 0.7,
                          decoration: BoxDecoration(
                            color: Colors.white
                          ),
                          child: TextField(
                            controller: newMessage,
                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            minLines: 1,
                            decoration: InputDecoration(
                              hintText: "Message",
                            ),
                          ),
                        ),
                        Container(
                          width: size.width * 0.20,
                          alignment: Alignment.center,
                          child: IconButton(
                            onPressed: () {
                              changeConversationAvailability();
                              print("room id - ${widget.roomId}");
                              if(newMessage.text.isNotEmpty || newMessage.text.trim().length != 0){
                                print(newMessage.text.length);
                                setState(() {

                                  _futureConversation.then((value) => value.data.add(
                                      Datum(
                                          message: newMessage.text,
                                          roomId: widget.roomId,
                                          senderId: widget.receiverID,
                                          receiverId: widget.senderID,
                                          messageStatus: "1",
                                          messageCreatedAt: DateTime.now()
                                      )
                                  )).then((value) => {
                                    sendMessageToServer(widget.receiverID, widget.senderID, widget.roomId, newMessage.text),
                                    scrollController.animateTo(0.0, duration: Duration(seconds: 1), curve: Curves.ease),
                                    newMessage.text = ""
                                  });



                                });
                              }
                            },
                            icon: Icon(Icons.send_rounded, color: kDarkColor,),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            if(roomStatus == "1")
              Container(
                child: Column(
                  children: [
                    Spacer(),
                    Container(
                      alignment: Alignment.center,
                      width: size.width,
                      padding: EdgeInsets.only(bottom: 30),
                      child: Text("Conversation Ended" , style: TextStyle(
                        color: Colors.grey
                      ),)
                    )
                  ],
                ),
              ),
          ],
        ),
      )
    );
  }
}

class ShowChatTimeAgo extends StatelessWidget {
  final bool isSender;
  final DateTime time;
  const ShowChatTimeAgo({Key key, this.isSender, this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: isSender ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
      Icon(Icons.history , color: Colors.grey[400], size: 10,),
      SizedBox(width: 2,),
      Text("${timeAgo.format(time)}" , style: TextStyle(
      color: Colors.grey[400],
      fontSize: 11
      ),),
],
),
    );
  }
}


class ChatBubble extends StatelessWidget {
  final bool isSender;
  final String message;
  final DateTime messageTime;

  const ChatBubble({Key key, this.isSender = false, this.message, this.messageTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10
      ),
      child: Column(
          mainAxisAlignment: isSender ? MainAxisAlignment.start : MainAxisAlignment.end,
          crossAxisAlignment: isSender? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              width: size.width * 0.8,
              child: Column(
                mainAxisAlignment: isSender ? MainAxisAlignment.start : MainAxisAlignment.end,
                crossAxisAlignment: isSender? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: kLightColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Text(message , style: TextStyle(
                        color: Colors.white
                    ), softWrap: true),
                  ),
                  SizedBox(height: 3,),
                  Row(
                    mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      Container(
                        child: ShowChatTimeAgo(
                          isSender: isSender,
                          time: messageTime,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )

          ],
      ),
    );
  }
}
