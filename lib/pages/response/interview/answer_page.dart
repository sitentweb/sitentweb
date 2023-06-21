import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:remark_app/apis/push/push_notification.dart';
import 'package:remark_app/components/buttons/icon_circle_button.dart';
import 'package:remark_app/config/appSetting.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/response/interview/get_all_interviews_model.dart';

class AnswerPage extends StatefulWidget {
  final Datum interview;
  final String session;
  const AnswerPage({Key key, this.interview, this.session}) : super(key: key);

  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  RTCPeerConnection _peerConnection;
  RTCVideoRenderer _localRenderer;
  RTCVideoRenderer _remoteRenderer;

  _getFirebaseNotifications() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
  }

  @override
  void initState() {
    // TODO: implement initState
    _getFirebaseNotifications();
    super.initState();
  }

  _createPeerConnection() async {
    Map<String, dynamic> configuration = {
      "iceServers": [
        {"urls": "stun:stun.l.google.com:19302"}
      ]
    };

    _peerConnection = await createPeerConnection(configuration);

    var mediaConstraints = {"audio": true, "video": true};

    await navigator.mediaDevices
        .getUserMedia(mediaConstraints)
        .then((mediaStream) {
      _localRenderer.srcObject = mediaStream;
      mediaStream.getTracks().forEach((element) {
        _peerConnection.addTrack(element, mediaStream);
      });
    });

    _peerConnection.onIceConnectionState = (e) => print(e);

    _peerConnection.onTrack = _handleTrack;
  }

  _handleTrack(RTCTrackEvent event) {
    _remoteRenderer.srcObject = event.streams[0];
  }

  _handleVideoOffer(msg) async {
    _createPeerConnection();

    RTCSessionDescription description =
        new RTCSessionDescription(msg['session'], "offer");
  }

  _handleIceCandidate(RTCIceCandidate e) {
    if (e.candidate != null) {
      print("Candidate is available");
      print(e.toMap());

      var data = jsonEncode({
        "notification_type": "callCandidate",
        "interviewID": widget.interview.interviewId,
        "candidate": {
          "candidate": e.candidate,
          "sdpMid": e.sdpMid,
          "sdpMlineIndex": e.sdpMLineIndex
        }
      });

      SendPushNotification().send(data, widget.interview.employerToken);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  backgroundImage:
                      AppSetting.showUserImage(widget.interview.employerLogo),
                ),
                endRadius: 120),
            SizedBox(
              height: 10,
            ),
            Text(
              "${widget.interview.employerName}",
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: IconCircleButton(
                      backgroundColor: Colors.redAccent,
                      radius: 60,
                      icon: widget.interview.interviewType == "0"
                          ? Icons.call_end_rounded
                          : Icons.videocam_off_rounded,
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
                      onPressed: () {},
                      icon: widget.interview.interviewType == "0"
                          ? Icons.call
                          : Icons.videocam,
                      iconColor: Colors.green,
                      radius: 60,
                      backgroundColor: Colors.white,
                      title: "Answer",
                      textColor: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}
