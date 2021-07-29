import 'dart:convert';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';
import 'package:remark_app/apis/push/push_notification.dart';
import 'package:remark_app/apis/responses/interview/all_interviews_api.dart';
import 'package:remark_app/components/buttons/icon_circle_button.dart';
import 'package:remark_app/config/appSetting.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/response/interview/get_all_interviews_model.dart';
import 'package:remark_app/notifier/interview_calling_notifier.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewInterview extends StatefulWidget {
  final Datum interview;
  const ViewInterview({Key key, this.interview}) : super(key: key);

  @override
  _ViewInterviewState createState() => _ViewInterviewState();
}

class _ViewInterviewState extends State<ViewInterview> {

  int screenResponse = 0;
  List candidates = [];
  RTCPeerConnection _peerConnection;
  RTCVideoRenderer _localRenderer = new RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();
  MediaStream _localStream;
  MediaStream _peerStream;
  String userType;
  bool _offer = false;
  var sendCandidate = false;
  bool setremotedescription = false;
  var offerMsg;
  bool offerReceived = false;
  bool _voiceMuted = false;




  @override
  void initState() {
    // TODO: implement initState
    _getUserData();
    _initializerRenderer();
    _getFirebaseNotification();
    super.initState();
  }


  _checkPeerConnection() async {
    _peerConnection = context.watch<InterviewCallingNotifier>().peerConnection;
  }

  // CREATED PEER CONNECTION SUCCESSFULLY
  Future<RTCPeerConnection> _createPeerConnection() async {

    print("============= STARTING PEER CONNECTION =============");

    Map<String, dynamic> configuration = {
      "iceServers" : [
        {
          "url" : "stun:stun.l.google.com:19302"
        }
      ]
    };

    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory" : {
        "OfferToReceiveAudio" : true,
        "OfferToReceiveVideo" : true
      },
      "optional" : []
    };

    _peerStream = await _getUserMediaDevices();

    RTCPeerConnection pc = await createPeerConnection(configuration , offerSdpConstraints);

    pc.addStream(_peerStream);

    pc.onIceCandidate = _handleIceCandidate;

    pc.onIceConnectionState = _handleICEConnectionStateChangeEvent;

    pc.onAddStream = (stream) {
      print("=======STREAM ADDED WITH ID : ${stream.id}");
      stream.getVideoTracks().forEach((element) {
        print("stream track");
        print(element.id);
      });
      print("stream tracked");

      Provider.of<InterviewCallingNotifier>(context , listen: false).addRemoteRendererStream(_remoteRenderer, stream);
      // setState(() {
      //   _remoteRenderer.srcObject = stream;
      // });
    };

    Provider.of<InterviewCallingNotifier>(context , listen: false).createPeerConnection(pc, true);

    return pc;
  }

  _createOffer() async {
    RTCSessionDescription description = await _peerConnection.createOffer({
      'offerToReceiveVideo' : 1
    });

    var session = parse(description.sdp);


    if(!_offer){
      var data = jsonEncode({
        "notification_type" : "callOfferInitialize",
        "interviewID" : widget.interview.interviewId,
      });

      await GetAllInterviewsApi().sendInterviewSession(widget.interview.interviewId, jsonEncode(session), userType);

      await SendPushNotification().send(data, widget.interview.employeeToken);
    }

   setState(() {
     _offer = true;
   });

    _peerConnection.setLocalDescription(description);
  }

  _handleTrackEvent(RTCTrackEvent event) {
    _remoteRenderer.srcObject = event.streams[0];
  }

  _handleIceCandidate(RTCIceCandidate e) {
    if(e.candidate != null){

      print("Candidate is available");
      print(e.toMap());

      candidates.add(jsonEncode({
        "candidate" : e.candidate,
        "sdpMid" : e.sdpMid,
        "sdpMlineIndex" : e.sdpMlineIndex
      }));

      var data = jsonEncode({
        "notification_type" : "callCandidateInitialize",
        "interviewID" : widget.interview.interviewId,
        "candidate" : candidates[0]
      });

      if(userType == "1"){
        print("candidate is sending");
        SendPushNotification().send(data, widget.interview.employerToken);
      }


    }
  }

  _handleICEConnectionStateChangeEvent(event) {
    print("Ice Connection State : ${_peerConnection.iceConnectionState} ");

    if(_peerConnection.iceConnectionState == RTCIceConnectionState.RTCIceConnectionStateFailed){

      var data = jsonEncode({
        "notification_type" : "connection_failed",
      });

      SendPushNotification().send(data, widget.interview.employerToken);

    }

  }

  _handleNegotiationNeededEvent() async {

    var session;

    await _peerConnection.createOffer()
    .then((description) {

      session = parse(description.sdp);

      Provider.of<InterviewCallingNotifier>(context , listen: false).changeOffer(true);

      _peerConnection.setLocalDescription(description);
    })
    .then((_) async {


        var data = jsonEncode({
          "notification_type" : "callOfferInitialize",
          'interviewType' : widget.interview.interviewType,
          "interviewID" : widget.interview.interviewId,
          "employerToken" : widget.interview.employerToken
        });

        await GetAllInterviewsApi().sendInterviewSession(widget.interview.interviewId, jsonEncode(session), userType);

        await SendPushNotification().send(data, widget.interview.employeeToken);


    });

    print("==============OFFER CREATED==================");

  }

  _createAnswer() async {

    print("========================CREATING ANSWER ============");

    RTCSessionDescription description = await _peerConnection.createAnswer({
      "offerToReceiveVideo" : 1
    });

    var session = parse(description.sdp);


    await GetAllInterviewsApi().sendInterviewSession(widget.interview.interviewId, jsonEncode(session), userType);

    _peerConnection.setLocalDescription(description);

    print("========================CREATED ANSWER ============");

    var data = jsonEncode({
      "notification_type" : "callAnswerInitialize",
      "interviewID" : widget.interview.interviewId,
    });

    SendPushNotification().send(data, widget.interview.employerToken);

  }

  _sendCandidate() async {

    print("===================SEARCHING CANDIDATE========================");
    if(userType == "1" && candidates.isNotEmpty && sendCandidate == false ){
      print("===================GOT CANDIDATE========================");


      setState(() {
        sendCandidate = true;
      });

    }else{
      print("==================CANDIDATE NOT FOUND=======================");
    }


  }

  // SET REMOTE DESCRIPTION
  _setRemoteDescription(jsonString) async {

    dynamic session = await jsonDecode(jsonString);

    String sdp = write(session , null);

    RTCSessionDescription description = RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');

    print("=============SETTING REMOTE DESCRIPTION==================");
    print(description.toMap());

    await _peerConnection.setRemoteDescription(description);

    print("============REMOTE DESCRIPTION SET SUCCESSFULLY===============");


  }

  // SET CANDIDATE AFTER GETTING ANSWER
  _setCandidate(jsonString) async {
    print("===================SETTING CANDIDATE====================");

    dynamic session = await jsonDecode(jsonString);

    print(session['candidate']);

    dynamic candidate = RTCIceCandidate(session['candidate'] , session['sdpMid'] , session['sdpMlineIndex']);

    await _peerConnection.addCandidate(candidate);

    print("=================CANDIDATE SET SUCCESSFULLY=================");

    _handleNegotiationNeededEvent();

  }

  // GOT USER MEDIA DEVICES
  _getUserMediaDevices() async {

    Map<String, dynamic> constraints = {
      "audio" : true,
      "video" : true
    };

    _localStream = await navigator.mediaDevices.getUserMedia(constraints)
    .then((stream) {
        _localStream = stream;
        Provider.of<InterviewCallingNotifier>(context , listen: false).addLocalRendererStream(_localRenderer, stream);

        return _localStream;
    });

    return _localStream;

  }

  // INITIALIZED THE RENDERERS
  _initializerRenderer() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  // GETTING PUSH NOTIFICATION ACCORDING TO NOTIFICATION_TYPE
  _getFirebaseNotification() async {

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

        // GETTING OFFER VIA FIREBASE PUSH NOTIFICATION
        if(message.data['notification_type'] == "callOfferInitialize" && message.data['interviewID'] == widget.interview.interviewId){

          final response = GetAllInterviewsApi().getInterviewSession(widget.interview.interviewId);

          if(!offerReceived){

            _createPeerConnection().then((value) {
              _peerConnection = value;
            });

            Provider.of<InterviewCallingNotifier>(context , listen: false).changeScreenResponse(1);
            setState(() {
              offerReceived = true;
            });
          }

          response.then((value) {
                offerMsg = {
                  "offerString" : value['data']['employer_session'],
                };

                _setRemoteDescription(value['data']['employer_session']);
            });
          }

        // GETTING ANSWER VIA FIREBASE PUSH NOTIFICATION
        if(message.data['notification_type'] == "callAnswerInitialize" && message.data['interviewID'] == widget.interview.interviewId){

          final response = GetAllInterviewsApi().getInterviewSession(widget.interview.interviewId);

          var remoteDescription = "";

          response.then((value){
            remoteDescription = value['data']['employee_session'];
            _setRemoteDescription(remoteDescription);
          });
        }

        if(message.data['notification_type'] == "callCandidateInitialize" && message.data['interviewID'] == widget.interview.interviewId){

          _setCandidate(message.data['candidate']);

          Provider.of<InterviewCallingNotifier>(context , listen: false).changeScreenResponse(2);
        }

        if(message.data['notification_type'] == "end_call") {

          _endCall();

        }

        if(message.data['notification_type'] == "connection_failed"){

          _createOffer();

        }

        if(message.data['notification_type'] == "createOfferAgain"){
          _handleNegotiationNeededEvent();
        }
    });
  }

  _endCall() async {



      Provider.of<InterviewCallingNotifier>(context , listen: false).muteLocalRendererStream(_localRenderer, false);

      _localRenderer.srcObject.getTracks().forEach((element) {
        element.stop();
      });

      if(_remoteRenderer != null || _remoteRenderer.srcObject != null){
        _remoteRenderer.srcObject.getTracks().forEach((element) {
          element.stop();
        });
      }

    setState(() {
      _voiceMuted = false;
    });

    _remoteRenderer.srcObject = null;
    _localRenderer.srcObject = null;

      _localStream.getTracks().forEach((element) {
        element.stop();
        element = null;
      });


      _peerStream.getTracks().forEach((element) {
        element.stop();
        element = null;
      });


    _peerConnection.onIceCandidate = null;
    _peerConnection.onIceConnectionState = null;

    _peerConnection.close();

    _peerConnection = null;

    setState(() {
      _offer = false;
    });

    Provider.of<InterviewCallingNotifier>(context , listen: false).changeScreenResponse(0);

    Navigator.pop(context);

  }

  // GOT USER DATA FROM SHARED PREFERENCES
  _getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userType = pref.getString("userType");
    });
  }

  // DISPOSE INITIALIZERS
  @override
  void dispose() {
    // TODO: implement dispose
      _localRenderer.dispose();


    if(_remoteRenderer != null){
      _remoteRenderer.dispose();
    }


    if(_peerStream != null){
      _peerStream.dispose();
    }

      _localStream.dispose();

    if(_peerConnection != null){
      _peerConnection.close();
    }


    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Consumer<InterviewCallingNotifier>(
            builder: (context, value, child) {
              return value.screenResponse == 1 && userType == "1" ? incomingCallScreen() : value.screenResponse == 1 && userType == "2" ? outGoingCallScreen() : value.screenResponse == 2 ? mainCallScreen() : interviewPage();
            },
        )
        // screenResponse == 1 && userType == "1" ? incomingCallScreen() : screenResponse == 1 && userType == "2" ? outGoingCallScreen() : screenResponse == 2 ? mainCallScreen() : interviewPage()   ,
    );
  }

  Widget interviewPage() {
      return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: 13,
            horizontal: 15
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 15
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: kDarkColor
                ),
                child: Row(
                  children: [
                    AvatarGlow(
                      endRadius: 45,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AppSetting.showUserImage(userType == "1" ? widget.interview.employerLogo : widget.interview.employeePhoto),
                        backgroundColor: Colors.white,
                      ),
                      showTwoGlows: true,
                      glowColor: kDarkColor,
                      curve: Curves.easeIn,
                      repeat: true,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${userType == "1" ? widget.interview.employerName : widget.interview.employeeName }" , style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 25
                        ), ),
                        SizedBox(height: 5,),
                        Text("${widget.interview.interviewType == "0" ? "Voice Call Interview" : "Video Call Interview"}" , style: TextStyle(
                            color:  Colors.white
                        ),)
                      ],
                    ),
                    Spacer(),
                    if(userType == "2")
                      Container(
                        alignment: Alignment.center,
                        child: IconCircleButton(
                          onPressed: () => print(""),
                          icon: Icons.delete,
                          backgroundColor: Colors.redAccent,
                          iconColor: Colors.white,
                          radius: 50,
                        ),
                      )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Interview Title" , style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                    ),),
                    SizedBox(
                      height: 5,
                    ),
                    Text("${widget.interview.interviewTitle}" , style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),),
                    SizedBox(height: 20,),
                    Text("Interview Type" , style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                    ),),
                    SizedBox(
                      height: 5,
                    ),
                    Text("${widget.interview.interviewType == '0' ? "Voice Call Interview" : 'Video Call Interview'}" , style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),),
                    SizedBox(height: 20,),
                    Text("Interview Date" , style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                    ),),
                    SizedBox(
                      height: 5,
                    ),
                    Text("${widget.interview.interviewTime}" , style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),),
                    SizedBox(height: 20,),
                    Text("Interview Status" , style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                    ),),
                    SizedBox(
                      height: 5,
                    ),
                    Text("${widget.interview.interviewAgreeStatus == '0' ? "Not Respond" : widget.interview.interviewAgreeStatus == '1' ? 'Agreed' : widget.interview.interviewAgreeStatus == '2' ? 'Rejected' : widget.interview.interviewAgreeStatus == "3" ? 'Rescheduled' : '' }" , style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),),
                    SizedBox(height: 20,),
                    Divider(),
                    SizedBox(height: 20,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if(userType == "1" && widget.interview.interviewAgreeStatus == "0")
                            IconCircleButton(
                              onPressed: () async {
                                await GetAllInterviewsApi().interviewResponse(widget.interview.interviewId, "1").then((res) {
                                  if(res.status){
                                    setState(() {
                                      widget.interview.interviewAgreeStatus = "1";
                                    });
                                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ViewInterview(interview: widget.interview),));
                                  }
                                });
                              },
                              icon: Icons.check,
                              title: "Accept",
                              textColor: Colors.black,
                              backgroundColor: kDarkColor.withOpacity(0.6),
                              iconColor: Colors.white,
                              radius: 50,
                            ),
                          if(userType == "1" && widget.interview.interviewAgreeStatus == "0")
                            IconCircleButton(
                              onPressed: () => print(""),
                              icon: Icons.cancel,
                              title: "Reject",
                              textColor: Colors.black,
                              backgroundColor: Colors.redAccent.withOpacity(0.6),
                              iconColor: Colors.white,
                              radius: 50,
                            ),
                          if(userType == "1" && widget.interview.interviewAgreeStatus != "3")
                            IconCircleButton(
                              onPressed: () => print(""),
                              icon: Icons.history_rounded,
                              title: "Reschedule",
                              textColor: Colors.black,
                              backgroundColor: kDarkColor.withOpacity(0.6),
                              iconColor: Colors.white,
                              radius: 50,
                            ),
                          if(userType == "2")
                            IconCircleButton(
                              onPressed: () => print(""),
                              icon: Icons.edit,
                              title: "Edit",
                              textColor: Colors.black,
                              backgroundColor: kDarkColor.withOpacity(0.6),
                              iconColor: Colors.white,
                              radius: 50,
                            ),
                          if(userType == "2" && widget.interview.interviewAgreeStatus == "1")
                            IconCircleButton(
                              radius: 40,
                              iconColor: Colors.white,
                              backgroundColor: kDarkColor.withOpacity(0.6),
                              icon: widget.interview.interviewType == "0" ? Icons.call : Icons.videocam,
                              iconSize: 20,
                              title: "Call",
                              textColor: Colors.black,
                              onPressed: () async {
                                // create offer
                                await _createPeerConnection().then((value) {
                                  setState(() {
                                    _peerConnection = value;
                                  });
                                });

                                _createOffer();

                                Provider.of<InterviewCallingNotifier>(context , listen: false).changeScreenResponse(1);

                                },
                            ),
                          if(userType == "2")
                            IconCircleButton(
                              onPressed: () => print(""),
                              icon: Icons.history_rounded,
                              title: "Reschedule",
                              textColor: Colors.black,
                              backgroundColor: kDarkColor.withOpacity(0.6),
                              iconColor: Colors.white,
                              radius: 50,
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget incomingCallScreen(){
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          color: kLightColor,

        ),
        child: Column(
          children: [
            SizedBox(
              height: 120,
            ),
            AvatarGlow(
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white,
                  backgroundImage: AppSetting.showUserImage(widget.interview.employerLogo),
                ),
                endRadius: 120),
            SizedBox(height: 10,),
            Text("${widget.interview.employerName}" , style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),),
            Spacer(),
            Padding(padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: IconCircleButton(
                      backgroundColor: Colors.redAccent,
                      radius: 60,
                      icon: widget.interview.interviewType == "0" ? Icons.call_end_rounded : Icons.videocam_off_rounded,
                      iconColor: Colors.white,
                      title: "Cancel",
                      textColor: Colors.white,
                      onPressed: () async {
                        print("Cancelled");
                      },
                    ),
                  ),
                  Container(
                    child: IconCircleButton(
                      onPressed: () {
                        _createAnswer();
                        Provider.of<InterviewCallingNotifier>(context , listen: false).changeScreenResponse(2);
                      },
                      icon: widget.interview.interviewType == "0" ? Icons.call : Icons.videocam,
                      iconColor: Colors.green,
                      radius: 60,
                      backgroundColor: Colors.white,
                      title: "Answer",
                      textColor: Colors.white,
                    ),
                  )
                ],
              ),),
            Spacer()
          ],
        ),
      ),
    );
  }

  Widget outGoingCallScreen(){
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: 80),
        width: size.width,
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AvatarGlow(
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white,
                  backgroundImage: AppSetting.showUserImage(widget.interview.employeePhoto),
                ),
                glowColor: kDarkColor,
                showTwoGlows: true,
                repeatPauseDuration: Duration(milliseconds: 200),
                endRadius: 120),
            SizedBox(height: 10,),
            Text("Calling" , style: TextStyle(
                fontSize: 30
            ),),
            Text("Waiting for response" , style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),),
            Spacer(),
            Container(

              child: IconCircleButton(
                onPressed: () {

                  Navigator.pop(context);
                },
                iconSize: 30,
                icon: Icons.call_end_rounded,
                backgroundColor: Colors.redAccent,
                iconColor: Colors.white,
                radius: 60,
              ),
            ),
            SizedBox(height: 50,)
          ],
        ),
      ),
    );
  }

  Widget mainCallScreen(){
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          key: Key('remote'),
          width: size.width,
          height: size.height,
          color: Colors.blueGrey,
          child: Center(
            child: Consumer<InterviewCallingNotifier>(
                builder: (context, value, child) {
                  if(widget.interview.interviewType == "1"){
                    return value.remoteRenderer != null ? RTCVideoView(value.remoteRenderer , mirror: true,) : Text("Waiting for user");
                  }else{
                    return Text("Audio Connected");
                  }
                },
            )
            // _remoteRenderer.srcObject != null ? RTCVideoView(_remoteRenderer , mirror: true,) : Text("Waiting for user")
          ),
        ),
        if(widget.interview.interviewType == "1")
        Positioned(
            bottom: 100,
            right: 0,
            child: Container(
              key: Key('local'),
              margin: EdgeInsets.symmetric(
                  horizontal: 15
              ),
              width: size.width * 0.3,
              height: size.height * 0.2,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: Offset(2, 3)
                    )
                  ]
              ),
              child: Consumer<InterviewCallingNotifier>(
                builder: (context, value, child) {
                  return value.localRenderer != null ? RTCVideoView(value.localRenderer , mirror: true,) : Text("Waiting for response") ;
                },
              )
              // _localRenderer.srcObject != null ? RTCVideoView(_localRenderer , mirror: true,filterQuality: FilterQuality.medium, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,) : Text("Waiting for user"),
            )),
        Positioned(
          bottom: 0,
          child: Container(
            width: size.width,
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconCircleButton(
                  onPressed: () async {
                    setState(() {
                      _voiceMuted = !_voiceMuted;
                    });
                    Provider.of<InterviewCallingNotifier>(context,listen: false).muteLocalRendererStream(_localRenderer, _voiceMuted);
                  },
                  backgroundColor: _voiceMuted ? Colors.redAccent[200] : Colors.green[200],
                  icon: _voiceMuted ? Icons.mic_off : Icons.mic_none_outlined,
                  iconColor: Colors.white,
                  radius: 60,
                ),
                IconCircleButton(
                  onPressed: () async {
                    print("ending call");
                    var data = jsonEncode({
                      "notification_type" : "end_call"
                    });
                    var sendEndCall = userType == "1" ? widget.interview.employerToken : userType == "2" ? widget.interview.employeeToken : "";
                    await SendPushNotification().send(data, sendEndCall).then((_) => {
                    _endCall()
                    });
                  },
                  backgroundColor: Colors.redAccent,
                  icon: Icons.call_end_outlined,
                  iconColor: Colors.white,
                  radius: 60,
                ),
                if(widget.interview.interviewType == "1")
                IconCircleButton(
                  onPressed: () async {
                    await Provider.of<InterviewCallingNotifier>(context , listen: false).switchCameraLocal(_localRenderer, _localStream, true);
                  },
                  backgroundColor: Colors.green[200],
                  radius: 60,
                  iconColor: Colors.white,
                  icon: Icons.flip_camera_ios_outlined,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

}
