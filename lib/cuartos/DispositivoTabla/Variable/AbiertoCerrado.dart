import 'package:flutter/material.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/Variable/Variable.dart';
import 'package:owleddomoapp/shared/SeleccionarIcono.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/shared/TratarError.dart';

final PaletaColores colores = new PaletaColores(); //Colores predeterminados.
final TratarError tratarError = new TratarError(); //Respuestas predeterminadas a las API.

///Esta clase se encarga del widget predeterminado para las variables de tipo
///interruptor de luz.
///@version 1.0, 06/04/21
///@author Juan Diego Suárez Londoño
///@param variable parámetros de la variable.
///@see owleddomo_app/cuartos/Dispositivo/DispositivoTabla/InterfazInformacionDispositivo.dart#class().
///@return Un Widget Container con una tarjeta botón para controlar el interruptor.

class AbiertoCerrado extends StatefulWidget {

  final Variable variable; //Parámetros de la variable.

  AbiertoCerrado(this.variable); //Constructor de la clase.

  @override
  _AbiertoCerrado createState() => _AbiertoCerrado(variable); //Crea un estado mutable del Widget.

}

///Esta clase se encarga de formar un estado mutable de la clase “InterruptorLuz”.
///@param _variable parámetros de la variable.
///@param _numero numero de la variable en el hardware.
///@param _interruptor controla el encendido o apagado.
///@param _width obtiene el ancho de la pantalla del dispositivo.
///@param _height obtiene el alto de la pantalla del dispositivo.

class _AbiertoCerrado extends State<AbiertoCerrado> {

  final Variable _variable; //Parámetros de la variable.
  _AbiertoCerrado(this._variable);

  String _numero; //Numero de la variable en el hardware
  bool _interruptor; //Controla el encendido o apagado.

  @override

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState();
    _numero = "1";//_variable.relacion_dispositivo.substring(4);
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
            color: colores.obtenerColorUno(),
            child: Column(
              children: <Widget> [
                Padding(
                  padding: EdgeInsets.only(
                    top: _height/198,
                  ),
                  child: Container (
                    width: _width/4,
                    color: colores.obtenerColorDos(),
                    child: _interruptor ?
                    Container(
                        margin: EdgeInsets.symmetric(vertical: _height/158.4, horizontal: _width/72),
                        child: SeleccionarIcono("PuertaCerrada", _height/15.84, Colors.brown)
                    )
                        : Container(
                        margin: EdgeInsets.symmetric(vertical: _height/158.4, horizontal: _width/72),
                        child: SeleccionarIcono("PuertaAbierta", _height/15.84, Colors.brown)
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
                      color: Colors.white,
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
            child: SeleccionarIcono("Atencion", _height/44, colores.obtenerColorRiesgo())
        ),
      ],
    );
  }
}