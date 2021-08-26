import 'package:flutter/material.dart';
import 'package:pizzamenu/Auth/login_screen.dart';
import 'package:pizzamenu/Menu/home_screen.dart';
import 'package:pizzamenu/general/storage.dart';
//
import 'package:pizzamenu/values/values.dart';

//
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

//
class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _imageController;
  late AnimationController _textController;
  late Animation<double> _imageAnimation;
  late Animation<double> _textAnimation;
  bool hasImageAnimationStarted = false;
  bool hasTextAnimationStarted = false;
//
  @override
  void initState() {
    super.initState();
    _imageController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _textController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _imageAnimation =
        Tween<double>(begin: 1, end: 0.5).animate(_imageController);
    _textAnimation = Tween<double>(begin: 3, end: 0.5).animate(_textController);
    _imageController.addListener(imageControllerListener);
    _textController.addListener(textControllerListener);
    run();
  }

//
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

//
  void imageControllerListener() {
    if (_imageController.status == AnimationStatus.completed) {
      Future.delayed(Duration(milliseconds: 1000), () {
        setState(() {
          hasTextAnimationStarted = true;
        });
        _textController.forward().orCancel;
      });
    }
  }

//
  void textControllerListener() {
    if (_textController.status == AnimationStatus.completed) {
      Future.delayed(Duration(milliseconds: 1000), ()async {
        bool islogedin = await SharedPrefUtils.readPrefBool("isLogged")?? false;
        if (islogedin == true) {
          Navigator.pushReplacementNamed(context, '/Menu');

        } else {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return LoginScreen();
          }));
        }
      });
    }
  }

//
  void run() {
    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        hasImageAnimationStarted = true;
      });
      _imageController.forward().orCancel;
    });
  }

//
  @override
  dispose() {
    _imageController.dispose();
    _textController.dispose();
    super.dispose();
  }

//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: AnimatedBuilder(
              animation: _imageController,
              child: Image.asset(
                "assets/logo.png",
              ),
              builder: (context, child) => RotationTransition(
                turns: hasImageAnimationStarted
                    ? Tween(begin: 0.0, end: 0.025).animate(_imageController)
                    : Tween(begin: 0.0, end: 0.02).animate(_imageController),
                child: Transform.scale(
                  scale: 1 * _imageAnimation.value,
                  child: child,
                ),
              ),
            ),
          ),
          hasTextAnimationStarted
              ? Container(
                  margin: EdgeInsets.all(40.0),
                  child: AnimatedBuilder(
                    animation: _textController,
                    child: Text(
                      'Managing Menu App',
                      textAlign: TextAlign.center,
                      style: Styles.customTitleTextStyle(
                        color: Color(0xFFFF0000),
                      ),
                    ),
                    builder: (context, child) => Transform.scale(
                      scale: 2 * _textAnimation.value,
                      alignment: Alignment.center,
                      child: child,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
