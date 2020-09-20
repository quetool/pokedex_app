import 'package:flutter/material.dart';
import 'package:pokedex_app/helpers/helpers.dart';
import 'package:pokedex_app/helpers/strings.dart';
import 'package:pokedex_app/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  LoginView({
    @required this.animationController,
  });
  final AnimationController animationController;

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  AnimationController _animationController;
  Animation<Offset> _offsetAnimation;

  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _autoValidate = false;

  @override
  void initState() {
    super.initState();
    _animationController = widget.animationController;
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.5, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.bounceIn,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.black45,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SlideTransition(
            position: _offsetAnimation,
            child: Card(
              elevation: 4.0,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                width: double.infinity,
                child: Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                        child: Text(Strings.welcome),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: Strings.username.toUpperCase(),
                          ),
                          autocorrect: false,
                          autovalidate: false,
                          validator: (text) =>
                              (text.isEmpty) ? Strings.usernameInvalid : null,
                          enableSuggestions: false,
                          focusNode: _usernameFocus,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (text) {
                            FocusScope.of(context).requestFocus(_passwordFocus);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: Strings.password.toUpperCase(),
                          ),
                          obscuringCharacter: '@',
                          obscureText: true,
                          autocorrect: false,
                          autovalidate: false,
                          validator: (text) =>
                              (text.isEmpty) ? Strings.passwordInvalid : null,
                          focusNode: _passwordFocus,
                          textInputAction: TextInputAction.continueAction,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: RaisedButton(
                          child: const Text(Strings.coninueButton),
                          onPressed: _validateInputs,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _validateInputs() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState.validate()) {
      setState(() {
        _autoValidate = true;
      });
    } else {
      Helpers().loginUser(_usernameController.text, _passwordController.text,
          (user, error) {
        if (user != null) {
          SharedPreferences.getInstance().then((prefs) {
            prefs.setString('user_id', user.id).then((value) {
              _goToHomeScreen();
            });
          });
        } else {
          _showErrorWithTitle(error);
        }
      });
    }
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

  void _showErrorWithTitle(String title) {
    showDialog<AlertDialog>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          actions: [
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(Strings.okButton),
            )
          ],
        );
      },
    );
  }
}
