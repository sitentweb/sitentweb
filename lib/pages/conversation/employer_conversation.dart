import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:remark_app/apis/conversation/get_all_rooms.dart';
import 'package:remark_app/components/appbar/appbar.dart';
import 'package:remark_app/components/appbar/conversation_room_appbar.dart';
import 'package:remark_app/components/empty/empty_data.dart';
import 'package:remark_app/components/loading/circular_loading.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/conversation/get_all_room_model.dart';
import 'package:remark_app/pages/conversation/chat_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployerConversationRoom extends StatefulWidget {
  const EmployerConversationRoom({Key key}) : super(key: key);

  @override
  _EmployerConversationRoomState createState() => _EmployerConversationRoomState();
}

class _EmployerConversationRoomState extends State<EmployerConversationRoom> {

  var userType;
  var userID;

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userType = pref.getString("userType");
      userID = pref.getString("userID");
      print(userID);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [ApplicationAppBar()],
        iconTheme: IconThemeData(color: kDarkColor),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: FutureBuilder<GetAllChatRoomModel>(
          future: GetRoom().getChatRoom(userID),
          builder: (context, snapshot) {
            if(snapshot.hasError){
              print("snapshot has error!");
              return Container();
            }else if(snapshot.hasData){
              if(snapshot.data.status){
                return ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                    itemCount: snapshot.data.data.length,
                    itemBuilder: (context, index) {
                      var chat = snapshot.data.data[index];

                      // SENDER ID IS CHAT USER ID
                      // RECEIVER ID IS SESSION USER ID;
                      var senderId = chat.userId;
                      var receiverId = userID;
                      return ListRoomCard(
                        roomId: chat.roomId,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(imageHero: "image${chat.roomId}" , roomId: chat.roomId, userImage: chat.userPhoto, userName: chat.userName, senderID: senderId, receiverID:  receiverId),));
                        },
                         leading: Hero(
                           tag: "image${chat.roomId}",
                           child: CircleAvatar(
                             backgroundColor: Colors.white,
                              backgroundImage: chat.userPhoto != null ? NetworkImage(base_url+chat.userPhoto) : AssetImage(application_logo),
                           ),
                         ),
                        title: chat.userName != null ? "${chat.userName}" : "No name",
                        subtitle: Text("${chat.lastMessage ?? ""}" , overflow: TextOverflow.ellipsis,),
                        trailing: Icon(Icons.chevron_right_rounded),
                      );

                    },
                );
              }else{
                print("No Room Here");
                return EmptyData(message: "No Room Here",);
              }
            }else{
              return CircularLoading();
            }
          },
        ),
      ),
    );
  }
}

class ListRoomCard extends StatelessWidget {
  final String title;
  final Widget subtitle;
  final Widget leading;
  final Widget trailing;
  final roomId;
  final void Function() onTap;
  const ListRoomCard({Key key, this.title, this.subtitle, this.leading, this.trailing, this.onTap, this.roomId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(50)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(2 , 3),
                spreadRadius: 5
              )
            ]
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leading,
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$title" , style: GoogleFonts.lora(
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                  ),),
                  subtitle
                ],
              ),
              Spacer(),

              Container(
                child: trailing,
              )
            ],
          ),
        ),
      ),
    );
  }
}
