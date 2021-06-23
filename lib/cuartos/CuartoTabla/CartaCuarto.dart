import 'dart:io';
import 'package:flutter/material.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/ServiciosDispositivo.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/Dispositivo.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/shared/TratarError.dart';

final PaletaColores colores = new PaletaColores(); //Colores predeterminados.
final TratarError tratarError = new TratarError(); //Respuestas predeterminadas a las API.

///Esta clase se encarga de construir la vista dentro de la carta de un
///cuarto, dotándola de una imagen, un título y el numero de dispositivos totales
///que posee el cuarto.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param cuartoId identificador único del cuarto.
///@param nombre nombre del cuarto.
///@param pathImagen path de la imagen en los assets.
///@see owleddomo_app/cuartos/CuartosTabla/CuartosLista.dart#class().
///@return un Widget Container con la plantilla de la carta de un cuarto.

class CartaCuarto extends StatefulWidget{

  final String cuartoId; //Identificador unico del cuarto.
  final String nombre; //Nombre del cuarto.
  final String pathImagen; //Path de la imagen en los assets.
  CartaCuarto(this.cuartoId, this.nombre, this.pathImagen) :super(); //Constructor de la clase.

  @override
  _CartaCuarto createState() => _CartaCuarto(cuartoId, nombre, pathImagen); //Crea un estado mutable del Widget.

}

///Esta clase se encarga de formar un estado mutable de la clase “CartaCuarto”.
///@param _cuartoId identificador unico del cuarto.
///@param _nombre nombre del cuarto.
///@param _pathImagen path de la imagen en los assets.
///@paran _imagen imagen del cuarto.
///@paran _existe indica la existencia de la imagen.
///@param _dispositivosCuarto lista de dispositivos asociados al cuarto.
///@param _textoNumeroDispositivos numero de dispositivos asociados al cuarto.
///@param _width obtiene el ancho de la pantalla del dispositivo.
///@param _height obtiene el alto de la pantalla del dispositivo.

class _CartaCuarto extends State<CartaCuarto> {

  final String _cuartoId; //Identificador unico del cuarto.
  final String _nombre; //Nombre del cuarto.
  String _pathImagen; //Path de la imagen en los assets.

  _CartaCuarto(this._cuartoId, this._nombre, this._pathImagen); //Constructor de la clase.

  bool _existe; //Indica la existencia de la imagen.
  List<Dispositivo> _dispositivosCuarto; //Lista de dispositivos asociados al cuarto.
  String _textoNumeroDispositivos; //Numero de dispositivos asociados al cuarto.

  @override

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState();
    _existe = false; //Se asume que la imagen en la galeria no existe.
    _comprobarImagen(); //Se comprueba la existencia de la imagen en la galeria.
    _textoNumeroDispositivos = "No hay dispositivos";
    _dispositivosCuarto = [];
    _obtenerDispositivos();
  }

  ///Busca que la imagen suministrada exista en la galeria, de ser verdad cambia
  ///el estado de_existe a "true".

  _comprobarImagen() {
    File(_pathImagen).exists().then((value) =>
        setState(() {
          _existe = value;
        })
    );
  }

  ///Hace una petición para conseguir un mapeo con la lista de los parámetros de
  ///los dispositivos asociados a un cuarto determinado, además actualiza el texto
  ///debajo del titulo para saber la condición de la petición.
  ///@param texto numero de dispositivos del cuarto.
  ///@param respuesta estado del servicio de obtener dispositivos del cuarto.
  ///@see owleddomo_app/cuartos/DispositivoTabla/ServiciosDispositivo.dispositivoCuarto#method().
  ///@see owleddomo_app/shared/TratarError.estadoServicioLeer#method().

  Future<void> _obtenerDispositivos() async {
    String texto = "0"; //Numero de dispositivos del cuarto.
    ServiciosDispositivo.dispositivoCuarto(_cuartoId)
        .then((result) {
      int respuesta = tratarError.estadoServicioLeer(result.first); //Estado del servicio de obtener dispositivos del cuarto.
      if (mounted) {
        setState(() {
          switch (respuesta) {
            case 0:
              _dispositivosCuarto = result.last;
              texto = _dispositivosCuarto.length.toString();
              _textoNumeroDispositivos = "Dispositivos x$texto";
              break;
            case 1:
              _dispositivosCuarto = null;
              _textoNumeroDispositivos = "No hay dispositivos";
              break;
            case 2:
              _dispositivosCuarto = null;
              _textoNumeroDispositivos = "Algo pasa con la APP";
              break;
            case 3:
              _dispositivosCuarto = null;
              _textoNumeroDispositivos = "No hay servidor";
              break;
            case 4:
              _dispositivosCuarto = null;
              _textoNumeroDispositivos = "No hay internet";
              break;
            case 5:
              _dispositivosCuarto = null;
              _textoNumeroDispositivos = "Algo va mal";
              break;
          }
        });
      }
    });
  }

  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    ///Construye el Widget encargado de la imagen del cuarto.
    ///@return un Container con la imagen del cuarto.

    Widget _imagenWidget () {
      return Container(
        height: _height/8.799,
        width: _width/2.769 ,
        margin: EdgeInsets.only(top: _height/264),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colores.obtenerColorDos(),
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: _pathImagen.substring(0,6) == "assets" ?
                   AssetImage(_pathImagen) :
                   _existe ? FileImage(File(_pathImagen)) :
                   AssetImage("assets/img/Imagen_no_disponible.jpg"),
          ),
        ),
      );
    }

    ///Construye el Widget encargado del título.
    ///@return un Container con el texto del nombre del cuarto.

    Widget _tituloCarta () {
      return Container(
        alignment: Alignment.center,
        height: _height/36,
        width: _width/3.272,
        child: Text(
          _nombre,
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

    ///Construye el Widget encargado del título.
    ///@return un Container con el texto del nombre del cuarto.

    Widget _numeroDispositivos () {
      return Container(
        height: _height/31.68,
        width: _width/2.769,
        alignment: Alignment.topCenter,
        child: Text(
          _textoNumeroDispositivos,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: _height/66,
            color: colores.obtenerColorInactivo(),
            fontFamily: "Lato",
          ),
        ),
      );
    }

    ///Construye el Widget que contiene todos los componentes para la carta.
    ///@return un Container con stack que apila la imagen, el titulo y el numero
    ///de dispositivos del cuarto en una columna.

    Widget _carta () {
      return Container(
        height: _height/5.617,
        width: _width/2.553,
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imagenWidget(),
            _tituloCarta(),
            _numeroDispositivos(),
          ],
        ),
      );
    }
    return _carta();
  }
}