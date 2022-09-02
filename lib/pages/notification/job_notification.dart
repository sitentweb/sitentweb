import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:remark_app/apis/jobs/view_job.dart';
import 'package:remark_app/apis/notification/notification_api.dart';
import 'package:remark_app/apis/user/UserApi.dart';
import 'package:remark_app/components/appbar/appbar.dart';
import 'package:remark_app/components/drawer/application_drawer.dart';
import 'package:remark_app/components/empty/empty_data.dart';
import 'package:remark_app/components/loading/circular_loading.dart';
import 'package:remark_app/config/appSetting.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/notification_list_model.dart';
import 'package:remark_app/pages/candidates/view_candidate.dart';
import 'package:remark_app/pages/jobs/search_job.dart';
import 'package:remark_app/pages/jobs/view_job.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class JobNotification extends StatefulWidget {
  final userID;
  const JobNotification({Key key, this.userID}) : super(key: key);

  @override
  _JobNotificationState createState() => _JobNotificationState();
}

class _JobNotificationState extends State<JobNotification> {
  Future<NotificationListModel> _notificationList;
  String userType;

  @override
  void initState() {
    // TODO: implement initState
    receiveNotification();
    getUserData();
    super.initState();
  }


  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userType = pref.getString("userType");
    });

  }

  receiveNotification() async {
    setState(() {
      _notificationList = NotificationApi().receiveNotification(widget.userID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: FutureBuilder<NotificationListModel>(
            future: _notificationList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.status) {
                  return ListView.builder(
                    itemCount: snapshot.data.data.length,
                    itemBuilder: (context, index) {
                      var notice = snapshot.data.data[index];
                      return ListTile(
                        onTap: () async {
                          if (notice.notificationType == "0") {
                            await NotificationApi()
                                .updateNotification(notice.notificationId).then((value) {
                                  print("Status Changed");
                            });

                            setState(() {
                              notice.notificationType = "1";
                            });
                          }

                          if(userType == "2"){
                            var employeeID = notice.notificationUserId;
                            await UserApi()
                                .fetchUserData(employeeID)
                                .then((user) {
                                  pushNewScreen(
                                      context,
                                      customPageRoute: MaterialPageRoute(builder: (context) => ViewCandidate(
                                        jobID: notice.notificationJobId,
                                        userUserName: user.data.userUsername,
                                      ),
                                  ),
                                    withNavBar: false
                              );
                              // showMaterialModalBottomSheet(
                              //   context: context,
                              //   useRootNavigator: true,
                              //   bounce: true,
                              //   builder: (context) => ViewCandidate(
                              //     jobID: notice.notificationJobId,
                              //     userUserName: user.data.userUsername,
                              //   ),
                              // );
                            });
                          }
                        },
                        tileColor: notice.notificationType == "0"
                            ? Colors.grey[100]
                            : Colors.white,
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${notice.notificationTitle}",
                                style: GoogleFonts.poppins(fontSize: 14 ,fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            if (notice.notificationType == "0")
                              Icon(
                                Icons.circle,
                                size: 8,
                                color: Colors.black,
                              )
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                  onTap: () async {
                                    showMaterialModalBottomSheet(
                                        context: context,
                                        useRootNavigator: true,
                                        builder: (context) => ViewJob(
                                              jobID: notice.notificationJobId,
                                              userID:
                                                  notice.notificationReceiverId,
                                            ));
                                  },
                                  child: Text("${notice.notificationSubTitle}" , style: GoogleFonts.poppins(), overflow: TextOverflow.ellipsis, ) ,),
                            ),
                            Text(
                              timeAgo.format(notice.notificationCreatedAt),
                              style:
                              GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                            )
                          ],
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          backgroundImage: AppSetting.showUserImage(
                              "${notice.notificationIcon}"),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                      child: EmptyData(
                    message: "No Notification",
                  ));
                }
              } else {
                return CircularLoading();
              }
            },
          ),
        ),
      ),
    );
  }
}
