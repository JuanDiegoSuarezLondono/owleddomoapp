import 'package:flutter/material.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/Variable/Variable.dart';
import 'package:owleddomoapp/shared/SeleccionarIcono.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';

///Esta clase se encarga del widget predeterminado para las variables de tipo
///Abierto o Cerrado.
///@version 1.0, 06/04/21
///@author Juan Diego Suárez Londoño
///@param variable parámetros de la variable.
///@param usuario parametros del usuario.
///@see owleddomo_app/cuartos/Dispositivo/DispositivoTabla/InterfazInformacionDispositivo.dart#class().
///@return Un Widget Container con una tarjeta testigo para indicar si el dispositivo está
///abierto o cerrado.

class AbiertoCerrado extends StatefulWidget {

  final Variable variable; //Parámetros de la variable.
  final Persona usuario; //Parametros del usuario.

  AbiertoCerrado(this.variable, this.usuario); //Constructor de la clase.

  @override
  _AbiertoCerrado createState() => _AbiertoCerrado(variable, usuario); //Crea un estado mutable del Widget.

}

///Esta clase se encarga de formar un estado mutable de la clase “AbiertoCerrado”.
///@param _variable parámetros de la variable.
///@param _usuario parametros del usuario.
///@param _numero numero de la variable en el hardware.
///@param _interruptor controla el encendido o apagado.
///@param _width obtiene el ancho de la pantalla del dispositivo.
///@param _height obtiene el alto de la pantalla del dispositivo.

class _AbiertoCerrado extends State<AbiertoCerrado> {

  final Variable _variable; //Parámetros de la variable.
  final Persona _usuario; //Parametros del usuario.

  _AbiertoCerrado(this._variable, this._usuario); //Constructor de la clase.

  String _numero; //Numero de la variable en el hardware
  bool _interruptor; //Controla el abierto o cerrado.

  @override

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState();
    _numero = int.parse(_variable.relacion_id.substring(2,4)).toString();
    _interruptor = _variable.valor == "1" ? true : false;
  }

  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    return Stack(
      children: <Widget> [
        Container(
          width: _width/3.3962,
          child: Card(
            color: PaletaColores(_usuario).obtenerPrimario(),
            child: Column(
              children: <Widget> [
                Padding(
                  padding: EdgeInsets.only(
                    top: _height/198,
                  ),
                  child: Container (
                    width: _width/4,
                    color: PaletaColores(_usuario).obtenerLetraContrastePrimario(),
                    child: _interruptor ?
                    Container(
                      margin: EdgeInsets.symmetric(vertical: _height/158.4, horizontal: _width/72),
                      child: SeleccionarIcono(
                        "PuertaCerrada",
                        _height/15.84,
                        Colors.brown,
                      ),
                    )
                        : Container(
                      margin: EdgeInsets.symmetric(vertical: _height/158.4, horizontal: _width/72),
                      child: SeleccionarIcono(
                        "PuertaAbierta",
                        _height/15.84,
                        Colors.brown,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: _height/72,
                  ),
                  child:Text(
                    "$_numero",
                    style: TextStyle(
                      color: PaletaColores(_usuario).obtenerLetraContrastePrimario(),
                      fontFamily: "lato",
                      fontWeight: FontWeight.bold,
                      fontSize: _height/29.498,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.symmetric(vertical: _height/79.2, horizontal: _width/36),
            child: SeleccionarIcono(
              "Atencion",
              _height/44,
              PaletaColores(_usuario).obtenerColorRiesgo(),
            ),
        ),
      ],
    );
  }
}