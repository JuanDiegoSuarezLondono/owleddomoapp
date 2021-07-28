import 'package:flutter/material.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'PaletaColores.dart';

///Esta clase se encarga de armar una subpantalla con un titulo y el espacio para el
///contenido.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@return un Widget Scaffold con una SadeArea que contiene la plantilla de la pantalla
///basica para todas las subpantallas del menu hamburguesa, cuartos, dispositivos, rutinas
///y mensajes.

class SubPantallaUno extends StatefulWidget {

  final Persona usuario; //Parametros del usuario.
  final String titulo; //Titulo de la subpantalla.
  final Widget widgetTabBar; //Widget que va dentro del cuerpo de la subpantalla.
  SubPantallaUno (this.widgetTabBar, this.titulo, this.usuario);

  @override
  State<StatefulWidget> createState () {
    return _SubPantallaUno (widgetTabBar, titulo, usuario);
  }

}

///Esta clase se encarga de formar un estado mutable de la clase “DispositivosLista”.
///@param _titulo titulo de la subpantalla.
///@param _widgetTabBar widget que va dentro del cuerpo de la subpantalla.
///@param _scaffoldKey llave de la subpantalla.
///@param _width obtiene el ancho de la pantalla del dispositivo.
///@param _height obtiene el alto de la pantalla del dispositivo.

class _SubPantallaUno extends State<SubPantallaUno> {

  final Persona _usuario; //Parametros del usuario.
  String _titulo; //Titulo de la subpantalla.
  Widget _widgetTabBar = new Text ("No hay contenido"); //Widget que va dentro del cuerpo de la subpantalla.
  GlobalKey<ScaffoldState> _scaffoldKey; //Llave de la subpantalla.
  _SubPantallaUno (this._widgetTabBar, this._titulo, this._usuario);

  @override

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState();
  }

  ///Acción de navegación a la anterior pantalla en caso de presionar la flecha de retorno.

  _presionarFlechaRegreso() {
    Navigator.of(context).pop(false);
  }

  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    ///Construye el Widget del titulo de la subpantalla.
    ///@return un Container que posee un texto.

    Widget _tituloEncabezado () {
      return Container(
        margin: EdgeInsets.only(left: _width/6),
        child : Text (
          _titulo,
          style: TextStyle (
            fontFamily: 'Lato',
            color: PaletaColores(_usuario).obtenerLetraContrastePrimario(),
            fontSize: _height/31.68,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    ///Construye el Widget de una flecha para regresar a la anterior pantalla.
    ///@return un RawMaterialButton que posee un icono.

    Widget _flechaRegreso () {
      return RawMaterialButton(
        onPressed: _presionarFlechaRegreso,
        child: Icon(
          Icons.arrow_back_ios_rounded,
          size: _height/19.8,
          color: PaletaColores(_usuario).obtenerLetraContrastePrimario(),
        ),
      );
    }

      return Scaffold(
          body: SafeArea(
            child: Scaffold(
              backgroundColor: PaletaColores(_usuario).obtenerColorFondo(),
              key: _scaffoldKey,
              appBar: AppBar(
                leading: _flechaRegreso(),
                automaticallyImplyLeading: false,
                backgroundColor: PaletaColores(_usuario).obtenerPrimario(),
                flexibleSpace: Container(
                  height: _height/14.14285714285714,
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
                  height: _height/1.162995594713656,
                  color: PaletaColores(_usuario).obtenerColorFondo(),
                  child:_widgetTabBar,
                ),
              ),
            ),
          ),
      );
    }
  }
