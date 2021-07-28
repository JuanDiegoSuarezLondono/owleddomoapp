import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:owleddomoapp/cuartos/CuartosMain.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'package:owleddomoapp/mensajes/MensajesMain.dart';
import 'package:owleddomoapp/rutinas/RutinasMain.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.Dart';

bool get isIos => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> fireInit() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

class AppTrips extends StatefulWidget {
  final Persona usuario;
  AppTrips(this.usuario, {Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _AppTrips(usuario);
  }
}

class _AppTrips extends State<AppTrips> {

  int actualIndex = 0;
  final Persona _usuario;
  _AppTrips(this._usuario);

  onTapped(int index) {
    if(mounted){
      setState(() {
        actualIndex = index;
      });
    }
  }

  @override

  void initState() {
    super.initState();
    fireInit().then((value) {
      /*FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification notification = message.notification;
        AndroidNotification android = message.notification?.android;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channel.description,
                  color: PaletaColores().obtenerSecundario(),
                  playSound: true,
                  icon: '@mipmap/ic_launcher',
                ),
              ));
        }
      });
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('A new onMessageOpenedApp event was published!');
        RemoteNotification notification = message.notification;
        AndroidNotification android = message.notification?.android;
        if (notification != null && android != null) {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Text(notification.title),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(notification.body)],
                    ),
                  ),
                );
              });
        }
      });*/

      print("----------------------------------------------------------------------");
      FirebaseMessaging.instance.getToken().then((value) {
        print("Valor: ${value}");
      });
    });
  }

  Widget build(BuildContext context) {

    List<Widget> tabs = [
      CuartosMain(_usuario),
      RutinasMain(_usuario),
      MensajesMain(_usuario),
    ];

    double height = MediaQuery.of(context).size.height;

    if (isIos) {
      return CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            activeColor: PaletaColores(_usuario).obtenerTerciario(),
              items: <BottomNavigationBarItem> [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: PaletaColores(_usuario).obtenerTerciario(),
                  ),
                  // ignore: deprecated_member_use
                  title: Text(
                    "Cuartos",
                    style: TextStyle(
                      fontSize: height/56.57142857142857,
                      fontFamily: "Lato",
                      color: PaletaColores(_usuario).obtenerTerciario(),
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.wb_sunny, color: PaletaColores(_usuario).obtenerColorInactivo()),
                  // ignore: deprecated_member_use
                  title: Text(
                    "Rutinas",
                    style: TextStyle(
                      fontSize: height/56.57142857142857,
                      fontFamily: "Lato",
                      color: PaletaColores(_usuario).obtenerColorInactivo(),
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.message, color: PaletaColores(_usuario).obtenerColorInactivo()),
                  // ignore: deprecated_member_use
                  title: Text(
                    "Mensajes",
                    style: TextStyle(
                      fontSize: height/56.57142857142857,
                      fontFamily: "Lato",
                      color: PaletaColores(_usuario).obtenerColorInactivo(),
                    ),
                  ),
                ),
              ]),
          tabBuilder: (context, index) {
            switch (index) {
              case 0:
                return CupertinoTabView(
                  builder: (BuildContext context) => CuartosMain(_usuario),
                );
                break;
              case 1:
                return CupertinoTabView(
                  builder: (BuildContext context) => RutinasMain(_usuario),
                );
                break;
              case 2:
                return CupertinoTabView(
                  builder: (BuildContext context) => MensajesMain(_usuario),
                );
                break;
              default:
                return CupertinoTabView(
                  builder: (BuildContext context) => CuartosMain(_usuario),
                );
                break;
            }
          });
    } else {
      return Scaffold(
        body: tabs[actualIndex],
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: PaletaColores(_usuario).obtenerSecundario(),
            selectedItemColor: PaletaColores(_usuario).obtenerCuaternario(),
            unselectedItemColor: PaletaColores(_usuario).obtenerColorInactivo(),
            currentIndex: actualIndex,
            onTap: onTapped,
            items: <BottomNavigationBarItem> [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_rounded,
                ),
                // ignore: deprecated_member_use
                title: Text(
                  "Cuartos",
                  style: TextStyle(
                    fontSize: height/56.57142857142857,
                    fontFamily: "Lato",
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.watch_later_rounded),
                // ignore: deprecated_member_use
                title: Text(
                  "Rutinas",
                  style: TextStyle(
                    fontSize: height/56.57142857142857,
                    fontFamily: "Lato",
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message_rounded),
                // ignore: deprecated_member_use
                title: Text(
                  "Mensajes",
                  style: TextStyle(
                    fontSize: height/56.57142857142857,
                    fontFamily: "Lato",
                  ),
                ),
              ),
            ]),
      );
    }
  }
}