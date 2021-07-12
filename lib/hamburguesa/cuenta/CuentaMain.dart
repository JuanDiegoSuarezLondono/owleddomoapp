import 'package:flutter/material.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/login/Persona.dart';

final  colores = new PaletaColores();

class CuentaMain extends StatefulWidget {

  final Persona usuario;
  CuentaMain(this.usuario);

  @override
  State<StatefulWidget> createState () {
    return _CuentaMain(usuario);
  }

}

class _CuentaMain extends State<CuentaMain> {

  final Persona _usuario;
  _CuentaMain(this._usuario);

  @override
  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    return Container(
      child: ListView(
        physics: BouncingScrollPhysics(),
        primary: false,
        addAutomaticKeepAlives: false,
        shrinkWrap: true,
        children: <Widget>[
          Text(_usuario.codigo_usuario),
        ],
      ),
    );;
  }
}