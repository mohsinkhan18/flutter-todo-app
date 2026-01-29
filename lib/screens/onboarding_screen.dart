import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'login_screens/signin_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<PageViewModel> _getPages(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return [
      PageViewModel(
        title: "",
        bodyWidget: Column(
          children: [
            Image.asset(
              'assets/notepad.png',
              height: size.height * 0.30,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: Text(
                "Plan your tasks to do, that way you’ll stay organized and you won’t skip any",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      PageViewModel(
        title: "",
        bodyWidget: Column(
          children: [
            Image.asset(
              'assets/calendar.png',
              height: size.height * 0.30,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: Text(
                "Make a full schedule for the whole week and stay organized and productive all days",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      PageViewModel(
        title: "",
        bodyWidget: Column(
          children: [
            Image.asset(
              'assets/team.png',
              height: size.height * 0.30,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: Text(
                "create a team task, invite people and manage your work together",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      PageViewModel(
        title: "",
        bodyWidget: Column(
          children: [
            Image.asset(
              'assets/protected.png',
              height: size.height * 0.30,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: Text(
                "You informations are secure with us",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff1253AA), Color(0xff05243E)],
          ),
        ),
        child: SafeArea(
          child: IntroductionScreen(
            globalBackgroundColor: Colors.transparent,
            pages: _getPages(context),
            next: Icon(
              Icons.arrow_circle_right_rounded,
              color: Colors.white,
              size: 60,
            ),
            done: Icon(Icons.check_circle, color: Colors.white, size: 60),
            dotsDecorator: DotsDecorator(color: Colors.white),
            onDone: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
            },
          ),
        ),
      ),
    );
  }
}
