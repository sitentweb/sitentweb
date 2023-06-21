import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remark_app/apis/location/location_api.dart';
import 'package:remark_app/components/appbar/appbar.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/config/tagConfig.dart';
import 'package:remark_app/controllers/job_controller.dart';
import 'package:remark_app/controllers/jobs/search_job_controller.dart';
import 'package:remark_app/pages/jobs/all_jobs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_select/awesome_select.dart';
// import 'package:dropdown_search/dropdown_search.dart';

class SearchJobs extends StatefulWidget {
  const SearchJobs({Key key}) : super(key: key);

  @override
  _SearchJobsState createState() => _SearchJobsState();
}

class _SearchJobsState extends State<SearchJobs> {
  JobController jobController = Get.put(JobController());
  SearchJobController searchJobController = Get.put(SearchJobController());

  List _skillTags = [];
  TextEditingController _jobTitleController = TextEditingController();
  TextEditingController _skillsController = TextEditingController();
  double _currentSalaryRange = 10000;
  double _maxSalary = 10000000;
  double _minSalary = 0;
  TextEditingController _salaryController = TextEditingController();
  TextEditingController _placesController = TextEditingController();
  TextEditingController _searchPlaces = TextEditingController();

  List<String> places = <String>[];
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
    await Location().cityState().then((data) {
      data.data.forEach((element) {
        var place = "${element.place}";
        places.add(place.toString());
      });
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        searchJobController.resetController();
        Get.back();
        return await true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kDarkColor,
          title: Text("Search Job"),
        ),
        body: SafeArea(child: Obx(() {
          return Container(
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
                      controller: searchJobController.titleController,
                      enableSuggestions: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter Job Title Here"),
                      style: GoogleFonts.poppins(fontSize: 14),
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
                    controller: searchJobController.skillController,
                    onSubmitted: (value) async {
                      TagConfig.addNewTag(value);
                      if (value != '') {
                        searchJobController.skillTags.add(value);
                        searchJobController.skillController.text = "";
                      }
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Skills",
                        labelStyle: GoogleFonts.poppins()),
                  ),
                  Text(
                    'Press enter to add skills in list',
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Tags(
                      itemCount: searchJobController.skillTags.length,
                      itemBuilder: (index) {
                        var tag = searchJobController.skillTags[index];
                        return ItemTags(
                          title: tag,
                          index: index,
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                          color: kLightColor,
                          activeColor: kLightColor,
                          textActiveColor: Colors.white,
                          onPressed: (i) {
                            searchJobController.skillTags.removeAt(index);
                          },
                          removeButton: ItemTagsRemoveButton(
                            color: Colors.white,
                            onRemoved: () {
                              searchJobController.skillTags.removeAt(index);
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
                  Divider(),
                  // Container(
                  //   child: Column(
                  //     children: [
                  //       Text(
                  //         "Salary Range (Per Annum)",
                  //         style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  //       ),
                  //       Slider.adaptive(
                  //         min: searchJobController.minSalary,
                  //         max: searchJobController.maxSalary,
                  //         value: searchJobController.currentSalary.value,
                  //         onChanged: (value) {
                  //           searchJobController.setCurrentSalary(value);
                  //         },
                  //         activeColor: kDarkColor,
                  //         inactiveColor: kLightColor,
                  //       ),
                  //       Container(
                  //         width: size.width,
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Text(
                  //               "0",
                  //               style: GoogleFonts.poppins(
                  //                   fontWeight: FontWeight.bold,
                  //                   color: Colors.grey),
                  //             ),
                  //             Container(
                  //               width: 150,
                  //               child: TextField(
                  //                 controller:
                  //                     searchJobController.salaryController,
                  //                 onChanged: (value) {
                  //                   searchJobController
                  //                       .setCurrentSalary(double.parse(value));
                  //                 },
                  //                 decoration: InputDecoration(
                  //                     contentPadding: EdgeInsets.symmetric(
                  //                       vertical: 0,
                  //                     ),
                  //                     hintText: "Salary",
                  //                     hintStyle: GoogleFonts.poppins()),
                  //               ),
                  //             ),
                  //             Text(_maxSalary.round().toString(),
                  //                 style: GoogleFonts.poppins(
                  //                     fontWeight: FontWeight.bold,
                  //                     color: Colors.grey))
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Preferred Location",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DropdownSearch<String>(
                          items: places,
                          popupProps: PopupProps.bottomSheet(
                              searchFieldProps: TextFieldProps(
                                  decoration: InputDecoration(
                                      labelText: "Search Place")),
                              showSelectedItems: true,
                              showSearchBox: true,
                              title: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Text(
                                  "Select Preferred Location",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              )),
                          dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Choose Preferred Location")),
                          onChanged: (value) {
                            searchJobController.setSelectedPlace(value);
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
                        onPressed: () =>
                            searchJobController.collectSearchData(),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        color: kDarkColor,
                        textColor: Colors.white,
                        elevation: 8,
                        child: Text(
                          "Search Jobs",
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        })),
      ),
    );
  }
}
