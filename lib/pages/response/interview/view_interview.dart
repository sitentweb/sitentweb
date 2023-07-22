import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:remark_app/apis/push/push_notification.dart';
import 'package:remark_app/apis/responses/interview/all_interviews_api.dart';
import 'package:remark_app/components/buttons/icon_circle_button.dart';
import 'package:remark_app/config/appSetting.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/controllers/calling_controller.dart';
import 'package:remark_app/model/response/interview/get_all_interviews_model.dart';
import 'package:remark_app/notifier/interview_calling_notifier.dart';
import 'package:remark_app/pages/jobs/search_job.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ViewInterview extends StatefulWidget {
  final Datum interview;
  const ViewInterview({Key key, this.interview}) : super(key: key);
  @override
  _ViewInterviewState createState() => _ViewInterviewState();
}

class _ViewInterviewState extends State<ViewInterview> {
  CallingController callingController = CallingController();
  int screenResponse = 0;
  List candidates = [];
  RTCPeerConnection _peerConnection;
  RTCVideoRenderer _localRenderer = new RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();
  MediaStream _localStream;
  MediaStream _peerStream;
  String userID;
  String userType;
  String userMobile;
  bool _offer = false;
  var sendCandidate = false;
  bool setremotedescription = false;
  var offerMsg;
  bool offerReceived = false;
  bool _voiceMuted = false;
  String targetUsername;
  Socket socket;

  @override
  void initState() {
    // TODO: implement initState
    _getUserData();
    _initializerRenderer();
    // _createPeerConnection().then((value) {
    //   setState(() {
    //     _peerConnection = value;
    //   });
    // });
    super.initState();
  }

  rescheduleInterview(
      userID, interviewID, interviewTime, interviewReason) async {
    final res = await GetAllInterviewsApi().rescheduleInterview(
        interviewID, interviewTime, interviewReason, userID);

    if (res.status) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "Interview Rescheduled",
        style: GoogleFonts.poppins(),
      )));
      setState(() {
        widget.interview.interviewTime = interviewTime.toString();
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ViewInterview(
              interview: widget.interview,
            ),
          ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "Something went wrong",
        style: GoogleFonts.poppins(),
      )));
    }
  }

  deleteInterview(interviewID) async {
    final res = await GetAllInterviewsApi().deleteInterview(interviewID);

    if (res.status) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Interview Cancelled")));
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Something went wrong")));
    }
  }

  _socketSetup() {
    socket = AppSetting.initSocket();

    setState(() {});

    socket.emit('registerMe', {"id": userMobile});

    socket.on('user added', (data) => print(data));

    socket.on('get_call', (data) {
      print(data);
      _createPeerConnection().then((value) {
        setState(() {
          _peerConnection = value;
        });
      });
      _handleGetCall(data);
    });

    socket.on('receive-answer', (data) {
      print(data);
      var desc = data['data']['sdp']['sdp'];

      var parseDes = parse(desc);

      Provider.of<InterviewCallingNotifier>(context, listen: false)
          .changeScreenResponse(2);

      var writeDes = write(parseDes, null);

      _setRemoteDescription(jsonEncode(writeDes), 'answer');
    });

    socket.on('receive-ice-candidate', (data) {
      print(data);
      _setCandidate(jsonEncode(data['data']['data']['candidate']));
    });

    socket.on('end-call', (data) {
      print('End Call');
      _endCall();
    });
  }

  _handleGetCall(sdp) async {
    // print(['sdp']);

    print(sdp);

    setState(() {
      targetUsername = sdp['data']['from'];
      offerMsg = parse(sdp['data']['sdp']['sdp']);
    });

    print(offerMsg);

    Provider.of<InterviewCallingNotifier>(context, listen: false)
        .changeScreenResponse(1);
  }

  // CREATED PEER CONNECTION SUCCESSFULLY
  Future<RTCPeerConnection> _createPeerConnection() async {
    print("============= STARTING PEER CONNECTION =============");

    Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"}
      ]
    };

    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {"OfferToReceiveAudio": true, "OfferToReceiveVideo": true},
      "optional": []
    };

    _peerStream = await _getUserMediaDevices();

    RTCPeerConnection pc =
        await createPeerConnection(configuration, offerSdpConstraints);

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

      Provider.of<InterviewCallingNotifier>(context, listen: false)
          .addRemoteRendererStream(_remoteRenderer, stream);
      // setState(() {
      //   _remoteRenderer.srcObject = stream;
      // });
    };

    Provider.of<InterviewCallingNotifier>(context, listen: false)
        .createPeerConnection(pc, true);

    return pc;
  }

  _createOffer() async {
    RTCSessionDescription description =
        await _peerConnection.createOffer({'offerToReceiveVideo': 1});

    var session = parse(description.sdp);

    setState(() {
      _offer = true;
    });

    _peerConnection.setLocalDescription(description);
  }

  _handleTrackEvent(RTCTrackEvent event) {
    _remoteRenderer.srcObject = event.streams[0];
  }

  _handleIceCandidate(RTCIceCandidate e) {
    if (e.candidate != null) {
      candidates.add(jsonEncode({
        "candidate": e.candidate,
        "sdpMid": e.sdpMid,
        "sdpMlineIndex": e.sdpMLineIndex
      }));

      if (userType == "1") {
        print("===========ICE CANDIATE SENT ==========");
        socket.emit('send-ice-candidate', {
          "to": targetUsername,
          "data": {"candidate": e.toMap()}
        });
      }
    }
  }

  _handleICEConnectionStateChangeEvent(event) {
    print("Ice Connection State : ${_peerConnection.iceConnectionState} ");

    if (_peerConnection.iceConnectionState ==
        RTCIceConnectionState.RTCIceConnectionStateFailed) {
      // var data = jsonEncode({
      //   "notification_type" : "connection_failed",
      // });

      // SendPushNotification().send(data, widget.interview.employerToken);
    }
  }

  _handleNegotiationNeededEvent() async {
    var session;

    await _peerConnection.createOffer().then((description) {
      session = parse(description.sdp);

      Provider.of<InterviewCallingNotifier>(context, listen: false)
          .changeOffer(true);

      _peerConnection.setLocalDescription(description);

      return description;
    }).then((desc) async {
      socket.emit('send_call', {
        "to": widget.interview.employeeMobile,
        "data": {"from": widget.interview.employerMobile, "sdp": desc.toMap()}
      });
    });

    print("==============OFFER CREATED==================");
  }

  _createAnswer() async {
    print("========================CREATING ANSWER ============");

    RTCSessionDescription description =
        await _peerConnection.createAnswer({"offerToReceiveVideo": 1});

    var session = parse(description.sdp);

    await GetAllInterviewsApi().sendInterviewSession(
        widget.interview.interviewId, jsonEncode(session), userType);

    _peerConnection.setLocalDescription(description);

    print("========================CREATED ANSWER ============");

    socket.emit('send-answer', {
      "to": targetUsername,
      "data": {"sdp": session}
    });
  }

  _sendCandidate() async {
    print("===================SEARCHING CANDIDATE========================");
    if (userType == "1" && candidates.isNotEmpty && sendCandidate == false) {
      print("===================GOT CANDIDATE========================");

      setState(() {
        sendCandidate = true;
      });
    } else {
      print("==================CANDIDATE NOT FOUND=======================");
    }
  }

  _handleVideoOfferMsg(description, type) async {
    // var descr = jsonDecode(sdp['data']['data']['sdp']);
    // targetUsername = sdp['data']['data']['to'];
    // console.log();
    print(description);

    String transform = write(description, null);

    RTCSessionDescription desc = RTCSessionDescription(transform, type);

    print("++++++++++ RTC SESSION SET +++++++ ");

    print(desc.toMap());

    await _peerConnection.setRemoteDescription(desc).then((desc) {
      print("++++++++++ REMOTE DESCRIPTION SET ++++++++++");

      print("++++++++++ CREATING ANSWER +++++++++++++");
      return _peerConnection.createAnswer();
    }).then((answer) {
      print("+++++++++++++ SETTING LOCAL DESCRIPTION ++++++++++");
      _peerConnection.setLocalDescription(answer);
      return answer;
    }).then((des) {
      print(targetUsername);

      var data = {"from": userMobile, "sdp": des.toMap()};

      print(data);

      socket
          .emit('send-answer', {"to": targetUsername.toString(), "data": data});

      print(socket.id);

      // var msg = {
      //     name: myUsername,
      //     target: targetUsername,
      //     type: "video-answer",
      //     sdp: myPeerConnection.localDescription
      // };

      // sendToServer(msg);
    }).catchError((e) => print(e));
  }

  // SET REMOTE DESCRIPTION
  _setRemoteDescription(jsonString, type) async {
    dynamic sdp = await jsonDecode(jsonString);

    // String sdp = write(session , null);

    RTCSessionDescription description = RTCSessionDescription(sdp, type);

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
    print(session['sdpMid']);
    print(session['sdpMLineIndex']);
    int sdpMLineIndex = session['sdpMLineIndex'];

    RTCIceCandidate candidate =
        RTCIceCandidate(session['candidate'], session['sdpMid'], sdpMLineIndex);

    print("ICE CANDIDATE CREATED");

    await _peerConnection.addCandidate(candidate);

    print("=================CANDIDATE SET SUCCESSFULLY=================");
  }

  // GOT USER MEDIA DEVICES
  _getUserMediaDevices() async {
    await callingController.getMediaDevices();

    // Map<String, dynamic> constraints = {"audio": true, "video": true};

    // _localStream =
    //     await navigator.mediaDevices.getUserMedia(constraints).then((stream) {
    //   _localStream = stream;
    //   Provider.of<InterviewCallingNotifier>(context, listen: false)
    //       .addLocalRendererStream(_localRenderer, stream);

    //   return _localStream;
    // });

    // return _localStream;
    return false;
  }

  // INITIALIZED THE RENDERERS
  _initializerRenderer() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  _endCall() async {
    _localRenderer.srcObject.getTracks().forEach((element) {
      element.stop();
    });

    if (_remoteRenderer != null) {
      if (_remoteRenderer.srcObject != null) {
        _remoteRenderer.srcObject.getTracks().forEach((element) {
          element.stop();
        });
      }
    }

    _remoteRenderer.srcObject.dispose();
    _localRenderer.srcObject.dispose();

    setState(() {
      _voiceMuted = false;
    });

    _localStream.getTracks().forEach((element) {
      element.stop();
    });

    _peerStream.getTracks().forEach((element) {
      element.stop();
    });

    _localStream.dispose();
    _peerStream.dispose();

    _peerConnection.onIceCandidate = null;
    _peerConnection.onIceConnectionState = null;

    _peerConnection.close();
    _peerConnection.dispose();

    setState(() {
      _offer = false;
    });

    Provider.of<InterviewCallingNotifier>(context, listen: false)
        .changeScreenResponse(0);
  }

  // GOT USER DATA FROM SHARED PREFERENCES
  _getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userID = pref.getString("userID");
      userType = pref.getString("userType");
      userMobile = pref.getString("userMobile");
    });

    _socketSetup();
  }

  // DISPOSE INITIALIZERS
  @override
  void dispose() {
    // TODO: implement dispose
    // if(_localRenderer != null){
    //   _localRenderer.dispose();
    //   _localRenderer = null;
    // }

    _localRenderer.dispose();
    _remoteRenderer.dispose();

    // if(_remoteRenderer != null){
    //   _remoteRenderer.dispose();
    //   _remoteRenderer = null;
    // }

    if (_peerStream != null) {
      _peerStream.dispose();
      _peerStream = null;
    }

    if (_localStream != null) {
      _localStream.dispose();
      _localStream = null;
    }

    socket.disconnect();
    socket.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData.fallback(),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Hero(
              tag: "splashscreenImage",
              child: Container(
                  child: Image.asset(
                application_logo,
                width: 40,
              ))),
          actions: [
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchJobs(),
                      ));
                },
                child: Container(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.search,
                      color: kDarkColor,
                    )))
          ],
        ),
        body: Consumer<InterviewCallingNotifier>(
          builder: (context, value, child) {
            return value.screenResponse == 1 && userType == "1"
                ? incomingCallScreen()
                : value.screenResponse == 1 && userType == "2"
                    ? outGoingCallScreen()
                    : value.screenResponse == 2
                        ? mainCallScreen()
                        : interviewPage();
          },
        )
        // screenResponse == 1 && userType == "1" ? incomingCallScreen() : screenResponse == 1 && userType == "2" ? outGoingCallScreen() : screenResponse == 2 ? mainCallScreen() : interviewPage()   ,
        );
  }

  Widget interviewPage() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: kDarkColor),
                child: Row(
                  children: [
                    AvatarGlow(
                      endRadius: 45,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AppSetting.showUserImage(
                            userType == "1"
                                ? widget.interview.employerLogo
                                : widget.interview.employeePhoto),
                        backgroundColor: Colors.white,
                      ),
                      showTwoGlows: true,
                      glowColor: kDarkColor,
                      curve: Curves.easeIn,
                      repeat: true,
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${userType == "1" ? widget.interview.employerName : widget.interview.employeeName}",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 22),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${widget.interview.interviewType == "0" ? "Voice Call Interview" : "Video Call Interview"}",
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    ),
                    if (userType == "2")
                      Container(
                        alignment: Alignment.center,
                        child: IconCircleButton(
                          onPressed: () {
                            return showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  "Sure want to delete interview?",
                                  style: GoogleFonts.poppins(fontSize: 14),
                                ),
                                actions: [
                                  Row(
                                    children: [
                                      Spacer(),
                                      MaterialButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Cancel"),
                                      ),
                                      MaterialButton(
                                        onPressed: () => deleteInterview(
                                            widget.interview.interviewId),
                                        color: kDarkColor,
                                        child: Text(
                                          "Ok",
                                          style: GoogleFonts.poppins(
                                              color: Colors.white),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                          icon: Icons.delete,
                          backgroundColor: Colors.redAccent,
                          iconColor: Colors.white,
                          iconSize: 10,
                          radius: 40,
                        ),
                      )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Interview Title",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${widget.interview.interviewTitle}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Interview Type",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${widget.interview.interviewType == '0' ? "Voice Call Interview" : 'Video Call Interview'}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Interview Date",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${widget.interview.interviewTime}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Interview Status",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${widget.interview.interviewAgreeStatus == '0' ? "Not Respond" : widget.interview.interviewAgreeStatus == '1' ? 'Agreed' : widget.interview.interviewAgreeStatus == '2' ? 'Rejected' : widget.interview.interviewAgreeStatus == "3" ? 'Rescheduled' : ''}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (userType == "1" &&
                              widget.interview.interviewAgreeStatus == "0")
                            IconCircleButton(
                              onPressed: () async {
                                await GetAllInterviewsApi()
                                    .interviewResponse(
                                        widget.interview.interviewId, "1")
                                    .then((res) {
                                  if (res.status) {
                                    setState(() {
                                      widget.interview.interviewAgreeStatus =
                                          "1";
                                    });
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ViewInterview(
                                              interview: widget.interview),
                                        ));
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
                          if (userType == "1" &&
                              widget.interview.interviewAgreeStatus == "0")
                            IconCircleButton(
                              onPressed: () async {
                                await GetAllInterviewsApi()
                                    .interviewResponse(
                                        widget.interview.interviewId, "2")
                                    .then((res) {
                                  if (res.status) {
                                    setState(() {
                                      widget.interview.interviewAgreeStatus =
                                          "2";
                                    });
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ViewInterview(
                                              interview: widget.interview),
                                        ));
                                  }
                                });
                              },
                              icon: Icons.cancel,
                              title: "Reject",
                              textColor: Colors.black,
                              backgroundColor:
                                  Colors.redAccent.withOpacity(0.6),
                              iconColor: Colors.white,
                              radius: 50,
                            ),
                          if (userType == "1" &&
                              widget.interview.interviewAgreeStatus != "3")
                            IconCircleButton(
                              onPressed: () async {
                                await GetAllInterviewsApi()
                                    .interviewResponse(
                                        widget.interview.interviewId, "3")
                                    .then((res) {
                                  if (res.status) {
                                    setState(() {
                                      widget.interview.interviewAgreeStatus =
                                          "3";
                                    });
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ViewInterview(
                                              interview: widget.interview),
                                        ));
                                  }
                                });
                              },
                              icon: Icons.history_rounded,
                              title: "Reschedule",
                              textColor: Colors.black,
                              backgroundColor: kDarkColor.withOpacity(0.6),
                              iconColor: Colors.white,
                              radius: 50,
                            ),
                          if (userType == "2" &&
                              widget.interview.interviewAgreeStatus == "1")
                            IconCircleButton(
                              radius: 40,
                              iconColor: Colors.white,
                              backgroundColor: kDarkColor.withOpacity(0.6),
                              icon: widget.interview.interviewType == "0"
                                  ? Icons.call
                                  : Icons.videocam,
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

                                _handleNegotiationNeededEvent();

                                Provider.of<InterviewCallingNotifier>(context,
                                        listen: false)
                                    .changeScreenResponse(1);
                              },
                            ),
                          if (userType == "2")
                            IconCircleButton(
                              onPressed: () {
                                TextEditingController _interviewDate =
                                    TextEditingController();
                                TextEditingController _interviewReason =
                                    TextEditingController();
                                String error = "";
                                showMaterialModalBottomSheet(
                                    context: context,
                                    builder: (context) => StatefulBuilder(
                                          builder: (context, setState) =>
                                              Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5),
                                            height: 350,
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Reschedule",
                                                  style: GoogleFonts.poppins(),
                                                ),
                                                Container(
                                                  height: 100,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15),
                                                  child: ListView(
                                                    children: [
                                                      Text(
                                                        "Interview Date & Time",
                                                        style: GoogleFonts
                                                            .poppins(),
                                                      ),
                                                      TextField(
                                                        controller:
                                                            _interviewDate,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              "Select Date",
                                                        ),
                                                        onTap: () async {
                                                          var _newDate;
                                                          var _newTime;
                                                          showDatePicker(
                                                            context: context,
                                                            initialDate:
                                                                DateTime.now(),
                                                            firstDate:
                                                                DateTime.now(),
                                                            lastDate: DateTime
                                                                    .now()
                                                                .add(Duration(
                                                                    days: 30)),
                                                          ).then((date) {
                                                            print(date);
                                                            setState(() {
                                                              _newDate = date
                                                                      .year
                                                                      .toString()
                                                                      .padLeft(
                                                                          2,
                                                                          '0') +
                                                                  '-' +
                                                                  date.month
                                                                      .toString()
                                                                      .padLeft(
                                                                          2,
                                                                          '0') +
                                                                  '-' +
                                                                  date.day
                                                                      .toString()
                                                                      .padLeft(
                                                                          2,
                                                                          '0');
                                                            });
                                                            showTimePicker(
                                                              context: context,
                                                              initialTime:
                                                                  TimeOfDay
                                                                      .now(),
                                                            ).then((time) {
                                                              print(time);
                                                              setState(() =>
                                                                  error = "");
                                                              _newTime = time
                                                                      .hour
                                                                      .toString()
                                                                      .padLeft(
                                                                          2,
                                                                          '0') +
                                                                  ':' +
                                                                  time.minute
                                                                      .toString()
                                                                      .padLeft(
                                                                          2,
                                                                          '0') +
                                                                  ':00';
                                                              print(_newDate);
                                                              print(_newTime);
                                                              setState(() {
                                                                _interviewDate
                                                                        .text =
                                                                    _newDate +
                                                                        ' ' +
                                                                        _newTime;
                                                              });
                                                            });
                                                          });
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 100,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15),
                                                  child: ListView(
                                                    children: [
                                                      Text(
                                                          "Rescheduling Reason"),
                                                      TextField(
                                                        controller:
                                                            _interviewReason,
                                                        decoration:
                                                            InputDecoration(
                                                                hintText:
                                                                    "Reason"),
                                                        maxLines: 2,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  error,
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.redAccent),
                                                ),
                                                MaterialButton(
                                                  color: kDarkColor,
                                                  onPressed: () {
                                                    if (_interviewDate.text ==
                                                        "") {
                                                      setState(() => error =
                                                          "Please select date & time");
                                                      return false;
                                                    } else if (_interviewReason
                                                            .text ==
                                                        "") {
                                                      setState(() => error =
                                                          "Please give a reason for rescheduling interview");
                                                    } else {
                                                      setState(
                                                          () => error = "");
                                                    }

                                                    //  UPDATE RESCHEDULE INTERVIEW HERE

                                                    rescheduleInterview(
                                                        userID,
                                                        widget.interview
                                                            .interviewId,
                                                        _interviewDate.text,
                                                        _interviewReason.text);

                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "Submit",
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ));
                              },
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

  Widget incomingCallScreen() {
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
                      onPressed: () {
                        var description = jsonEncode(offerMsg['sdp']);
                        var type = "offer";
                        _handleVideoOfferMsg(offerMsg, type);
                        Provider.of<InterviewCallingNotifier>(context,
                                listen: false)
                            .changeScreenResponse(2);
                      },
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

  Widget outGoingCallScreen() {
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
                  backgroundImage:
                      AppSetting.showUserImage(widget.interview.employeePhoto),
                ),
                glowColor: kDarkColor,
                showTwoGlows: true,
                repeatPauseDuration: Duration(milliseconds: 200),
                endRadius: 120),
            SizedBox(
              height: 10,
            ),
            Text(
              "Calling",
              style: TextStyle(fontSize: 30),
            ),
            Text(
              "Waiting for response",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Container(
              child: IconCircleButton(
                onPressed: () async {
                  print("ending call");
                  var data = jsonEncode({"notification_type": "end_call"});
                  var sendEndCall = userType == "1"
                      ? widget.interview.employerToken
                      : userType == "2"
                          ? widget.interview.employeeToken
                          : "";
                  await SendPushNotification()
                      .send(data, sendEndCall)
                      .then((_) => {_endCall()});
                },
                iconSize: 30,
                icon: Icons.call_end_rounded,
                backgroundColor: Colors.redAccent,
                iconColor: Colors.white,
                radius: 60,
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  Widget mainCallScreen() {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          key: Key('remote'),
          width: size.width,
          height: size.height,
          color: Colors.blueGrey,
          child: Center(child: Consumer<InterviewCallingNotifier>(
            builder: (context, value, child) {
              if (widget.interview.interviewType == "1") {
                return value.remoteRenderer != null
                    ? RTCVideoView(
                        value.remoteRenderer,
                        mirror: true,
                      )
                    : Text("Waiting for user");
              } else {
                return Text("Audio Connected");
              }
            },
          )
              // _remoteRenderer.srcObject != null ? RTCVideoView(_remoteRenderer , mirror: true,) : Text("Waiting for user")
              ),
        ),
        if (widget.interview.interviewType == "1")
          Positioned(
              bottom: 100,
              right: 0,
              child: Container(
                  key: Key('local'),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  width: size.width * 0.3,
                  height: size.height * 0.2,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: Offset(2, 3))
                  ]),
                  child: Consumer<InterviewCallingNotifier>(
                    builder: (context, value, child) {
                      return value.localRenderer != null
                          ? RTCVideoView(
                              value.localRenderer,
                              mirror: true,
                            )
                          : Text("Waiting for response");
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
                    Provider.of<InterviewCallingNotifier>(context,
                            listen: false)
                        .muteLocalRendererStream(_localRenderer, _voiceMuted);
                  },
                  backgroundColor:
                      _voiceMuted ? Colors.redAccent[200] : Colors.green[200],
                  icon: _voiceMuted ? Icons.mic_off : Icons.mic_none_outlined,
                  iconColor: Colors.white,
                  radius: 60,
                ),
                IconCircleButton(
                  onPressed: () async {
                    print("ending call");

                    socket.emit('end-call', {
                      "to": userType == "1"
                          ? widget.interview.employerMobile
                          : widget.interview.employeeMobile,
                      "data": "just end this call"
                    });

                    _endCall();
                  },
                  backgroundColor: Colors.redAccent,
                  icon: Icons.call_end_outlined,
                  iconColor: Colors.white,
                  radius: 60,
                ),
                if (widget.interview.interviewType == "1")
                  IconCircleButton(
                    onPressed: () async {
                      await Provider.of<InterviewCallingNotifier>(context,
                              listen: false)
                          .switchCameraLocal(
                              _localRenderer, _localStream, true);
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
