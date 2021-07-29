import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class InterviewCallingNotifier extends ChangeNotifier {
    int _screenResponse = 0;
    bool _offer = false;
    RTCPeerConnection _peerConnection;
    RTCVideoRenderer _localRenderer;
    RTCVideoRenderer _remoteRenderer;
    MediaStream _localStream;

    int get screenResponse => _screenResponse;
    bool get offer => _offer;
    RTCPeerConnection get peerConnection => _peerConnection;
    RTCVideoRenderer get localRenderer => _localRenderer;
    RTCVideoRenderer get remoteRenderer => _remoteRenderer;
    MediaStream get localStream => _localStream;

    void changeOffer(bool changeOffer){
      _offer = changeOffer;

      notifyListeners();
    }

    void createPeerConnection(RTCPeerConnection pc , bool connectType){

      if(connectType){
        _peerConnection = pc;
      }else{
        _peerConnection = null;
      }

      notifyListeners();

    }

    void changeScreenResponse(int screenRes){
      _screenResponse = screenRes;
      notifyListeners();
    }

    void addLocalRendererStream(RTCVideoRenderer lRenderer , MediaStream stream){
      _localRenderer = lRenderer;
      _localRenderer.srcObject = stream;
      notifyListeners();
    }

    void addRemoteRendererStream(RTCVideoRenderer rRenderer , MediaStream stream){
      _remoteRenderer = rRenderer;
      _remoteRenderer.srcObject = stream;
      notifyListeners();
    }

    void muteLocalRendererStream(RTCVideoRenderer lRenderer , bool muteStatus){
      _localRenderer = lRenderer;
      _localRenderer.muted = muteStatus;
      notifyListeners();
    }

    Future<void> switchCameraLocal(RTCVideoRenderer lRenderer , MediaStream lStream , bool switchTo) async {
      _localRenderer = lRenderer;
      _localStream = lStream;
      await Helper.switchCamera(_localStream.getVideoTracks()[0]);
      print(_localStream.getVideoTracks()[0].getConstraints());
    }

}