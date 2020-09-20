import 'package:flutter/material.dart';
import 'package:pokedex_app/helpers/strings.dart';

class SplashView extends StatelessWidget {
  const SplashView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  Strings.welcome,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  Strings.tapPokeball,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Image.asset('assets/ash.png'),
        ],
      ),
    );
  }
}
