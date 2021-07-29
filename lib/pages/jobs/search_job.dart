import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remark_app/apis/location/location_api.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/config/tagConfig.dart';
import 'package:remark_app/pages/jobs/all_jobs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_select/smart_select.dart';

class SearchJobs extends StatefulWidget {
  const SearchJobs({Key key}) : super(key: key);

  @override
  _SearchJobsState createState() => _SearchJobsState();
}

class _SearchJobsState extends State<SearchJobs> {
  List _skillTags = [];
  TextEditingController _jobTitleController = TextEditingController();
  TextEditingController _skillsController = TextEditingController();
  double _currentSalaryRange = 10000;
  double _maxSalary = 1000000;
  double _minSalary = 0;
  TextEditingController _salaryController = TextEditingController();
  TextEditingController _placesController = TextEditingController();
  TextEditingController _searchPlaces = TextEditingController();

  List<S2Choice<String>> places = <S2Choice<String>>[];
  List<S2Choice<String>> searchPlaces = <S2Choice<String>>[];
  List<S2Choice<String>> defaultPlaces = <S2Choice<String>>[];

  List _defPlaces = [];
  String defaultPlace = "Select Location";

  @override
  void initState() {
    // TODO: implement initState
    getLocations();
    super.initState();
  }

  collectSearchData() {
    var title = _jobTitleController.text;
    var skills = _skillTags;
    var salary = _salaryController.text;
    var location = defaultPlace;

    List<String> data = [];

    data.add(title);
    data.add(skills.toString());
    data.add(salary);
    data.add(location);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Jobs(isSearch: true, searchData: data),
        ));
  }

  getLocations() async {
    List<S2Choice<String>> getPlaces = [];

    await Location().cityState().then((data) {
      data.data.forEach((element) {
        var place = "${element.place}";

        getPlaces.add(S2Choice<String>(value: place, title: place));
      });
    });

    setState(() {
      places = getPlaces;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Job Title",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    controller: _jobTitleController,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter Job Title Here"),
                        style: GoogleFonts.poppins(
                          fontSize: 14
                        ),
                  ),
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Skills",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  enableSuggestions: true,
                  autofillHints: ["hello"],
                  controller: _skillsController,
                  onSubmitted: (value) async {
                    TagConfig.addNewTag(value);
                    print(value);
                    _skillTags.add(value);
                    _skillsController.text = "";
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Skills" , labelStyle: GoogleFonts.poppins()),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: Tags(
                    itemCount: _skillTags.length,
                    itemBuilder: (index) {
                      var tag = _skillTags[index];
                      return ItemTags(
                        title: tag,
                        index: index,
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                        color: kLightColor,
                        activeColor: kLightColor,
                        textActiveColor: Colors.white,
                        onPressed: (i) {
                          setState(() {
                            _skillTags.removeAt(index);
                          });
                        },
                        removeButton: ItemTagsRemoveButton(
                          color: Colors.white,
                          onRemoved: () {
                            setState(() {
                              _skillTags.removeAt(index);
                            });
                            return true;
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: Column(
                    children: [
                      Text(
                        "Salary Range (Per Annum)",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      Slider.adaptive(
                        min: _minSalary,
                        max: _maxSalary,
                        value: _currentSalaryRange,
                        onChanged: (value) {
                          setState(() {
                            _currentSalaryRange = value;
                            _salaryController.text = value.round().toString();
                          });
                        },
                        activeColor: kDarkColor,
                        inactiveColor: kLightColor,
                      ),
                      Container(
                        width: size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "0",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            Container(
                              width: 150,
                              child: TextField(
                                controller: _salaryController,
                                onChanged: (value) {
                                  var currSal = double.parse(value) ?? 0;

                                  if (currSal >= _maxSalary) {
                                    currSal = _maxSalary;
                                  } else if (currSal <= _minSalary) {
                                    currSal = _minSalary;
                                  }

                                  setState(() {
                                    _currentSalaryRange = currSal;
                                  });
                                },
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 0,
                                    ),
                                    hintText: "Salary" , hintStyle: GoogleFonts.poppins()),
                              ),
                            ),
                            Text(_maxSalary.round().toString(),
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        child: Column(
                          children: [
                            Text(
                              "Preferred Location",
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                            ),
                            SmartSelect<String>.multiple(
                              title: defaultPlace,
                              choiceItems: places,
                              placeholder: "",
                              choiceConfig:
                                  S2ChoiceConfig(type: S2ChoiceType.checkboxes),
                              choiceStyle: S2ChoiceStyle(
                                showCheckmark: false,
                              ),
                              modalFilter: true,
                              modalFilterHint: "Search Location",
                              modalConfirm: true,
                              modalType: S2ModalType.fullPage,
                              modalConfig: S2ModalConfig(
                                filterAuto: true,
                              ),
                              onChange: (state) {
                                setState(() {
                                  _defPlaces = state.value;

                                  defaultPlace = _defPlaces.join(",");
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: size.width,
                        height: 50,
                        child: Center(
                          child: MaterialButton(
                            onPressed: () => collectSearchData(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            color: kDarkColor,
                            textColor: Colors.white,
                            elevation: 8,
                            child: Text("Search Jobs" ,style: GoogleFonts.poppins(),),
                          ),
                        ),
                      )
                    ],
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
