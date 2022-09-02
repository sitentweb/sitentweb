import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:remark_app/apis/push/push_notification.dart';
import 'package:remark_app/components/buttons/icon_circle_button.dart';
import 'package:remark_app/components/loading/circular_loading.dart';
import 'package:remark_app/config/webrtc_setup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainVideoCallScreen extends StatefulWidget {

  final employeeToken;
  final employerToken;
  final interviewID;
  final interviewType;
  final bool offer;
  const MainVideoCallScreen({Key key, this.employeeToken, this.employerToken, this.interviewID, this.interviewType, this.offer}) : super(key: key);

  @override
  _MainVideoCallScreenState createState() => _MainVideoCallScreenState();
}

class _MainVideoCallScreenState extends State<MainVideoCallScreen> {

  RTCPeerConnection _peerConnection;
  bool _callConnected = false;
  bool offer = false;
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  bool isLocalRendered = false;
  var userType;
  MediaStream _localStream;

  @override
  void initState() {
    // TODO: implement initState
    SharedPreferences.getInstance().then((value) {
      setState(() {
        userType = value.getString("userType");
      });

      if(userType == "2"){
        _createOffer();
      }else{
        _createAnswer();
      }

    });
    initializeRenderer();
    WebRTCSetup.createNewPeerConnection(getUserMedia(), _remoteRenderer).then((pc) {
        _peerConnection = pc;
    });
    super.initState();
  }



  _createAnswer() async {
     if(userType == "1"){

       await WebRTCSetup.createAnswer(widget.interviewID , userType).then((description) {

         _peerConnection.setLocalDescription(description);

       });


     }else{
       print("usertype not found");
     }
  }

  _createOffer() async {
    if(userType == "2"){
      await WebRTCSetup.createOffer(widget.interviewID, userType).then((description) {
        _peerConnection.setLocalDescription(description);

        var data = jsonEncode({
          "notification_type" : "callOfferInitialize"
        });

        SendPushNotification().send(data, widget.employeeToken);
        setState(() {
          offer = true;
        });
      });


    }else{
      print("user type not fetch");
    }
  }

  Future<MediaStream> getUserMedia() async {

      Map<String , dynamic> constraints = {
        "audio" : false,
        "video" : widget.interviewType == "0" ? false : true
      };

      await navigator.mediaDevices.getUserMedia(constraints).then((value) {
        setState(() {
          isLocalRendered = true;
          _localStream = value;
        });
      });

      _localRenderer.srcObject = _localStream;

      return _localStream;

  }

  initializeRenderer() async {
    await _localRenderer.initialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _localRenderer.dispose();
    _localStream.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            color: Colors.blueGrey,
            child: Center(
              child: Text("Waiting for user response" , style: TextStyle(
                color: Colors.black45,
                fontSize: 18
              ),),
            ),
          ),
          Positioned(
            bottom: 100,
              right: 0,
              child: Container(
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
                child: _callConnected ? isLocalRendered ? RTCVideoView(_localRenderer , mirror: true,filterQuality: FilterQuality.medium, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,) : CircularLoading() : Container(),
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
                      onPressed: () => print("Muted"),
                      backgroundColor: Colors.green[200],
                      icon: Icons.mic_off_outlined,
                      iconColor: Colors.white,
                      radius: 60,
                    ),
                  IconCircleButton(
                    onPressed: () => print("End Call"),
                    backgroundColor: Colors.redAccent,
                    icon: Icons.call_end_outlined,
                    iconColor: Colors.white,
                    radius: 60,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
