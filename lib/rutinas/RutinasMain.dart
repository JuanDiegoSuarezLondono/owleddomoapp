import 'package:flutter/material.dart';
import 'package:owleddomoapp/rutinas/RutinasLista.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/login/Persona.dart';

final PaletaColores colores = new PaletaColores();

class RutinasMain extends StatelessWidget {

  final Persona usuario;
  RutinasMain(this.usuario,{Key key,String pathImagen,String titulo});

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    final foto = Container(
      margin: EdgeInsets.only(
        right: width/18,
      ),
      width: height/19.8,
      height: height/19.8,
      decoration: BoxDecoration(
        color: colores.obtenerColorDos(),
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(usuario.url_foto),
        ),
      ),
    );

    final tituloInfo = Container(
      margin: EdgeInsets.only(
        left: width/14.4,
      ),
      child : Text (
        "Rutinas",
        style: TextStyle(
          fontFamily: 'Lato',
          color: colores.obtenerColorDos(),
          fontSize: height/31.68,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return  SafeArea(
        child: Scaffold(
        backgroundColor: colores.obtenerColorFondo(),
        appBar: AppBar(
          actions: [Text("")],
          automaticallyImplyLeading: false,
          backgroundColor: colores.obtenerColorUno(),
          flexibleSpace: Container(
            height: height/14.14285714285714,
            child: Row (
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                tituloInfo,
                Builder(
                    builder: (context) {
                      return InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: foto,
                        onTap: () => Scaffold.of(context).openEndDrawer(),
                      );
                    }
                ),
              ],
            ),
          ),
        ),
          body: RutinasLista(usuario.persona_id),
          endDrawer: Drawer(
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: 150,
                  color: colores.obtenerColorUno(),

                ),
                ListTile(
                  title: Text('Cuenta'),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
                ListTile(
                  title: Text('Configuracion'),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
                ListTile(
                  title: Text('Ayuda'),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
                ListTile(
                  title: Text('Acerca de'),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
              ],
            ),
          ),
        ),
    );
  }
}