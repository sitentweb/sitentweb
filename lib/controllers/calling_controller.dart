import 'dart:developer';

import 'package:flutter_webrtc/flutter_webrtc.dart' as WebRTC;
import 'package:get/get.dart';

class CallingController extends GetxController {
  WebRTC.RTCPeerConnection peerConnection;
  WebRTC.RTCVideoRenderer localRenderer = WebRTC.RTCVideoRenderer();
  WebRTC.RTCVideoRenderer remoteRenderer = WebRTC.RTCVideoRenderer();
  WebRTC.MediaStream localStream;
  WebRTC.MediaStream peerStream;

  // FLOW OF WEBRTC
  /*

  1. CREATE PEER CONNECTION FUNCTION
  2. GET MEDIA DEVICES
  3. PEER CONNECTION
  4. ADD LOCAL STREAM
  5. HANDLE ICE CANDIDATES
  6. HANDLE ICE CANDIDATE STATE
  7. ADD TRACK (ADD LOCAL STREAM TO TRACK)

  SAME PROCESS FOR THE ANOTHER USER
  */

  Future getMediaDevices() async {
    Map<String, dynamic> contraints = {"audio": true, "video": true};

    
    await WebRTC.navigator.mediaDevices.getUserMedia(contraints).then((value) => null);
    // final mediaDevices = await

    

    // log(mediaDevices.id, name: 'Media Devices');


  }

  Future<WebRTC.RTCPeerConnection> createDevicePeerConnection() async {
    Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"}
      ]
    };

    final Map<String, dynamic> offerSdpContraints = {
      "mandatory": {"offerToReceiveAudio": true, "OfferToReceiveVideo": true},
      "optional": []
    };

    peerStream = await getMediaDevices();

    WebRTC.RTCPeerConnection pc =
        await WebRTC.createPeerConnection(configuration, offerSdpContraints);

    pc.addStream(peerStream);

    pc.onIceCandidate = (candidate) => handleIceCandidate;

    pc.onIceConnectionState = (state) => handleIceCandidateState;

    pc.onAddStream = (stream) {
      stream.getVideoTracks().forEach((element) {
        print(element.id);
      });
    };
  }

  handleIceCandidate(candidate) async {}

  handleIceCandidateState(state) async {}
}
