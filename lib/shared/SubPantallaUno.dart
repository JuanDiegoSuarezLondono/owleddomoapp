import 'package:flutter/material.dart';
import 'PaletaColores.dart';

final PaletaColores colores = new PaletaColores();

class SubPantallaUno extends StatefulWidget {

  final String titulo;
  final Widget widgetTabBar;
  SubPantallaUno (this.widgetTabBar, this.titulo);

  @override
  State<StatefulWidget> createState () {
    return _SubPantallaUno (this.widgetTabBar, this.titulo);
  }

}

class _SubPantallaUno extends State<SubPantallaUno> {

  String _titulo;
  Widget _widgetTabBar = new Text ("No hay contenido");
  GlobalKey<ScaffoldState> _scaffoldKey;
  _SubPantallaUno (this._widgetTabBar, this._titulo);

  _presionarFlechaRegreso() {
    Navigator.of(context).pop(false);
  }

  @override
    Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    Widget _tituloEncabezado () {
      return Container(
        margin: EdgeInsets.only(left: width/6),
        child : Text (
          _titulo,
          style: TextStyle (
            fontFamily: 'Lato',
            color: PaletaColores().color_letra_contraste_primario,
            fontSize: height/31.68,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    Widget _flechaRegreso () {
      return RawMaterialButton(
        onPressed: _presionarFlechaRegreso,
        child: Container(
          child: Icon(
            Icons.arrow_back_ios_rounded,
            size: height/19.8,
            color: PaletaColores().color_letra_contraste_primario,
          ),
        ),
      );
    }

      return Scaffold(
          body: SafeArea(
            child: Scaffold(
              backgroundColor: PaletaColores().obtenerColorFondo(),
              key: _scaffoldKey,
              appBar: AppBar(
                leading: _flechaRegreso(),
                automaticallyImplyLeading: false,
                backgroundColor: PaletaColores().obtenerPrimario(),
                flexibleSpace: Container(
                  height: height/14.14285714285714,
                  child: Row (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _tituloEncabezado(),
                    ],
                  ),
                ),
              ),
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  height: height/1.162995594713656,
                  color: PaletaColores().obtenerColorFondo(),
                  child:_widgetTabBar,
                ),
              ),
            ),
          ),
      );
    }
  }
