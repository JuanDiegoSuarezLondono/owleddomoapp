import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:owleddomoapp/cuartos/CuartosMain.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'package:owleddomoapp/mensajes/MensajesMain.dart';
import 'package:owleddomoapp/rutinas/RutinasMain.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:flutter/foundation.dart' as foundation;


bool get isIos => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

final PaletaColores colores = new PaletaColores();

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
            activeColor: colores.obtenerColorTres(),
              items: <BottomNavigationBarItem> [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: colores.obtenerColorTres()),
                  // ignore: deprecated_member_use
                  title: Text(
                    "Cuartos",
                    style: TextStyle(
                      fontSize: height/56.57142857142857,
                      fontFamily: "Lato",
                      color: colores.obtenerColorTres(),
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.wb_sunny, color: colores.obtenerColorInactivo()),
                  // ignore: deprecated_member_use
                  title: Text(
                    "Rutinas",
                    style: TextStyle(
                      fontSize: height/56.57142857142857,
                      fontFamily: "Lato",
                      color: colores.obtenerColorInactivo(),
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.message, color: colores.obtenerColorInactivo()),
                  // ignore: deprecated_member_use
                  title: Text(
                    "Mensajes",
                    style: TextStyle(
                      fontSize: height/56.57142857142857,
                      fontFamily: "Lato",
                      color: colores.obtenerColorInactivo(),
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
          backgroundColor: PaletaColores().obtenerSecundario(),
          selectedItemColor: colores.obtenerColorTres(),
            currentIndex: actualIndex,
            onTap: onTapped,
            items: <BottomNavigationBarItem> [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded,),
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