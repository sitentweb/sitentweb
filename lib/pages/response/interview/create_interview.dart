import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remark_app/apis/candidates/all_candidates_api.dart';
import 'package:remark_app/apis/responses/interview/all_interviews_api.dart';
import 'package:remark_app/config/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_select/smart_select.dart';

class CreateInterview extends StatefulWidget {
  const CreateInterview({Key key}) : super(key: key);

  @override
  _CreateInterviewState createState() => _CreateInterviewState();
}

class _CreateInterviewState extends State<CreateInterview> {
  List<S2Choice> _employees = [];
  List _selectedEmployeesID = [];
  TextEditingController _interviewTitle = TextEditingController();
  TextEditingController _interviewDate = TextEditingController();
  String _interviewDateTime = "";
  String _interviewType = "";
  String userID = "";

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    getCandidates().then((value) {
      setState(() {
        _employees = value;
      });
    });
    super.initState();
  }

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userID = pref.getString("userID");
    });
  }

  Future<List<S2Choice>> getCandidates() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<S2Choice> _getTempCandidates = [];

    await AllCandidates()
        .getCandidatesForList(pref.getString("userID"))
        .then((candidates) {
      candidates.data.userList.forEach((candidate) {
        _getTempCandidates
            .add(S2Choice(value: candidate.userId, title: candidate.userName));
      });
    });

    return _getTempCandidates;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  height: 100,
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Text(
                        "Select Employees",
                        style: GoogleFonts.poppins(),
                      ),
                      _employees == null || _employees.length == 0
                          ? Text(
                              "Fetching Employees",
                              style: GoogleFonts.poppins(),
                            )
                          : SmartSelect.multiple(
                              title:
                                  _employees == null || _employees.length == 0
                                      ? "Fetching Employees"
                                      : "Select Employees",
                              choiceItems: _employees,
                              modalConfirm: true,
                              modalFilter: true,
                              onChange: (value) {
                                print(value.value);
                                setState(() {
                                  _selectedEmployeesID = value.value;
                                });
                              },
                            )
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Text(
                        "Interview Title",
                        style: GoogleFonts.poppins(),
                      ),
                      TextField(
                        controller: _interviewTitle,
                        decoration: InputDecoration(
                            labelText: "Interview Title",
                            labelStyle: GoogleFonts.poppins(fontSize: 14),
                            border: InputBorder.none),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: ListView(
                    children: [
                      Text(
                        "Interview Date & Time",
                        style: GoogleFonts.poppins(),
                      ),
                      TextField(
                        controller: _interviewDate,
                        decoration: InputDecoration(
                          labelText: "Select Date",
                        ),
                        onTap: () async {
                          var _newDate;
                          var _newTime;
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 30)),
                          ).then((date) {
                            print(date);
                            setState(() {
                              _newDate = date.year.toString().padLeft(2, '0') +
                                  '-' +
                                  date.month.toString().padLeft(2, '0') +
                                  '-' +
                                  date.day.toString().padLeft(2, '0');
                            });
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((time) {
                              print(time);
                              _newTime = time.hour.toString().padLeft(2, '0') +
                                  ':' +
                                  time.minute.toString().padLeft(2, '0') +
                                  ':00';
                              print(_newDate);
                              print(_newTime);
                              setState(() {
                                _interviewDate.text = _newDate + ' ' + _newTime;
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
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: ListView(
                    children: [
                      Text(
                        "Interview Type",
                        style: GoogleFonts.poppins(),
                      ),
                      DropdownButtonFormField(
                        onChanged: (value) {
                          print(value);
                          _interviewType = value.toString();
                        },
                        value: "0",
                        hint: Text("Select Interview Type"),
                        items: [
                          DropdownMenuItem(
                            child: Text("Voice Call"),
                            value: "0",
                          ),
                          DropdownMenuItem(
                            child: Text("Video Call"),
                            value: "1",
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: MaterialButton(
                    onPressed: () {
                      if (_interviewTitle.text.isEmpty ||
                          _interviewDate.text.isEmpty) {
                        return false;
                      }

                      _selectedEmployeesID.forEach((element) async {
                        print(element);

                        await GetAllInterviewsApi()
                            .createInterview(
                                element,
                                userID,
                                _interviewTitle.text,
                                _interviewDate.text,
                                _interviewType)
                            .then((value) {
                          if (value.status) {
                            var snackBar = SnackBar(
                                content: Text(
                              "Interview Created Successfully",
                              style: GoogleFonts.poppins(),
                            ));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Navigator.pop(context);
                          }
                        });
                      });
                    },
                    child: Text("Create Interview"),
                    textColor: Colors.white,
                    color: kDarkColor,
                    elevation: 8,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
