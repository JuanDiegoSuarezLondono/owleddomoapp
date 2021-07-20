import 'package:flutter/material.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/Variable/ServiciosVariable.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/Variable/Variable.dart';
import 'package:owleddomoapp/shared/SeleccionarIcono.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/shared/TratarError.dart';

///Esta clase se encarga del widget predeterminado para las variables de tipo
///alerta.
///@version 1.0, 06/04/21
///@author Juan Diego Suárez Londoño
///@param variable parámetros de la variable.
///@see owleddomo_app/cuartos/Dispositivo/DispositivoTabla/InterfazInformacionDispositivo.dart#class().
///@return Un Widget Container con una tarjeta botón para controlar la alerta.

class Alerta extends StatefulWidget {

  final Variable variable; //Parámetros de la variable.

  Alerta(this.variable); //Constructor de la clase.

  @override
  _Alerta createState() => _Alerta(variable); //Crea un estado mutable del Widget.

}

///Esta clase se encarga de formar un estado mutable de la clase “Alerta”.
///@param _variable parámetros de la variable.
///@param _numero numero de la variable en el hardware.
///@param _interruptor controla el encendido o apagado.
///@param _width obtiene el ancho de la pantalla del dispositivo.
///@param _height obtiene el alto de la pantalla del dispositivo.

class _Alerta extends State<Alerta> {

  final Variable _variable; //Parámetros de la variable.
  _Alerta(this._variable);

  String _numero; //Numero de la variable en el hardware
  bool _interruptor; //Controla el encendido o apagado.

  @override

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState();
    _numero = int.parse(_variable.relacion_id.substring(2,4)).toString();
    _interruptor = _variable.valor == "1" ? true : false;
  }

  ///Intercambia entre el valor encendido o apagado según el estado previo.
  ///@param nuevoValor nuevoValor en string para enviar a la base de datos.
  ///@return Un String con el nuevo valor.

  String _cambiarValor() {
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
    return nuevoValor;
  }

  ///Actualiza la variable y controla el cambio del valor.
  ///@param nuevoValor nuevoValor en string para enviar a la base de datos.

  _actualizarValor() {
    String nuevoValor = _cambiarValor();
    ServiciosVariable.actualizarVariable(_variable.relacion_id, nuevoValor, _variable.persona_producto_id,
        _variable.relacion_dispositivo)
        .then((result) {
      String respuesta =  TratarError().estadoSnackbar(result, context).first.toString();
      if ( respuesta != "200") {
        _cambiarValor();
      }
    });
  }

  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    return Container(
      width: _width/3.3962,
      child: Card(
        color: PaletaColores().obtenerPrimario(),
        child: Column(
          children: <Widget> [
            Padding(
              padding: EdgeInsets.only(
                top: _height/198,
              ),
              child: MaterialButton(
                splashColor: PaletaColores().obtenerTerciario(),
                color: PaletaColores().obtenerLetraContrastePrimario(),
                onPressed: _actualizarValor,
                child: _interruptor ?
                Container(
                    margin: EdgeInsets.symmetric(vertical: _height/158.4, horizontal: _width/72),
                    child: SeleccionarIcono(
                      "Escudo",
                      _height/15.84,
                      Colors.green,
                    ),
                )
                : Container(
                    margin: EdgeInsets.symmetric(vertical: _height/158.4, horizontal: _width/72),
                    child: SeleccionarIcono(
                      "Escudo",
                      _height/15.84,
                      PaletaColores().obtenerColorInactivo(),
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
                  color: PaletaColores().obtenerLetraContrastePrimario(),
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