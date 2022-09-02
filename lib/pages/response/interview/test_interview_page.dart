import 'package:flutter/material.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/response/interview/get_all_interviews_model.dart';

class TestInterview extends StatefulWidget {
  final Datum interView;

  const TestInterview({Key key, this.interView}) : super(key: key);

  @override
  _TestInterviewState createState() => _TestInterviewState();
}

class _TestInterviewState extends State<TestInterview> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Row(
            children: [
              MaterialButton(onPressed: () {

              },
                child: Text("Call"), color: kDarkColor,)
            ],
          ),
        ),
      ),
    );
  }
}
