import 'package:flutter/material.dart';
import 'package:remark_app/apis/candidates/hired_candidates.dart';
import 'package:remark_app/components/loading/circular_loading.dart';
import 'package:remark_app/config/appSetting.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/candidates/fetch_hired_candidates.dart';
import 'package:remark_app/pages/candidates/view_candidate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class HiredCandidates extends StatefulWidget {
  const HiredCandidates({Key key}) : super(key: key);

  @override
  _HiredCandidatesState createState() => _HiredCandidatesState();
}

class _HiredCandidatesState extends State<HiredCandidates> {

  var userID;
  Future<FetchHiredCandidatesModel> _fetchHiredCandidates;

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userID = pref.getString("userID");
      _fetchHiredCandidates = HiredCandidatesApi().fetchHiredCandidates(userID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        backwardsCompatibility: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back , color: kDarkColor),
        ),
        centerTitle: true,
        title: Hero(tag:"splashscreenImage" ,child: Container(
            child: Image.asset(application_logo , width: 40,))),
      ),
      body: SafeArea(
        child: Container(
          child: FutureBuilder<FetchHiredCandidatesModel>(
            future: _fetchHiredCandidates,
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return ListView.builder(
                  itemCount: snapshot.data.data.length,
                  itemBuilder: (context, index) {
                    var candidates = snapshot.  data.data[index];
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: ListTile(
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ViewCandidate(jobID: candidates.jobId, userUserName: candidates.userUsername,)));
                        },
                        title: Text("${candidates.userName}"),
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          backgroundImage: AppSetting.showUserImage(candidates.userPhoto),
                        ),
                        subtitle: Text("${candidates.jobTitle}"),
                        trailing: Text(timeAgo.format(candidates.statusDate) , style: TextStyle(
                          fontSize: 12
                        ),),
                      ),
                    );
                  },
                );
              }else if(snapshot.hasError){
                print(snapshot.error);
                return Text("${snapshot.error}");
              }else{
                return CircularLoading();
              }
            },
          ),
        ),
      ),
    );
  }
}
