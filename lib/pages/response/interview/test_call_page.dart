import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class TestCallPage extends StatefulWidget {
  const TestCallPage({Key key}) : super(key: key);

  @override
  _TestCallPageState createState() => _TestCallPageState();
}

class _TestCallPageState extends State<TestCallPage> {

  RTCPeerConnection _peerConnection;
  RTCVideoRenderer _youRenderer;
  RTCVideoRenderer _meRenderer;

  @override
  void initState() {
    // TODO: implement initState
    _createPeerConnection().then((pc) => _peerConnection = pc);
    super.initState();
  }

  Future<RTCPeerConnection> _createPeerConnection() async {

    Map<String, dynamic> configuration = {
      "iceServers": [     // Information about ICE servers - Use your own!
        {
          "urls": "stun:stun.stunprotocol.org"
        }
      ]
    };

    RTCPeerConnection peerConnection = await createPeerConnection(configuration);

    peerConnection.onIceCandidate = _handleIceCandidateEvent;
    peerConnection.onTrack = _handleTrackEvent;
    peerConnection.onRenegotiationNeeded = _handleNegotiationNeededEvent;
    peerConnection.onIceConnectionState = _handleICEConnectionStateChangeEvent;
    peerConnection.onIceGatheringState = _onicegatheringstatechange;
    peerConnection.onSignalingState = _onSignalingState;

    return peerConnection;
  }

  _handleIceCandidateEvent(RTCIceCandidate event) {
    if(event.candidate != null){
      print(event.candidate);
    }
  }

  _handleTrackEvent(stream) {
      _youRenderer.srcObject = stream;
  }

  _handleNegotiationNeededEvent() {
    _peerConnection.createOffer().then((offer) => _peerConnection.setLocalDescription(offer));
  }

  _handleICEConnectionStateChangeEvent(event) => print("Ice Connection State : ${_peerConnection.iceConnectionState} ");

  _onicegatheringstatechange(event) => print("Ice Gathering State : ${_peerConnection.iceGatheringState} ");

  _onSignalingState(event) => print("Signaling State : ${_peerConnection.signalingState} ");

  _handleVideoOfferMsg(msg) {
    MediaStream localStream = null;

    var yourName = msg.name;
    _createPeerConnection();

    RTCSessionDescription description = new RTCSessionDescription(msg.sdp , msg.offerType);

    _peerConnection.setRemoteDescription(description).then((value) {
      return getUserMedia();
    }).then((value) {
      return _peerConnection.createAnswer();
    }).then((answer) {
      return _peerConnection.setLocalDescription(answer);
    }).then((value) {
      print("Answer Created");
    });

  }

  _handleNewICECandidateEvent(msg) {
    var candidate = new RTCIceCandidate(msg.candidate , msg.sdpMid , msg.sdpMlineIndex);
    _peerConnection.addCandidate(candidate).catchError((error) => print(error));
  }

  getUserMedia() async {
    var mediaConstraints = {
      "audio": true, // We want an audio track
      "video": true // ...and we want a video track
    };

    MediaStream mediaStream = await navigator.mediaDevices.getUserMedia(mediaConstraints).then((localStream) {
      _meRenderer.srcObject = localStream;
      localStream.getTracks().forEach((track) => _peerConnection.addTrack(track , localStream));
      return localStream;
    }).catchError((e) => print(e));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: MaterialButton(
            onPressed: () {
              print("Answer");
            },
            child: Text("Answer"),
          ),
        ),
      ),
    );
  }
}
