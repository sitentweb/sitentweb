import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:remark_app/apis/candidates/all_candidates_api.dart';
import 'package:remark_app/apis/education/education_api.dart';
import 'package:remark_app/apis/location/location_api.dart';
import 'package:remark_app/components/appbar/appbar.dart';
import 'package:remark_app/components/empty/empty_data.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/pages/candidates/all_candidates.dart';
import 'package:smart_select/smart_select.dart';

class SearchCandidates extends StatefulWidget {
  const SearchCandidates({Key key}) : super(key: key);

  @override
  _SearchCandidatesState createState() => _SearchCandidatesState();
}

class _SearchCandidatesState extends State<SearchCandidates> {

  List _skillsTag = [];
  List<S2Choice> _getPlaces = <S2Choice>[];
  String education = "";
  List locations = [];
  List<S2Choice> _getEducations = <S2Choice>[];
  TextEditingController _skillsController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _createListPlaces().then((places) {
        _getPlaces = places;
        setState(() {});
        print("got places");
    });
    _createListEducation().then((educations) {
      _getEducations = educations;
      setState(() {});
      print('got Education');
    });
    super.initState();
  }

  Future<List<S2Choice>> _createListPlaces() async {
    List<S2Choice> _getTempPlaces = <S2Choice>[];
    await Location().cityState().then((places) {
      places.data.forEach((place) {
        _getTempPlaces.add(S2Choice(value: "${place.place}", title: "${place.place}"));
      });
    });
    return _getTempPlaces;
  }

  Future<List<S2Choice>> _createListEducation() async {
    List<S2Choice> _getTempEducation = <S2Choice>[];
    await EducationApi().fetchEducation().then((educations) {
      educations.data.forEach((education) {
        _getTempEducation.add(S2Choice(value: education.educationName, title: education.educationName));
      });
    });

    return _getTempEducation;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [ApplicationAppBar()],
        iconTheme: IconThemeData(color: kDarkColor),
      ),
      body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(8),

            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Candidate Name",
                        hintText: "John",
                        border: OutlineInputBorder()
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    child: TextField(
                      controller: _skillsController,
                      decoration: InputDecoration(
                        labelText: "Candidate Skills",
                        hintText: "developer",
                        border: OutlineInputBorder()
                      ),
                      onSubmitted: (value) {
                          print('$value');
                        _skillsTag.add('"${value.toString()}"');
                        _skillsController.text = "";
                        print(_skillsTag);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Tags(
                      itemCount: _skillsTag.length,
                      itemBuilder: (index) {
                        String item = _skillsTag[index];
                        var title = item.replaceAll('"', '');
                        return ItemTags(
                          removeButton: ItemTagsRemoveButton(
                            onRemoved: () {
                              _skillsTag.removeAt(index);
                              setState(() {
                                
                              });
                              return true;
                            },
                          ),
                            index: index,
                            title: title,
                            color: kDarkColor,
                            textColor: Colors.white,
                          activeColor: kDarkColor,
                          onPressed: (i) {
                            _skillsTag.removeAt(index);
                            setState(() {

                            });
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    child: SmartSelect.single(
                        title: "Select Education",
                        choiceItems: _getEducations,
                        onChange: (value) {
                          setState(() {
                            education = value.value;
                          });
                        },)
                  ),

                  SizedBox(height: 20,),
                  Container(
                    child: SmartSelect.multiple(
                        title: "Select Locaiton",
                        choiceItems: _getPlaces,
                        placeholder: "Locations",
                        choiceEmptyBuilder: (context, value) => EmptyData(message: "Nothing Found",),
                        modalFilter: true,
                        modalConfirm: true,
                        modalConfig: S2ModalConfig(
                          filterAuto: true
                        ),
                        onChange: (value) {
                          List places = [];
                          value.value.forEach((place) {
                              places.add('"$place"');
                          });
                          setState(() {
                            locations = places;
                          });
                        },
                    )
                  ),
                  SizedBox(height: 20,),
                  Container(
                    child: Row(
                      children: [
                        // MaterialButton(
                        //   child: Text(""),
                        //   onPressed: () => print("Saved"),
                        // ),
                        Spacer(),
                        MaterialButton(
                          onPressed: () {
                            print(_nameController.text);
                            print(_skillsTag);
                            print(education);
                            print(locations);

                            List data = [
                              _nameController.text,
                              _skillsTag.toString(),
                              education,
                              locations
                            ];

                            Navigator.push(context, MaterialPageRoute(builder: (context) => Candidates(
                              isSearched: true,
                              data: data,
                            ) ,));

                          },
                          padding: EdgeInsets.all(14),
                          color: kDarkColor,
                          elevation: 8,
                          child: Text("Search" , style: TextStyle(
                              color: Colors.white
                          ),),
                        ),
                        Spacer(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}
