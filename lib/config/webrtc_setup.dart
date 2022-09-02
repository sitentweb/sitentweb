import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:remark_app/apis/responses/interview/all_interviews_api.dart';
import 'package:sdp_transform/sdp_transform.dart';

class WebRTCSetup {

  static RTCPeerConnection peerConnection;

  // CREATE PEER CONNECTION
  static Future<RTCPeerConnection> createNewPeerConnection(Future<MediaStream> userMedia , RTCVideoRenderer _remoteRenderer) async {

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

    MediaStream _localStream = await userMedia;

    RTCPeerConnection pc = await createPeerConnection(configuration , offerSdpConstraints);

    pc.addStream(_localStream);

    pc.onIceCandidate = (e) {
      if(e.candidate != null){
        print("Candidate is available");
        print(e.toMap());
      }
    };

    pc.onIceConnectionState = (e) {
      print("===================ICE CONNECTION CHANGED================");
      print(e);
    };

    pc.onAddStream = (stream) {
      print('addStream: ' + stream.id);
        _remoteRenderer.srcObject = stream;
    };

    return pc;

  }


  // CREATING OFFER
  static Future<RTCSessionDescription> createOffer(interviewID , userType) async {

    print("============OFFER IS CREATING==========");

    RTCSessionDescription description = await peerConnection.createOffer({
      'offerToReceiveVideo' : 1
    });



    var session = parse(description.sdp);

    // var data = jsonEncode({
    //   "notification_type" : "getOffer",
    //   "interviewID" : widget.interviewID
    // });
    //
    await GetAllInterviewsApi().sendInterviewSession(interviewID, jsonEncode(session), userType);
    //
    // await SendPushNotification().send(data, widget.employeeToken);

    print("==============OFFER CREATED==================");


    return description;


  }



  // SET REMOTE DESCRIPTION
  static setRemoteDescription(String jsonString , bool offer) async {

    dynamic session = await jsonDecode(jsonString);

    String sdp = write(session , null);

    RTCSessionDescription description = RTCSessionDescription(sdp, offer ? 'answer' : 'offer');

    print(description.toMap());

    await peerConnection.setRemoteDescription(description);

  }

  // CREATE ANSWER
  static Future<RTCSessionDescription> createAnswer(interviewID , userType) async {
    print("========================CREATING ANSWER ============");
    RTCSessionDescription description = await peerConnection.createAnswer({
      "offerToReceiveVideo" : 1
    });

    var session = parse(description.sdp);

    await GetAllInterviewsApi().sendInterviewSession(interviewID, jsonEncode(session), userType);

    print("========================CREATED ANSWER ============");

    return description;

  }


  // SET CANDIDATE
  static setCandidate(String jsonString , RTCPeerConnection peerConnection) async {

    print('====================SET CANDIDATE STARTED========');


    dynamic session = await jsonDecode(jsonString);

    print(session['candidate']);

    dynamic candidate = RTCIceCandidate(session['candidate'] , session['sdpMid'] , session['sdpMlineIndex']);

    await peerConnection.addCandidate(candidate);
    print('+++++++++++SET CANDIDATE ENDED========');

  }


}