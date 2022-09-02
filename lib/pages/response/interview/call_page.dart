import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:remark_app/apis/push/push_notification.dart';
import 'package:remark_app/apis/responses/interview/all_interviews_api.dart';
import 'package:remark_app/components/buttons/icon_circle_button.dart';
import 'package:remark_app/config/appSetting.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/response/interview/get_all_interviews_model.dart';
import 'package:sdp_transform/sdp_transform.dart';

class CallPage extends StatefulWidget {
  final Datum interview;

  const CallPage({Key key, this.interview}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {

  RTCPeerConnection _peerConnection;
  RTCVideoRenderer _localRenderer;
  RTCVideoRenderer _remoteRenderer;

  bool _offer = false;

  _createPeerConnection() async {

    Map<String, dynamic> configuration = {
      "iceServers" : [
        {
          "urls" : "stun:stun.l.google.com:19302"
        }
      ]
    };

    _peerConnection = await createPeerConnection(configuration);

    var mediaConstraints = {
      "audio" : true,
      "video" : true
    };

    await navigator.mediaDevices.getUserMedia(mediaConstraints)
    .then((mediaStream) {
      _localRenderer.srcObject = mediaStream;
      mediaStream.getTracks().forEach((element) {
        _peerConnection.addTrack(element, mediaStream);
      });
    });

    _peerConnection.onIceConnectionState = (e) => print(e);

    _peerConnection.onTrack = _handleTrack;

  }

  _handleTrack(RTCTrackEvent event){
    _remoteRenderer.srcObject = event.streams[0];
  }

  _createSDPOffer() async {

    var session;

    await _peerConnection.createOffer()
        .then((description) {

      session = parse(description.sdp);
     setState(() {
       _offer = true;
     });
      return _peerConnection.setLocalDescription(description);
    })
        .then((_) async {

      var data = jsonEncode({
        "notification_type" : "callOfferInitialize",
        'interviewType' : widget.interview.interviewType,
        "interviewID" : widget.interview.interviewId,
        "employerToken" : widget.interview.employerToken
      });

      await GetAllInterviewsApi().sendInterviewSession(widget.interview.interviewId, jsonEncode(session), "2");

      await SendPushNotification().send(data, widget.interview.employeeToken);
    });

    print("==============OFFER CREATED==================");

  }

  _getFirebaseNotifications() async   {

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if(message.data['notification_type'] == "callCandidate"){
        final response = GetAllInterviewsApi().getInterviewSession(widget.interview.interviewId);

        response.then((value) {
          var msg = {
            "offerString" : value['data']['employer_session']
          };

        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _createPeerConnection().then((_) {
      _createSDPOffer();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
}
