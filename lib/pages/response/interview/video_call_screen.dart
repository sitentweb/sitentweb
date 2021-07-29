import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:remark_app/apis/push/push_notification.dart';
import 'package:remark_app/apis/responses/interview/all_interviews_api.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoCallScreen extends StatefulWidget {
  final employeeToken;
  final employerToken;
  final interviewID;
  const VideoCallScreen({Key key, this.employeeToken, this.employerToken, this.interviewID}) : super(key: key);

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  List candidates = [];
  bool _offer = false;
  var offerSession;
  var userType;
  RTCPeerConnection _peerConnection;
  MediaStream _localStream;
  MediaStream _mediaStream;
  final _rtcVideoRenderer = RTCVideoRenderer();
  final _rVideoRenderer = RTCVideoRenderer();

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    _initializeRenderer();
    _createPeerConnection().then((pc) {
      _peerConnection = pc;
    });
    _getOfferFromLocal();
    super.initState();
  }

  _initializeRenderer() async {
    await _rtcVideoRenderer.initialize();
    await _rVideoRenderer.initialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _rtcVideoRenderer.dispose();
    _rVideoRenderer.dispose();
    _mediaStream.dispose();
    super.dispose();
  }



  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userType = pref.getString("userType");
    });

  }

  _getOfferFromLocal() async {

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

        print("------------------BROADCAST RECEIVED BY USER------------------");

        if(message.data['notification_type'] == "getOffer"){

          var interviewID = message.data['interviewID'];

          final response = GetAllInterviewsApi().getInterviewSession(interviewID);

          response.then((value) {
            _setRemoteDescription(value['data']['employer_session']);
          });


        }else if(message.data['notification_type'] == "getAnswer"){

          var interviewID = message.data['interviewID'];
          var candidate = message.data['candidate'];

          final response = GetAllInterviewsApi().getInterviewSession(interviewID);

          response.then((value) {

              _setRemoteDescription(value['data']['employee_session']);
              //
              _setCandidate(candidate);
          });

          // _setRemoteDescription(session);
          // _setCandidate(candidate);
        }

        print("------------------BROADCAST RECEIVED BY USER FINISHED------------------");

    });


  }

  //---------------------- CREATING PEER CONNECTION ------------------

  Future<RTCPeerConnection> _createPeerConnection() async {
    print("=========MAKING PEER CONNECTION============");
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



    _localStream = await getUserMediaDevices();

    RTCPeerConnection pc = await createPeerConnection(configuration , offerSdpConstraints);

    pc.addStream(_localStream);

    pc.onIceCandidate = (e) {
        if(e.candidate != null){
          print("Candidate is available");
          print(e.toMap());

            candidates.add({
              "candidate" : e.candidate,
              "sdpMid" : e.sdpMid,
              "sdpMlineIndex" : e.sdpMlineIndex
            });


        }
    };

    pc.onIceConnectionState = (e) {
      print("===================ICE CONNECTION CHANGED================");
      print(e);
    };

    pc.onAddStream = (stream) {
      print('addStream: ' + stream.id);
      setState(() {
        _rVideoRenderer.srcObject = stream;
      });
    };

    return pc;
  }

  // --------------------CREATED PEER CONNECTION ---------------------


  // ------------------CREATING OFFER--------------------------------------

  _createOffer() async {

    print("============OFFER IS CREATING==========");

    RTCSessionDescription description = await _peerConnection.createOffer({
      'offerToReceiveVideo' : 1
    });

    var session = parse(description.sdp);
    _offer = true;

    var data = jsonEncode({
      "notification_type" : "getOffer",
      "interviewID" : widget.interviewID
    });

    await GetAllInterviewsApi().sendInterviewSession(widget.interviewID, jsonEncode(session), userType);

    await SendPushNotification().send(data, widget.employeeToken);

    await _peerConnection.setLocalDescription(description);

    print("==============OFFER CREATED==================");

  }

  //---------------------OFFER CREATED--------------------------------


  // -------------------CREATING DESCRIPTION OF CREATED OFFER--------------

  _setRemoteDescription(jsonString) async {

    dynamic session = await jsonDecode(jsonString);

    String sdp = write(session , null);

    RTCSessionDescription description = RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');

    print(description.toMap());

    await _peerConnection.setRemoteDescription(description);


  }

  // ------------------CREATED DESCRIPTION OF CREATED OFFER----------------

  // ---------------CREATING ANSWER AFTER CREATING DESCRIPTION-------------

  _createAnswer() async {
    print("========================CREATING ANSWER ============");
      RTCSessionDescription description = await _peerConnection.createAnswer({
        "offerToReceiveVideo" : 1
      });

      var session = parse(description.sdp);

      await GetAllInterviewsApi().sendInterviewSession(widget.interviewID, jsonEncode(session), userType);

      _peerConnection.setLocalDescription(description);
    print("========================CREATED ANSWER ============");

    if(candidates.isNotEmpty){
      print("===================GOT CANDIDATE========================");
      var data = jsonEncode({
        "notification_type" : "getAnswer",
        "interviewID" : widget.interviewID,
        "candidate" : candidates[0]
      });

      SendPushNotification().send(data, widget.employerToken);
    }else{
      print("==================CANDIDATE NOT FOUND=======================");
    }

  }

  // ---------------CREATED ANSWER AFTER CREATING DESCRIPTION-------------

  // --------------SETTING CANDIDATE ON ANSWERING ---------------------

  _setCandidate(jsonString) async {

      print('====================SET CANDIDATE STARTED========');


      dynamic session = await jsonDecode(jsonString);

      print(session['candidate']);

      dynamic candidate = RTCIceCandidate(session['candidate'] , session['sdpMid'] , session['sdpMlineIndex']);

      await _peerConnection.addCandidate(candidate);
      print('+++++++++++SET CANDIDATE ENDED========');

  }



  // ------------SETTING CANDIDATE IS DONE---------------------------

  getUserMediaDevices() async {

    Map<String , dynamic> constraints = {
      "audio" : false,
      "video" : true
    };

      await navigator.mediaDevices.getUserMedia(constraints).then((value) {
        setState(() {
          _mediaStream = value;
        });
      });


    //AFTER GETTING THE MEDIA DEVICES LETS INITIALIZE THE VIDEO RENDERER
      _rtcVideoRenderer.srcObject = _mediaStream;

    // _peerConnection.addStream(_mediaStream);
    return _mediaStream;


  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Container(
                key: Key("local"),
                width: size.width * 0.5,
                height: size.height * 0.5,
                child: RTCVideoView(_rtcVideoRenderer , mirror: true,),
              ),
              Container(
                key: Key("remote"),
                width: size.width * 0.5,
                height: size.height * 0.5,
                child: RTCVideoView(_rVideoRenderer , mirror: true,),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                    onPressed: _createOffer,
                    child: Text("Call Me"),
                ),
                MaterialButton(
                  onPressed: _createAnswer,
                  child: Text("Answer"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
