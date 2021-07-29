import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/pages/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';


class OnBoardingScr extends StatefulWidget {

  @override
  _OnBoardingScrState createState() => _OnBoardingScrState();
}

class _OnBoardingScrState extends State<OnBoardingScr> {
  List<PageViewModel> _onBoardingPages = [
    PageViewModel(
        title: "Find Your Dream Job",
        body: "Upload your resumes & find your dream jobs with lots of filters",
        image: Image.asset('assets/logo/logo.png' , width: 150,)
    ),
    PageViewModel(
        title: "Questionnaire",
        body: "Online Testing system for employee",
        image: Image.asset('assets/logo/logo.png' , width: 150,)
    ),
    PageViewModel(
        title: "Online Interview",
        body: "Video & Audio Interview feature",
        image: Image.asset('assets/logo/logo.png' , width: 150,)
    )
  ];

  Widget _onBoardingImage(String imageName , [double imageWidth = 150]) {
    return Image.asset('assets/$imageName' , width: imageWidth);
  }

  @override
  void initState() {
    // TODO: implement initState
    getPreferences();
    super.initState();
  }

  getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.get('onboard') != null){
      if(prefs.getBool('onboard')){
        Navigator.pushReplacementNamed(context, '/login');
      }
    }else{
      print('null');
    }
  }

  @override
  Widget build(BuildContext context) {

    return IntroductionScreen(
        globalBackgroundColor: Colors.white,
        pages: _onBoardingPages,
        showDoneButton: true,
        onDone: () async {

          print('Done');
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setBool('onboard', true);
          Navigator.pushNamed(context, '/login');
        },
        showSkipButton: true,
        skipFlex: 0,
        nextFlex: 0,
        skip: Text('Skip'),
        next: Icon(Icons.arrow_forward),
        done: Text('Done'),
        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: kDarkColor,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)
            )
        )
    );
  }
}
