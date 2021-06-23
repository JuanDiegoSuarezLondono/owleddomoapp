import 'package:flutter/material.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/Variable/ServiciosVariable.dart';
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

class InterruptorLuz extends StatefulWidget {

  final Variable variable; //Parámetros de la variable.

  InterruptorLuz(this.variable); //Constructor de la clase.

  @override
  _InterruptorLuz createState() => _InterruptorLuz(variable); //Crea un estado mutable del Widget.

}

///Esta clase se encarga de formar un estado mutable de la clase “InterruptorLuz”.
///@param _variable parámetros de la variable.
///@param _numero numero de la variable en el hardware.
///@param _interruptor controla el encendido o apagado.
///@param _width obtiene el ancho de la pantalla del dispositivo.
///@param _height obtiene el alto de la pantalla del dispositivo.

class _InterruptorLuz extends State<InterruptorLuz> {

  final Variable _variable; //Parámetros de la variable.
  _InterruptorLuz(this._variable);

  String _numero; //Numero de la variable en el hardware
  bool _interruptor; //Controla el encendido o apagado.

  @override

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState();
    _numero = _variable.relacion_dispositivo.substring(4);
    _interruptor = _variable.valor == "1" ? true : false;
  }

  ///Intercambia entre el valor encendido o apagado según el estado previo.
  ///@param nuevoValor nuevoValor en string para enviar a la base de datos.

  _cambiarValor() {
    String nuevoValor; //NuevoValor en string para enviar a la base de datos.
    if(_interruptor) {
      if(mounted) {
        setState(() {
          nuevoValor = "0";
          _interruptor = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          nuevoValor = "1";
          _interruptor = true;
        });
      }
    }
    ServiciosVariable.actualizarVariable(_variable.relacion_id, nuevoValor, _variable.persona_producto_id, _variable.relacion_dispositivo)
        .then((result) {
    });
  }

  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    return Container(
      width: _width/3.3962,
      child: Card(
        color: colores.obtenerColorUno(),
        child: Column(
          children: <Widget> [
            Padding(
              padding: EdgeInsets.only(
                top: _height/198,
              ),
              child: MaterialButton(
                splashColor: colores.obtenerColorTres(),
                color: colores.obtenerColorDos(),
                onPressed: _cambiarValor,
                child: _interruptor ?
                Container(
                    margin: EdgeInsets.symmetric(vertical: _height/158.4, horizontal: _width/72),
                    child: SeleccionarIcono("Bombilla", _height/15.84, Colors.yellow)
                ): SeleccionarIcono("BombillaApagada", _height/13.2, colores.obtenerColorInactivo()),
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
    );
  }
}