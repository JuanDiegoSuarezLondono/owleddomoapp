import 'package:flutter/material.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

///Esta clase se encarga de desplegar la pantalla de espera al cargar algun servicio.
///@version 1.0, 06/04/21
///@author Juan Diego Suárez Londoño
///@param width obtiene el ancho de la pantalla del dispositivo.
///@param height obtiene el alto de la pantalla del dispositivo.
///return un Widget AlertDialog con una animación de un corazon.

class PantallaEspera extends StatelessWidget {

  final Persona usuario;

  PantallaEspera(this.usuario);

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    spinkit() {
      return SpinKitPumpingHeart(
        color: PaletaColores(usuario).obtenerCuaternario(),
        size: height/7.92,
      );
    };

    return AlertDialog(backgroundColor: PaletaColores(usuario).obtenerPrimario(),
      content: SizedBox(
        width: width/3.6,
        height: height/3.96,
        child: spinkit(),
      ),
    );
  }
}