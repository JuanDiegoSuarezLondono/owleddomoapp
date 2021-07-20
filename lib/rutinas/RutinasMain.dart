import 'package:flutter/material.dart';
import 'package:owleddomoapp/shared/MenuHamburguesa.dart';
import 'package:owleddomoapp/rutinas/RutinasLista.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/login/Persona.dart';

///Esta clase se encarga de la pantalla donde se direcciona la barra cupertino al
///ir hacia las rutinas, contiene todo lo concerniente a las rutinas.
///@version 1.0, 06/04/21
///@author Juan Diego Suárez Londoño
///@param usuario identificador del usuario.
///@see owleddomo_app/AppTrips.dart#class().
///return un Widget SafeArea con un Scaffold que contendrá toda la información
///de las rutinas, además posee un menú en la barra del título.

class RutinasMain extends StatelessWidget {

  final Persona usuario; //Identificador del usuario.
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
        color: PaletaColores().obtenerPrimario(),
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
          color: PaletaColores().obtenerLetraContrastePrimario(),
          fontSize: height/31.68,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return  SafeArea(
        child: Scaffold(
        backgroundColor: PaletaColores().obtenerColorFondo(),
        appBar: AppBar(
          actions: [Text("")],
          automaticallyImplyLeading: false,
          backgroundColor: PaletaColores().obtenerPrimario(),
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
          body: RutinasLista(usuario),
          endDrawer: MenuHamburguesa(usuario),
        ),
    );
  }
}