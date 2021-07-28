  import 'package:flutter/material.dart';
  import 'package:owleddomoapp/login/LoginMain.dart';
  import 'shared/PaletaColores.dart';
  import 'package:flutter/services.Dart';

  void main() {
    runApp(MyApp());
  }

  class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        color: Color(0xFFECEFF1),
        title: 'Owled',
        home: MyHomePage(),
      );
    }
  }

  class MyHomePage extends StatefulWidget {
    MyHomePage({Key key, this.title}) : super(key: key);

    final String title;

    @override
    _MyHomePageState createState() => _MyHomePageState();
  }

  class _MyHomePageState extends State<MyHomePage> {

    @override
    void initState() {
      super.initState();
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }

    /*void showNotification() {
      setState(() {
        _counter++;
      });
      flutterLocalNotificationsPlugin.show(
          0,
          "Testing $_counter",
          "How you doin ?",
          NotificationDetails(
              android: AndroidNotificationDetails(channel.id, channel.name, channel.description,
                  importance: Importance.high,
                  color: colores.obtenerColorDos(),
                  playSound: true,
                  icon: '@mipmap/ic_launcher')));
    }*/

    @override
    Widget build(BuildContext context) {
      return LoginMain();
    }
  }