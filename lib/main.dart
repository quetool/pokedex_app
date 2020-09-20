import 'package:flutter/material.dart';
import 'package:pokedex_app/bloc/provider.dart';
import 'package:pokedex_app/screens/login.dart';

void main() {
  // DBProvider();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        theme: ThemeData.light().copyWith(
          tabBarTheme: const TabBarTheme(
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                color: Colors.blue,
                width: 2.0,
              ),
            ),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.black.withOpacity(0.1),
            contentPadding: const EdgeInsets.only(left: 12.0, right: 12.0),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(
                Radius.circular(60.0),
              ),
            ),
          ),
          cardTheme: const CardTheme(
            elevation: 4.0,
            color: Colors.white,
          ),
          appBarTheme: const AppBarTheme(
            elevation: 4.0,
            color: Colors.red,
          ),
        ),
        home: LoginScreen(),
      ),
    );
  }
}
