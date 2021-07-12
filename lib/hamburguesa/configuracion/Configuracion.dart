import 'package:flutter/material.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';

final  colores = new PaletaColores();

class Configuracion extends StatefulWidget {

  Configuracion();

  @override
  State<StatefulWidget> createState () {
    return _Configuracion();
  }

}

class _Configuracion extends State<Configuracion> {

  _Configuracion();

  @override
  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    return Text("");
  }
}