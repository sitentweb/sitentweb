import 'package:flutter/material.dart';
import 'package:remark_app/config/constants.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({Key key}) : super(key: key);

  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDarkColor,
        title: Text(application_name , style: TextStyle(
          color: Colors.white
        ),),
      ),
      body: Container(
        child: Column(
          children: [
            Text('Complete Your Profile')
          ],
        ),
      ),
    );
  }
}
