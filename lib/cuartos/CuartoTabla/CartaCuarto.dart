import 'dart:io';
import 'package:flutter/material.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/ServiciosDispositivo.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'package:owleddomoapp/shared/TratarError.dart';

///Esta clase se encarga de construir la vista dentro de la carta de un
///cuarto, dotándola de una imagen, un título y el numero de dispositivos totales
///que posee el cuarto.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param cuartoId identificador único del cuarto.
///@param nombre nombre del cuarto.
///@param pathImagen path de la imagen en los assets.
///@param usuario propietario de la cuenta.
///@see owleddomo_app/cuartos/CuartosTabla/CuartosLista.dart#class().
///@return un Widget Container con la plantilla de la carta de un cuarto.

class CartaCuarto extends StatefulWidget{

  final String cuartoId; //Identificador unico del cuarto.
  final String nombre; //Nombre del cuarto.
  final String pathImagen; //Path de la imagen en los assets.
  final Persona usuario; //Propietario de la cuenta.
  CartaCuarto(this.cuartoId, this.nombre, this.pathImagen, this.usuario) :super(); //Constructor de la clase.

  @override
  _CartaCuarto createState() => _CartaCuarto(cuartoId, nombre, pathImagen, usuario); //Crea un estado mutable del Widget.

}

///Esta clase se encarga de formar un estado mutable de la clase “CartaCuarto”.
///@param _cuartoId identificador unico del cuarto.
///@param _nombre nombre del cuarto.
///@param _pathImagen path de la imagen en los assets.
///@param _usuario propietario de la cuenta.
///@paran _existe indica la existencia de la imagen.
///@param _dispositivosCuarto lista de dispositivos asociados al cuarto.
///@param _textoNumeroDispositivos numero de dispositivos asociados al cuarto.
///@param _width obtiene el ancho de la pantalla del dispositivo.
///@param _height obtiene el alto de la pantalla del dispositivo.

class _CartaCuarto extends State<CartaCuarto> {

  final String _cuartoId; //Identificador unico del cuarto.
  final String _nombre; //Nombre del cuarto.
  String _pathImagen; //Path de la imagen en los assets.
  final Persona _usuario; //Propietario de la cuenta.

  _CartaCuarto(this._cuartoId, this._nombre, this._pathImagen, this._usuario); //Constructor de la clase.

  bool _existe; //Indica la existencia de la imagen.
  String _textoNumeroDispositivos; //Numero de dispositivos asociados al cuarto.

  @override

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState();
    _existe = false; //Se asume que la imagen en la galeria no existe.
    _comprobarImagen(); //Se comprueba la existencia de la imagen en la galeria.
    _textoNumeroDispositivos = "No hay dispositivos"; //Texto predeterminado en caso de no haber dispositivos.
    _obtenerDispositivos();
  }

  ///Busca que la imagen suministrada exista en la galeria, de ser verdad cambia
  ///el estado de _existe a "true".

  _comprobarImagen() {
    File(_pathImagen).exists().then((value) => {
      if(mounted) {
        setState(() {
          _existe = value;
        })
      }
    }
    );
  }

  ///Hace una petición para conseguir un mapeo con la lista de los parámetros de
  ///los dispositivos asociados a un cuarto determinado, además actualiza el texto
  ///debajo del titulo para saber la condición de la petición.
  ///@param texto numero de dispositivos que posee cuarto.
  ///@see owleddomo_app/cuartos/DispositivoTabla/ServiciosDispositivo.dispositivoCuarto#method().
  ///@see owleddomo_app/shared/TratarError.estadoServicioLeer#method().

  Future<void> _obtenerDispositivos() async {
    List<String> textos = ['Dispositivos x','No hay dispositivos','Falla de dispositivo',
                           'Acceso denegado','Servidor roto','Algo pasa con la APP',
                           'No hay internet','Algo va mal'];
    ServiciosDispositivo.dispositivoCuarto(_cuartoId, _usuario.persona_id).then((result) {
      if (mounted) {
        setState(() {
          _textoNumeroDispositivos = TratarError().textoAgregado(result,textos, true).last;
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
          color: PaletaColores().obtenerSecundario(),
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
            color: PaletaColores().color_letra_contraste_secundario,
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
            color: PaletaColores().color_letra_contraste_secundario.withOpacity(0.4),
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