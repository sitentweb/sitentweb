import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/response/questionnaire/questionnaire_questions.dart';

class PreviewQuestionnaire extends StatelessWidget {
  final List<QuestionnaireQuestionsModel> questionnaire;
  const PreviewQuestionnaire({Key key, this.questionnaire}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back , color: kDarkColor, )),
        title: Image.asset(application_logo , width: 50,),
      ),
      body: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Swiper(
                itemCount: questionnaire.length,
                loop: false,
              itemBuilder: (context, index) {
                var q = questionnaire[index];

                return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10
                    ),
                    child: Container(
                      width: size.width,
                      height: size.height,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: size.width,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                  color: kDarkColor,
                                  borderRadius: BorderRadius.all(Radius.circular(50))
                              ),
                              child: Text("Question ${index + 1}" , style: GoogleFonts.poppins(
                                  color: Colors.white
                              ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                                alignment: Alignment.center,
                                height: 80,
                                child: Text("${q.question}" , style: GoogleFonts.poppins(),)
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 30),
                              height: 300,
                              child: ListView.builder(
                                itemCount: q.options.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, opIndex) {
                                  return InkWell(
                                    child: Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 5
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(30)),
                                            color: q.rightAnswer == opIndex.toString() ? Colors.green : Colors.grey[300]
                                        ),
                                        padding: EdgeInsets.symmetric(vertical: 15 , horizontal: 13),
                                        child: Text("${q.options[opIndex]}" , style: GoogleFonts.poppins(),)
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                );
              },
            ),
          ),
      ),
    );
  }
}
