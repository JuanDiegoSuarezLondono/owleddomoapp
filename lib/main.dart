  import 'package:flutter/material.dart';
  import 'package:owleddomoapp/login/LoginMain.dart';
  import 'package:owleddomoapp/login/Persona.dart';
  import 'package:flutter/services.Dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:owleddomoapp/AppTrips.dart';
  import 'package:firebase_core/firebase_core.dart';
  import 'package:firebase_messaging/firebase_messaging.dart';
  import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

    Future<String> _token;

    @override
    void initState() {
      super.initState();
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      fireInit().then((value) {
        print("--------------------------------------");
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification notification = message.notification;
        AndroidNotification android = message.notification?.android;
        if (notification != null && android != null && notification.title != "Data") {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channel.description,
                  color: Colors.white,
                  styleInformation: BigTextStyleInformation(''),
                  playSound: true,
                  icon: '@mipmap/ic_launcher',
                ),
              ));
        }
      });
      /*FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
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
        if (mounted) {
          setState(() {
            _token = FirebaseMessaging.instance.getToken();
          });
        }
      });
      autoLogIn();
    }

    void autoLogIn() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String persona_id = prefs.getString('persona_id');
      if( persona_id != null) {
        Persona usuario = new Persona();
        usuario.persona_id = persona_id;
        usuario.territorio_id = int.parse(prefs.getString('territorio_id'));
        usuario.nombres = prefs.getString('nombres');
        usuario.apellidos = prefs.getString('apellidos');
        usuario.telefono = prefs.getString('telefono');
        usuario.fecha_nacimiento = prefs.getString('fecha_nacimiento');
        usuario.correo_electronico = prefs.getString('correo_electronico');
        usuario.url_foto = prefs.getString('url_foto');
        usuario.url_icono = prefs.getString('url_icono');
        usuario.rol = prefs.getString('rol');
        usuario.apodo = prefs.getString('apodo');
        usuario.codigo_usuario = prefs.getString('codigo_usuario');
        usuario.configuracion_id = prefs.getString('configuracion_id');
        usuario.tema = int.parse(prefs.getString('tema'));
        print(usuario.correo_electronico);
        Route route = MaterialPageRoute (builder: (context) =>
            AppTrips(usuario)
        );
        Navigator.push(context, route).then((value)=>{
        });
      }
    }

    @override
    Widget build(BuildContext context) {
      return FutureBuilder<String>(
        future: _token,
        builder: (context, AsyncSnapshot<String> snapshot) {
          Widget children;
          if (snapshot.hasData) {
            children = LoginMain(snapshot.data);
          } else if (snapshot.hasError) {
            children = SafeArea(
              child: Scaffold(
                backgroundColor: Color(0xFFECEFF1),
                body: Scaffold(
                  body: Stack(children: <Widget>[
                    Text("Algo va mal")
                  ]),
                ),
              ),
            );
          } else {
            children = SafeArea(
              child: Scaffold(
                backgroundColor: Color(0xFFECEFF1),
                body: Scaffold(
                  body: Stack(children: <Widget>[
                    Text("Cargando...")
                  ]),
                ),
              ),
            );
          }
          return children;
        },
      );

        //LoginMain();
    }
  }