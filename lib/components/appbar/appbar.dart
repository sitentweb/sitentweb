import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:remark_app/components/drawer/application_drawer.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/main.dart';
import 'package:remark_app/pages/jobs/search_job.dart';

class ApplicationAppBar extends StatelessWidget {

  const ApplicationAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
            width: size.width,
            height: 80,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Hero(tag:"splashscreenImage" ,child: Container(
                    child: Image.asset(application_logo , width: 40,))),
                Spacer(),
                InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SearchJobs(),));
                    },
                    child: Container(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.search , color: kDarkColor,)))
              ],
            ),
          );

  }
}
