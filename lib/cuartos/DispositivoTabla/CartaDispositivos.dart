import 'package:flutter/material.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';

final PaletaColores colores = new PaletaColores(); //Colores predeterminados.

///Esta clase se encarga de construir la vista dentro de la carta de un
///dispositivo, dotándola de una imagen de fondo y un título para las cartas en
///la lista de dispositivos.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param nombre nombre del dispositivo.
///@param path_foto path foto en el dispositivo.
///@see owleddomo_app/cuartos/DisporitivoTabla/DispositivosLista.dart#class().
///@return un Widget Container con la plantilla de la carta de un dispositivo.

class CartaDispositivo extends StatefulWidget{

  final String nombre; //Nombre del dispositivo.
  final String path_foto; //Path foto en el dispositivo
  CartaDispositivo(this.nombre, this.path_foto) :super(); //Constructor de la clase.

  @override
  _CartaDispositivo createState() => _CartaDispositivo(nombre,path_foto); //Crea un estado mutable del Widget.

}

///Esta clase se encarga de formar un estado mutable de la clase “CartaDispositivo”.
///@param _dispositivo campos del dispositivo.
///@param _path_foto path foto en el dispositivo.
///@param _width obtiene el ancho de la pantalla del dispositivo.
///@param _height obtiene el alto de la pantalla del dispositivo.

class _CartaDispositivo extends State<CartaDispositivo> {

  final String _nombre; //Nombre del dispositivo.
  final String _path_foto; //Path foto en el dispositivo.
  _CartaDispositivo(this._nombre, this._path_foto); //Constructor de la clase.

  @override

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState(); //Método inicializador de la clase padre "State".
  }

  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    ///Construye el Widget encargado del título.
    ///@return un Container con el texto del nombre del dispositivo.

    Widget _tituloDispositivo () {
      return Container(
        alignment: Alignment.center,
        width: _width/3.272,
        height: _height/7.374,
        child: Text(
          _nombre,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          style: TextStyle(
            color: Colors.white,
            fontSize: _height/40.96969696969697,
            fontWeight: FontWeight.bold,
            fontFamily: "Lato",
          ),
        ),
      );
    }

    ///Construye el Widget encargado del la imagen de fondo.
    ///@return un Container con la imagen del dispositivo pasada por un filtro
    ///de oscurecimiento en caso de que exista, de no ser así, usa la imagen
    ///preestablecida “Imagen_no_disponible.jpg”.

    Widget _imagenCarta () {
      return Container(
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Color(0xff5B5B5B), BlendMode.multiply),
            fit: BoxFit.cover,
            image: AssetImage(_path_foto),
          ),
        ),
      );
    }

    ///Construye el Widget que contiene todos los componentes para la carta.
    ///@return un Container con stack que apila la imagen y el nombre, en ese orden.

    Widget _carta () {
      return Container(
        height: _height/5.617,
        width: _width/2.553,
        child: Stack (
          alignment: Alignment.center,
          children: <Widget>[
            _imagenCarta(),
            _tituloDispositivo(),
          ],
        ),
      );
    }

    return _carta();
  }
}