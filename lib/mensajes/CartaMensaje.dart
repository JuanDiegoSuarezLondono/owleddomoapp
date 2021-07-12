import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owleddomoapp/rutinas/ServiciosRutina.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/shared/TratarError.dart';

final PaletaColores colores = new PaletaColores(); //Colores predeterminados.
final TratarError tratarError = new TratarError(); //Respuestas predeterminadas a las API.

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

  final String usuario; //Identificador del usuario.
  final String rutina_id; //Identificador único de la rutina.
  final String nombreDispositivo; //Nombre del dispositivo al que pertenece.
  final String persona_producto_id; //Producto que controla la rutina.
  final String nombreRutina; //Nombre corto de la rutina.
  final int activo; //Indica si la rutina esta activada o no.
  final String relacionDispositivo; //Identificador de la rutina dentro del dispositivo.
  final String hora; //Hora en la que se activa la rutina.

  CartaMensaje(this.usuario, this.rutina_id, this.nombreDispositivo, this.persona_producto_id,
      this.nombreRutina, this.activo, this.relacionDispositivo,this.hora) :super(); //Constructor de la clase.

  @override
  _CartaMensaje createState() => _CartaMensaje(usuario, rutina_id, nombreDispositivo,
      persona_producto_id,nombreRutina, activo,
      relacionDispositivo,hora); //Crea un estado mutable del Widget.

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

  final String _usuario; //Identificador del usuario.
  final String _rutina_id; //Identificador único de la rutina.
  final String _nombreDispositivo; //Nombre del dispositivo al que pertenece.
  final String _persona_producto_id; //Producto que controla la rutina.
  final String _nombreRutina; //Nombre corto de la rutina.
  int _activo; //Indica si la rutina esta activada o no.
  final String _relacionDispositivo; //Identificador de la rutina dentro del dispositivo.
  final String _hora; //Hora en la que se activa la rutina.

  _CartaMensaje(this._usuario, this._rutina_id, this._nombreDispositivo, this._persona_producto_id,
      this._nombreRutina, this._activo, this._relacionDispositivo, this._hora); //Constructor de la clase.

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

    ///Construye el Widget encargado del nombre de la rutina.
    ///@return un Container con el texto del nombre de la rutina.

    Widget _nombreRutinaWidget () {
      return Container(
        width: _width/4.5,
        alignment: Alignment.center,
        child: Text(
          _nombreRutina,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: _height/39.6,
            fontWeight: FontWeight.bold,
            fontFamily: "Lato",
          ),
        ),
      );
    }

    ///Construye el Widget encargado del título.
    ///@return un Container con el texto del nombre del cuarto.

    Widget _nombreDispositivoWidget () {
      return Container(
        alignment: Alignment.center,
        child: Text(
          _nombreDispositivo,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: _height/52.8,
            fontWeight: FontWeight.bold,
            fontFamily: "Lato",
          ),
        ),
      );
    }

    ///Construye el Widget encargado de contruir una leyenda que indica la hora en la
    ///que se ejecuta la acción.
    ///@return un Container con el texto que muestra la hora de la rutina.

    Widget _numeroDispositivos () {
      return Container(
        alignment: Alignment.topCenter,
        child: Text(
          "Hora: ${_hora}",
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: _height/79.2,
            color: colores.obtenerColorInactivo(),
            fontFamily: "Lato",
          ),
        ),
      );
    }

    ///Construye el Widget que forma una columna con el nombre del dispositivo que maneja
    ///la rutina y una leyenda que indica que hace la rutina.
    ///@return un Container con un Column.

    Widget _columnaDerecha () {
      return Container(
        alignment: Alignment.center,
        width: _width/2.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget> [
            _nombreDispositivoWidget(),
            _numeroDispositivos(),
          ],
        ),
      );
    }

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
                    color: Colors.black.withOpacity(.12))
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
                      Text(_hora,
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 10.0,
                          )),
                      SizedBox(width: 3.0),
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