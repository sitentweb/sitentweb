import 'package:flutter/material.dart';
import 'package:remark_app/apis/jobs/save_jobs_api.dart';
import 'package:remark_app/components/appbar/appbar.dart';
import 'package:remark_app/components/empty/empty_data.dart';
import 'package:remark_app/components/job_card/job_card.dart';
import 'package:remark_app/components/loading/circular_loading.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/jobs/save_jobs_list_model.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class SaveJobs extends StatefulWidget {
  final userID;
  const SaveJobs({Key key, this.userID}) : super(key: key);

  @override
  _SaveJobsState createState() => _SaveJobsState();
}

class _SaveJobsState extends State<SaveJobs> {

  Future<SaveJobsListModel> _saveJobs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<SaveJobsListModel> fetchSavedJobsList() async {
    _saveJobs = SaveJobsApi().saveJobsList(widget.userID);

    return _saveJobs;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [ApplicationAppBar()],
        iconTheme: IconThemeData(color: kDarkColor),
      ),
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          child: FutureBuilder<SaveJobsListModel>(
              future: SaveJobsApi().saveJobsList(widget.userID),
              builder: (context, snapshot) {
                 if(snapshot.hasData){
                   return snapshot.data.status ? ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: snapshot.data.data.length,
                       itemBuilder: (context, index) {
                        var job = snapshot.data.data[index];
                         return JobCard(
                           userID: job.userId,
                           jobTitle: job.jobTitle,
                           jobSkills: job.jobKeySkills,
                           jobLink: job.jobSlug,
                           companyImage: job.companyLogo,
                           companyName: job.companyName,
                           companyLocation: job.companyAddress,
                           jobID: job.jobId,
                           applyBtn: int.parse(job.jobAppliedStatus),
                           experience: job.jobExtExperience,
                           minimumSalary: job.jobMinimumSalary,
                           maximumSalary: job.jobMaximumSalary,
                           timeAgo: timeAgo.format(job.jobCreatedAt),
                           isUserApplied: true,
                           isUserSavedThis: true,
                         );
                       },
                   ) : EmptyData(message: "Not Saved any job",) ;

                 }else if(snapshot.hasError){
                   return Text("Has Error!");
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
