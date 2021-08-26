import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'package:owleddomoapp/rutinas/ServiciosRutina.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/shared/TratarError.dart';

///Esta clase se encarga de construir la vista dentro de la carta de una
///rutina, dotándola de un nombre, un botón para activarla o desactivarla,
///el nombre del dispositivo al que pertenece y una leyenda que indica la hora a
///la que se activa.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param usuario identificador del usuario.
///@param rutina_id identificador único de la rutina.
///@param nombreDispositivo nombre del dispositivo al que pertenece.
///@param persona_producto_id producto que controla la rutina.
///@param nombreRutina nombre corto de la rutina.
///@param activo indica si la rutina esta activada o no.
///@param relacionDispositivo identificador de la rutina dentro del dispositivo.
///@param hora hora en la que se activa la rutina.
///@param nuevoValor acción que realiza la rutina.
///@see owleddomo_app/rutinas/RutinasLista.dart#class().
///@return un Widget Container con la plantilla de la carta una rutina.

class CartaMensaje extends StatefulWidget{

  final Persona usuario; //Identificador del usuario.
  final String rutina_id; //Identificador único de la rutina.
  final String nombreDispositivo; //Nombre del dispositivo al que pertenece.
  final String persona_producto_id; //Producto que controla la rutina.
  final String nombreRutina; //Nombre corto de la rutina.
  final int activo; //Indica si la rutina esta activada o no.
  final String relacionDispositivo; //Identificador de la rutina dentro del dispositivo.
  final String hora; //Hora en la que se activa la rutina.
  final String fecha;

  CartaMensaje(this.usuario, this.rutina_id, this.nombreDispositivo, this.persona_producto_id,
      this.nombreRutina, this.activo, this.relacionDispositivo,this.hora,this.fecha) :super(); //Constructor de la clase.

  @override
  _CartaMensaje createState() => _CartaMensaje(usuario, rutina_id, nombreDispositivo,
      persona_producto_id,nombreRutina, activo,
      relacionDispositivo,hora,fecha); //Crea un estado mutable del Widget.

}

///Esta clase se encarga de formar un estado mutable de la clase “CartaRutina”.
///@param _usuario identificador del usuario.
///@param _rutina_id identificador único de la rutina.
///@param _nombreDispositivo nombre del dispositivo al que pertenece.
///@param _persona_producto_id producto que controla la rutina.
///@param _nombreRutina nombre corto de la rutina.
///@param _activo indica si la rutina esta activada o no.
///@param _relacionDispositivo identificador de la rutina dentro del dispositivo.
///@param _hora hora en la que se activa la rutina.
///@param _nuevoValor acción que realiza la rutina.
///@param _width obtiene el ancho de la pantalla del dispositivo.
///@param _height obtiene el alto de la pantalla del dispositivo.

class _CartaMensaje extends State<CartaMensaje> {

  final Persona _usuario; //Identificador del usuario.
  final String _rutina_id; //Identificador único de la rutina.
  final String _nombreDispositivo; //Nombre del dispositivo al que pertenece.
  final String _persona_producto_id; //Producto que controla la rutina.
  final String _nombreRutina; //Nombre corto de la rutina.
  int _activo; //Indica si la rutina esta activada o no.
  final String _relacionDispositivo; //Identificador de la rutina dentro del dispositivo.
  final String _hora; //Hora en la que se activa la rutina.
  final String _fecha;

  _CartaMensaje(this._usuario, this._rutina_id, this._nombreDispositivo, this._persona_producto_id,
      this._nombreRutina, this._activo, this._relacionDispositivo, this._hora, this._fecha); //Constructor de la clase.

  @override

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {

    var isMe = false;

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    final bg = isMe ? Colors.white : Colors.greenAccent.shade100;
    final align = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final radius = isMe
        ? BorderRadius.only(
      topRight: Radius.circular(5.0),
      bottomLeft: Radius.circular(10.0),
      bottomRight: Radius.circular(5.0),
    )
        : BorderRadius.only(
      topLeft: Radius.circular(5.0),
      bottomLeft: Radius.circular(5.0),
      bottomRight: Radius.circular(10.0),
    );

    ///Construye el Widget que forma el resultado final del contenido de la tarjeta
    ///con una fila que contiene todos los elementos.
    ///@return un Container con un Row.

    Widget _carta () {
      return Column(
        crossAxisAlignment: align,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: .5,
                    spreadRadius: 1.0,
                    color: Colors.black.withOpacity(.12),
                ),
              ],
              color: bg,
              borderRadius: radius,
            ),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 48.0),
                  child: Text(_nombreDispositivo),
                ),
                Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget> [
                            Text(
                              _hora,
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 7.2,
                              ),
                            ),
                            Text(
                              _fecha,
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 7.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 3.0,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      );
    }
    return _carta();
  }
}