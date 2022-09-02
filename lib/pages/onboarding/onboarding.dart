import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
        title: "Get your Dream Job",
        body: "We have lots of great job offers you deserve",
        image: SvgPicture.asset('assets/onboarding/01_team.svg' , width: 180, height: 180 , fit: BoxFit.contain, )
    ),
    PageViewModel(
        title: "Your dream jobs just a click away",
        body: "Online Interview system for employee & employer",
        image: SvgPicture.asset('assets/onboarding/03_freelancer.svg' ,  width: 180, height: 180 , fit: BoxFit.contain,)
    ),
    PageViewModel(
        title: "Find a perfect employee",
        body: "Lots of great employees here, find a perfect employee according to your requirements",
        image: SvgPicture.asset('assets/onboarding/04_employer.svg' ,  width: 180, height: 180 , fit: BoxFit.contain, )
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
        skip: Text('Skip' , style: GoogleFonts.poppins(
          color: kDarkColor
        )),
        next: Icon(Icons.arrow_forward , color: kDarkColor,),
        done: Text('Done' , style: GoogleFonts.poppins(
          color: kDarkColor
        ) ),
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
