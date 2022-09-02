import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:remark_app/apis/push/push_notification.dart';
import 'package:remark_app/components/buttons/icon_circle_button.dart';
import 'package:remark_app/config/appSetting.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/pages/response/interview/video_call_screen.dart';

class ReceiveCallScreen extends StatefulWidget {
  final employerName;
  final employerLogo;
  final employerToken;
  final interviewType;
  const ReceiveCallScreen({Key key, this.employerName, this.employerLogo, this.employerToken, this.interviewType}) : super(key: key);

  @override
  _ReceiveCallScreenState createState() => _ReceiveCallScreenState();
}

class _ReceiveCallScreenState extends State<ReceiveCallScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
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
                    backgroundImage: AppSetting.showUserImage(widget.employerLogo),
                  ),
                  endRadius: 120),
              SizedBox(height: 10,),
              Text("${widget.employerName}" , style: TextStyle(
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
                      icon: widget.interviewType == "0" ? Icons.call_end_rounded : Icons.videocam_off_rounded,
                      iconColor: Colors.white,
                      title: "Cancel",
                      textColor: Colors.white,
                      onPressed: () async {
                          var data = jsonEncode({"notification_type": "receiveResponse" , "response_type" : "0"} );
                          await SendPushNotification().send(data, widget.employerToken);
                          Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    child: IconCircleButton(
                      onPressed: () async {
                        print("Answered");
                        var roomId = "dafadsfas";
                        var data = jsonEncode({"notification_type": "receiveResponse" , "response_type" : "1" , "room_id" : roomId} );
                        await SendPushNotification().send(data, widget.employerToken);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VideoCallScreen(),));
                      },
                      icon: widget.interviewType == "0" ? Icons.call : Icons.videocam,
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
      ),
    );
  }
}
