import 'package:flutter/material.dart';
import 'package:owleddomoapp/login/LoginMain.dart';
import 'package:owleddomoapp/AppTrips.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        color: Colors.red,
        title: 'Owled',
        theme: ThemeData(
            accentColor: Colors.green
        ),
        home: LoginMain()
    );
  }
}
