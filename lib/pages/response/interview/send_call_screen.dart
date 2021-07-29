import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:remark_app/components/buttons/icon_circle_button.dart';
import 'package:remark_app/config/appSetting.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/pages/response/interview/video_call_screen.dart';

class SendCallScreen extends StatefulWidget {
  final employeePhoto;
  final employeeName;
  final employeeToken;
  final employeeID;
  const SendCallScreen({Key key, this.employeePhoto, this.employeeName, this.employeeToken, this.employeeID}) : super(key: key);

  @override
  _SendCallScreenState createState() => _SendCallScreenState();
}

class _SendCallScreenState extends State<SendCallScreen> {

  int employeeResponse;

  @override
  void initState() {
    // TODO: implement initState
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if(message.data['notification_type'] == 'receiveResponse'){
          var roomId = message.data['room_id'];
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VideoCallScreen(),));
        }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
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
                    backgroundImage: AppSetting.showUserImage(widget.employeePhoto),
                  ),
                  glowColor: kDarkColor,
                  showTwoGlows: true,
                  repeatPauseDuration: Duration(milliseconds: 200),
                  endRadius: 120),
              SizedBox(height: 10,),
              Text("Calling" , style: TextStyle(
                fontSize: 30
              ),),
              Text(employeeResponse == 1 ? "Employee accepted your request" : employeeResponse == 0 ? "Employee Rejected your request" : "Waiting for response" , style: TextStyle(
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
      ),
    );
  }
}
