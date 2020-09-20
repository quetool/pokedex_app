import 'package:flutter/material.dart';
import 'package:pokedex_app/components/login_view.dart';
import 'package:pokedex_app/components/splash_view.dart';
import 'package:pokedex_app/helpers/helpers.dart';
import 'package:pokedex_app/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:very_good_analysis/very_good_analysis.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  bool _checkingUser, _firstTime = false;

  // SET THIS TO false TO SHOW SPLASH ONLY THE VERY FIRST TIME
  final bool _alwaysShowSplash = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    checkIsLogged();
  }

  Future<void> checkIsLogged() async {
    setState(() {
      _checkingUser = true;
    });
    unawaited(SharedPreferences.getInstance().then((prefs) {
      var userId = prefs.getString('user_id') ?? '';
      Helpers().checkLogin(userId).then((isLogged) {
        if (isLogged) {
          _goToHomeScreen();
        } else {
          _firstTime = prefs.getBool('first_time') ?? true;
          if (_alwaysShowSplash) {
            _firstTime = _alwaysShowSplash;
          }
          if (!_firstTime) {
            _animationController.forward();
          }
          setState(() {
            _checkingUser = false;
          });
        }
      });
    }));
  }

  void _goToHomeScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<HomeScreen>(
        builder: (BuildContext context) {
          return HomeScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.grey,
            gradient: LinearGradient(
              colors: [
                Colors.grey,
                Colors.red,
              ],
            ),
            image: DecorationImage(
              image: AssetImage('assets/pokeball2.png'),
              repeat: ImageRepeat.repeat,
            ),
          ),
          width: double.infinity,
          height: double.infinity,
          child: (_checkingUser)
              ? Container(width: 0.0, height: 0.0)
              : (_firstTime)
                  ? const SplashView()
                  : LoginView(
                      animationController: _animationController,
                    ),
        ),
      ),
      floatingActionButton: (_firstTime)
          ? SizedBox(
              width: 100.0,
              height: 100.0,
              child: FloatingActionButton(
                elevation: 16.0,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/pokeball2.png'),
                    ),
                  ),
                ),
                onPressed: () {
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.setBool('first_time', false).then((value) {
                      Future.delayed(const Duration(milliseconds: 200), () {
                        setState(() {
                          _firstTime = false;
                        });
                        _animationController.forward();
                      });
                    });
                  });
                },
              ),
            )
          : null,
    );
  }
}
