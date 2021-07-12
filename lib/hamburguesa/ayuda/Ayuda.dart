import 'package:flutter/material.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';

final  colores = new PaletaColores();

class Ayuda extends StatefulWidget {

  Ayuda();

  @override
  State<StatefulWidget> createState () {
    return _Ayuda();
  }

}

class _Ayuda extends State<Ayuda> {

  _Ayuda();

  @override
  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    return Text("");
  }
}