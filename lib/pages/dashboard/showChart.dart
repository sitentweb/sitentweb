import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remark_app/config/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowChart extends StatefulWidget {
  final company;
  final job;
  final interview;
  final questionnaire;
  const ShowChart(
      {Key key, this.company, this.job, this.interview, this.questionnaire})
      : super(key: key);

  @override
  _ShowChartState createState() => _ShowChartState();
}

class _ShowChartState extends State<ShowChart> {
  int touchedIndex = -1;
  String userID;

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  Future getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userID = pref.getString('userID');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5),
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(PieChartData(
            pieTouchData: PieTouchData(touchCallback: (pieTouched) {
              setState(() {
                final desireTouch =
                    pieTouched.touchInput is! PointerExitEvent &&
                        pieTouched.touchInput is! PointerUpEvent;
                if (desireTouch && pieTouched.touchedSection != null) {
                  touchedIndex = pieTouched.touchedSection.touchedSectionIndex;
                } else {
                  touchedIndex = -1;
                }
              });
            }),
            borderData: FlBorderData(show: false),
            sectionsSpace: 1,
            centerSpaceRadius: 40,
            sections: getData(widget.company, widget.job, widget.interview,
                widget.questionnaire))),
      ),
    );
  }

  calculateThePercentages(company, job, interview, questionnaire) {
    // TOTAL OF ALL THE DATA
    var total = double.parse(company) +
        double.parse(job) +
        double.parse(interview) +
        double.parse(questionnaire);

    // APPLYING PERCENTAGE FORMULA
    var companyPercentage = double.parse(company) * 100 / total;
    var jobPercentage = double.parse(job) * 100 / total;
    var interviewPercentage = double.parse(interview) * 100 / total;
    var questionnairePercentage = double.parse(questionnaire) * 100 / total;

    var data = {
      "company": companyPercentage.roundToDouble(),
      "job": jobPercentage.roundToDouble(),
      "interview": interviewPercentage.roundToDouble(),
      "questionnaire": questionnairePercentage.roundToDouble()
    };

    return data;
  }

  List<PieChartSectionData> getData(company, job, interview, questionnaire) {
    var data = calculateThePercentages(company, job, interview, questionnaire);
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 80.0 : 60.0;

      switch (i) {
        case 0:
          return pieChartSectData(data['questionnaire'], questionnaire,
              'Questionnaire', Colors.redAccent, radius);
        case 1:
          return pieChartSectData(data['company'], company, 'Companies',
              Colors.orangeAccent, radius);
        case 2:
          return pieChartSectData(data['interview'], interview, 'Interview',
              Colors.greenAccent, radius);
        case 3:
          return pieChartSectData(
              data['job'], job, 'Jobs', Colors.blueAccent, radius);
        default:
          print('Error in chart');
      }

    });


  }

  pieChartSectData(value, bValue, bTitle, color, radius) {
    return PieChartSectionData(
        value: value,
        showTitle: false,
        badgeWidget: value >= 0.0 ? badgeShowTitle(bValue, bTitle , color) : Container(),
        badgePositionPercentageOffset: 1.50,
        radius: radius,
        color: color);
  }

  Widget badgeShowTitle(bValue, bTitle , color) {
    return Container(
      height: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "$bValue",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: color),
          ),
          Text(
            "$bTitle",
            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: color),
          )
        ],
      ),
    );
  }
}
