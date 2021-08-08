import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:remark_app/components/appbar/appbar.dart';
import 'package:remark_app/components/drawer/application_drawer.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/config/userSetting.dart';
import 'package:remark_app/pages/candidates/all_candidates.dart';
import 'package:remark_app/pages/candidates/search_candidates.dart';
import 'package:remark_app/pages/dashboard/dashboard.dart';
import 'package:remark_app/pages/jobs/all_jobs.dart';
import 'package:remark_app/pages/jobs/applied_jobs.dart';
import 'package:remark_app/pages/jobs/search_job.dart';
import 'package:remark_app/pages/notification/job_notification.dart';
import 'package:remark_app/pages/profile/view_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

class HomePage extends StatefulWidget {
  final userType;

  const HomePage({Key key, this.userType}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userID;
  PersistentTabController _tabController =
      PersistentTabController(initialIndex: 0);

  Socket socket;

  @override
  void initState() {
    // TODO: implement initState
    _getFirebaseNotification();
    getUserData();
    super.initState();
  }

  
  _getFirebaseNotification() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) { 
        if(message.data['notification_type'] == 'logged_out'){
          UserSetting.unsetUserSession();
          showDialog(
            context: context,
             builder: (context) => AlertDialog(
               title: Text("You are logged out from this device"),
                actions: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height:30,
                    child: MaterialButton(
                      onPressed: () => exit(0),
                      child: Text("Ok")
                    ),
                  )
                ],
             )
          );
      }
    });
  }

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userID = pref.getString("userID");
    });

    final QuickActions quickActions = QuickActions();

    String searchLocalize = widget.userType  == "2" ? 'Search Candidate' :'Search Job';

    try{
      quickActions.initialize((shortcutType) {
        if (shortcutType == 'search') {
          print('Navigating to search job');
          pushNewScreen(
              context,
              withNavBar: false,
              customPageRoute: MaterialPageRoute(
                builder: (context) => widget.userType == "2" ? SearchCandidates() : SearchJobs(),
              )
          );
        }
        // More handling code...
      });
    }catch(e){
      print(e);
    }

    quickActions.setShortcutItems(<ShortcutItem>[
        ShortcutItem(type: 'search', localizedTitle: "$searchLocalize", icon: 'icon_main')
    ]);

    print(userID);
  }

  List<Widget> _tabScreens() {
    return [
      widget.userType == "2"
          ? Dashboard()
          : Jobs(
        isSearch: false,
        searchData: [],
      ),
      widget.userType == "2" ? Candidates(isSearched: false, data: [],) : AppliedJobs(),
      JobNotification(
        userID: userID,
      ),
      ViewProfile(),
    ];
  }

  double iconSize = 20;
  Color inactiveColor = kLightColor.withOpacity(1);

  List<PersistentBottomNavBarItem> _tabItems() {
    return [
      PersistentBottomNavBarItem(
          icon: Icon(
            FontAwesomeIcons.home,
            size: iconSize,
          ),
          title: ("Home"),
          textStyle: GoogleFonts.poppins(),
          activeColorPrimary: kDarkColor,
          inactiveColorPrimary: inactiveColor),
      PersistentBottomNavBarItem(
          icon: Icon(
            widget.userType == "2"
                ? FontAwesomeIcons.briefcase
                : FontAwesomeIcons.solidThumbsUp,
            size: iconSize,
          ),
          title: widget.userType == "2" ? ("Candidates") : ("Applied Jobs"),
          activeColorPrimary: kDarkColor,
          inactiveColorPrimary: inactiveColor),
      PersistentBottomNavBarItem(
          icon: Icon(
            FontAwesomeIcons.solidBell,
            size: iconSize,
          ),
          title: ("Notification"),
          activeColorPrimary: kDarkColor,
          inactiveColorPrimary: inactiveColor),
      PersistentBottomNavBarItem(
          icon: Icon(
            FontAwesomeIcons.userTie,
            size: iconSize,
          ),
          title: ("Profile"),
          activeColorPrimary: kDarkColor,
          inactiveColorPrimary: inactiveColor),
    ];
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      endDrawerEnableOpenDragGesture: false,
        appBar: AppBar(
          iconTheme: IconThemeData.fallback(),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Hero(tag:"splashscreenImage" ,child: Container(
              child: Image.asset(application_logo , width: 40,))),
          actions: [
            InkWell(
                onTap: () {
                  if(widget.userType == "2"){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchCandidates(),));
                  }else{
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchJobs(),));
                  }
                },
                child: Container(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.search , color: kDarkColor,)))
          ],
        ),
      drawer: Drawer(
        child: ApplicationDrawer(),
      ),
      body: PersistentTabView(
          context,
          onWillPop: _onWillPop,
          controller: _tabController,
          screens: _tabScreens(),
          items: _tabItems(),
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          decoration: NavBarDecoration(
              borderRadius: BorderRadius.circular(10),
              colorBehindNavBar: Colors.white),
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: ItemAnimationProperties(
              duration: Duration(milliseconds: 200), curve: Curves.ease),
              screenTransitionAnimation: ScreenTransitionAnimation(
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200)),
          navBarStyle: NavBarStyle.style1,

        ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => exit(0),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }
}
