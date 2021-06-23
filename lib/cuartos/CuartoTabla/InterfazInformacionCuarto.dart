import 'dart:io';
import 'package:flutter/material.dart';
import 'package:owleddomoapp/cuartos/CuartoTabla/ServiciosCuarto.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/ServiciosDispositivo.dart';
import 'package:owleddomoapp/cuartos/CuartoTabla/InterfazEditarCuarto.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/Dispositivo.dart';
import 'package:owleddomoapp/shared/SubPantallaUno.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/shared/TratarError.dart';
import 'package:owleddomoapp/shared/FondoCubo.dart';

final PaletaColores colores = new PaletaColores(); //Colores predeterminados.
final TratarError tratarError = new TratarError(); //Respuestas predeterminadas a las API.

///Esta clase se encarga de la pantalla donde se muestra la información del cuarto
///y su lógica.
///@version 1.0, 06/04/21
///@author Juan Diego Suárez Londoño
///@param cuarto_id identificador del cuarto.
///@param nombre nombre del cuarto.
///@param imagen valor para seleccionar la imagen.
///@param descripcion breve descripción del cuarto.
///@param usuario identificador del usuario.
///@see owleddomo_app/cuartos/CuartoTabla/CuartosLista.dart#class().
///@return un Widget ListView con la información básica del cuarto como la imagen,
///el nombre, los dispositivos asociados y la descripción, además,
///las variables de dicho dispositivo.

class InterfazInformacionCuarto extends StatefulWidget{

  final String cuarto_id; //Identificador del cuarto.
  final String nombre; //Nombre del cuarto.
  final String imagen; //Valor para seleccionar la imagen.
  final String descripcion; //Breve descripción del cuarto.
  final String usuario; //Usuario identificador del usuario.
  InterfazInformacionCuarto(this.cuarto_id, this.nombre, this.imagen, this.descripcion,
                            this.usuario); //Constructor de la clase.

  @override
  State<StatefulWidget> createState() {
    return _InterfazInformacionCuarto(this.cuarto_id, this.nombre, this.imagen,
                                      this.descripcion, this.usuario); //Crea un estado mutable del Widget.
  }

}

///Esta clase se encarga de formar un estado mutable de la clase “InterfazInformacionCuarto”.
///@param _cuarto_id identificador del cuarto.
///@param _nombre nombre del cuarto.
///@param _imagen valor para seleccionar la imagen.
///@param _descripcion breve descripción del cuarto.
///@param _usuario identificador del usuario.
///@param _existe si una imagen existe es true, de no serlo es false.
///@param _dispositivosCuarto lista de dispositivos asociados al cuarto.
///@param _width obtiene el ancho de la pantalla del dispositivo.
///@param _height obtiene el alto de la pantalla del dispositivo.

class _InterfazInformacionCuarto extends State<InterfazInformacionCuarto> {

  final String _cuartoId; //Identificador del cuarto.
  String _nombre; //Nombre del cuarto.
  String _imagen; //Valor para seleccionar la imagen.
  String _descripcion; //Descripción del cuarto.
  final String _usuario; //Identificador del usuario.
  _InterfazInformacionCuarto(this._cuartoId, this._nombre, this._imagen,
                             this._descripcion, this._usuario); //Constructor de la clase.

  bool _existe; //Indica la existencia de la imagen.
  Future<List> _dispositivosObtenidos; //Lista de dispositivos asociados al cuarto.
  int _estado; //Estado del servicio de obtener dispositivos.

  @override

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState();
    _existe = false; //Se asume que la imagen en la galeria no existe.
    _comprobarImagen(); //Se comprueba la existencia de la imagen en la galeria.
    _estado = 0;
  }

  ///Busca que la imagen suministrada exista en la galeria, de ser verdad cambia
  ///el estado de_existe a "true".

  _comprobarImagen() {
    File(_imagen).exists().then((value) =>
        setState(() {
          _existe = value;
        })
    );
  }

  ///Hace una petición para conseguir un mapeo con la lista de los parámetros
  ///de los dispositivos del cuarto además actualiza el estado para saber la
  ///condición de la petición.
  ///@see owleddomo_app/cuartos/DisporitivoTabla/ServiciosDispositivo.dispositivoCuarto#method().
  ///@see owleddomo_app/shared/TratarError.estadoServicioLeer#method().
  ///@return un mapeo con los dispositivos.

  Future<List> _obtenerDispositivos() async {
    setState(() {
      _dispositivosObtenidos = ServiciosDispositivo.dispositivoCuarto(_cuartoId);
    });
    _dispositivosObtenidos.then((result) => {
      _estado = tratarError.estadoServicioLeer(result.first),
    });
    return _dispositivosObtenidos;
  }

  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    ///Construye el Widget de la imagen del cuarto.
    ///@return un Widget de Padding que contiene una imagen.

    Widget _imagenCarta () {
      return Center(
        heightFactor: _height/660,
        child: Container(
          width: _height/5.28,
          height: _height/5.28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: colores.obtenerColorCuatro(),
              width: _height/300,
            ),
            color: colores.obtenerColorDos(),
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
                image: _imagen.substring(0,6) == "assets" ?
                AssetImage(_imagen) :
                  _existe ? FileImage(File(_imagen)) :
                  AssetImage("assets/img/Imagen_no_disponible.jpg"),
            ),
          ),
        ),
      );
    }

    ///Construye el Widget del nombre del cuarto.
    ///@return un Widget de Padding que contiene un texto.

    Widget _nombreTitulo () {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal:_height/26.4,
          vertical: _width/24,
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Text(
            _nombre,
            textAlign: TextAlign.left,
            maxLines: 1,
            style: TextStyle(
              fontFamily: "lato",
              fontWeight: FontWeight.bold,
              fontSize: _height/19.8,
            ),
          ),
        ),
      );
    }

    ///Construye una minicarta de un dispositivo dado.
    ///@param dispositivo parametros del dispositivo.
    ///@param _imagen archivo de la imagen del dispositivo.
    ///@param _existe si una imagen existe es true, de no serlo es false.
    ///@return un Widget de Padding que contiene una minicarta de un dispositivo.

    Widget _botonCarta(Dispositivo dispositivo) {
      File _imagen = File(dispositivo.url_foto); //Archivo de la imagen del dispositivo.
      bool _existe = _imagen.existsSync(); //Si una imagen existe es true, de no serlo es false.
      return Padding(
          padding: EdgeInsets.only(
            right: _width/40,
            left: _width/40,
      ),
        child: Container(
        height: _height/9.218,
        width: _height/9.218,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black45,
                  blurRadius: 10,
                  offset: Offset(0,10)
              )
            ],
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: _existe ? FileImage(_imagen) :
                               AssetImage("assets/img/Imagen_no_disponible.jpg"),
            ),
        ),
        ),
      );
    }

    ///Arma una lista de minicartas de todos los dispositivos del cuarto.
    ///@param dispositivosObtenidas lista con los dispositivos del cuarto.
    ///@param cartasDispositivos lista con las minicartas de los dispositivos del cuarto.
    ///@return una lista de Widget con las minicartas de los dispositivos del cuarto.

    List<Widget> _armarTarjetasDispositivos(List<Dispositivo> dispositivosObtenidas)  {
      List<Widget> cartasDispositivos = []; //Lista con las minicartas de los dispositivos del cuarto.
      for (var i = 0; i < dispositivosObtenidas.length; i++) {
        cartasDispositivos.insert(i, _botonCarta(dispositivosObtenidas[i]));
      }
      return cartasDispositivos;
    }

    ///Se encarga de desplegar la lista horizontal de los dispositivos del cuarto.
    ///@param dispositivosObtenidas lista con los dispositivos del cuarto.
    ///@return una Widget Padding con las minicartas de los dispositivos del cuarto
    ///de manera horizontal.

    Widget _dispositivos (List dispositivosObtenidas) {
      return Row(
        children: _armarTarjetasDispositivos(dispositivosObtenidas.last),
      );
    }

    ///Construye el Widget que maneja la descripción del cuarto.
    ///@return un Widget de Padding que contiene la descripción del cuarto.

    Widget _descripcionWidget () {
      return Padding(
        padding: EdgeInsets.only(
          right: _width/12,
          left: _width/12,
          top: _height/9.218,
        ),
        child: Container(
          height: _height/3.3,
          width: _width/1.374,
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(
                color: colores.obtenerColorCuatro(),
                width: _height/396,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Text(
              _descripcion,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontFamily: "lato",
                fontSize: _height/52.8,
              ),
            ),
          ),
        ),
      );
    }

    ///Construye el Widget que despliega una ventana emergente para confirmar el
    ///borrar el cuarto.

    Widget _confirmarBorrar () {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (buildcontext) {
            return AlertDialog(
              backgroundColor: colores.obtenerColorUno(),
              title: Text(
                "¿Está seguro?",
                style: TextStyle(
                  color: colores.obtenerColorDos(),
                ),
              ),
              content: Text(
                "Al eliminar este cuarto se perderá la configuración del mismo.",
                style: TextStyle(
                  color: colores.obtenerColorDos(),
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: colores.obtenerColorTres(),
                  ),
                  child:Container (
                    width: _width/6.428571428571429,
                    child: Row (
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        Icon(
                          Icons.warning_rounded,
                          color: colores.obtenerColorDos(),
                          size: _height/26.4,
                        ),
                        Text(
                          "OK",
                          style: TextStyle(
                            color: colores.obtenerColorDos(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    ServiciosCuarto.borrarCuarto(_cuartoId, _usuario)
                        .then((result) {
                      tratarError.estadoServicioActualizar( result, [], context);
                    });
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: colores.obtenerColorRiesgo(),
                  ),
                  child:Container (
                    width: _width/6.428571428571429,
                    child: Row (
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        Text(
                          "Cancelar",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  onPressed: (){
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          }
      );
    }

    ///Construye el Widget que maneja el botón para borrar el cuarto.
    ///@return un Widget de Container con un ConstrainedBox que actúa como
    ///botón.

    Widget _botonBorrar () {
      return Container(
        child:ConstrainedBox(
          constraints: BoxConstraints.tightFor(height: _height/14.4),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: colores.obtenerColorRiesgo(),
              shape: CircleBorder(),
            ),
            onPressed: () {
              _confirmarBorrar();
            },
            child: Icon(
              Icons.delete_rounded,
              color: colores.obtenerColorDos(),
              size: _height/26.4,
            ),
          ),
        ),
      );
    }

    ///Construye el Widget que maneja el botón para editar el cuarto.
    ///@return un Widget de Container que contiene un ConstrainedBox que actúa como
    ///botón.

    Widget _botonEditar () {
      return Container(
        child:ConstrainedBox(
          constraints: BoxConstraints.tightFor(height: _height/14.4),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: colores.obtenerColorTres(),
              shape: CircleBorder(),
            ),
            onPressed: () {
              Route route = MaterialPageRoute (
                builder: (context) => SubPantallaUno(InterfazEditarCuarto(_cuartoId, _nombre, _imagen, _descripcion, _usuario),"Editando"),
              );
              Navigator.push(context, route).then((value) =>{
                if ( value != false ) {
                  setState(() {
                    _nombre = value[0];
                    _imagen = value[1];
                    _comprobarImagen();
                    _descripcion = value[2];
                  }),
                }
              });
            },
            child: Icon(
              Icons.edit_rounded,
              color: colores.obtenerColorDos(),
              size: _height/26.4,
            ),
          ),
        ),
      );
    }

    ///Construye el Widget que contiene los botones de editar y borrar en una misma fila.
    ///@return un Widget de Column que contiene en un Row los botones de editar y borrar.

    Widget _barraInferior () {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              bottom: _height/26.4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _botonEditar(),
                _botonBorrar(),
              ],
            ),
          ),
        ],
      );
    }

    ///Construye el Widget que contiene la carta donde están ubicados la descripción
    ///y el nombre del cuarto.
    ///@return un Widget de Padding que contiene una carta con dos textos en columna.

    Widget _carta () {
      return Padding(
        padding: EdgeInsets.only(
          top: _height/4.658,
          bottom: _height/13.2,
          right: _width/24,
          left: _width/24,
        ),
        child: Card(
          color: colores.obtenerColorDos(),
          child: Container(
            height: _height/1.513043,
            width: _width/1.118,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _nombreTitulo(),
                _descripcionWidget (),
              ],
            ),
          ),
        ),
      );
    }

    ///Se encarga de desplegar todas las posibles interfaces de la sección de las
    ///minicartas de los dispositivos que posea el cuarto dependiendo de si hay
    ///datos o si hay un error de algún tipo.
    ///@return un Widget Padding que posee un constructor futuro de una lista
    ///para los dispositivos del cuarto y los errores que se presenten.

    Widget _interfazMinicartas() {
      return Padding(
        padding: EdgeInsets.only(
          top: _height/3.3,
        ),
        child: Container(
          child: Center(
            child: ListView(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                FutureBuilder<List>(
                  future: _obtenerDispositivos(),
                  builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                    List<Widget> children;
                    if (snapshot.hasData) {
                      if( _estado == 0 ) {
                        children = <Widget> [
                          _dispositivos(snapshot.data)
                        ];
                      } else if( _estado == 1){
                        children = <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: _height/26.4),
                            child: Text(
                              'Estoy triste porque no tengo dispositivos   :c',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colores.obtenerColorUno(),
                                fontFamily: "Lato",
                              ),
                            ),
                          ),
                        ];
                      } else if ( _estado == 2) {
                        children = <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: _height/26.4),
                            child: Text(
                              "¡Rayos! Algo pasa con la app...",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colores.obtenerColorRiesgo(),
                                fontFamily: "Lato",
                              ),
                            ),
                          ),
                        ];
                      }
                      else if ( _estado == 3) {
                        children = <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: _height/26.4),
                            child: Text(
                              "Un avión tumbo nuestra nube...\nEstamos trabajando en ello :)",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colores.obtenerColorCuatro(),
                                fontFamily: "Lato",
                              ),
                            ),
                          ),
                        ];
                      }
                      else if ( _estado == 4) {
                        children = <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: _height/26.4),
                            child: Text(
                              "Si la vida te da internet, has limonada",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colores.obtenerColorInactivo(),
                                fontFamily: "Lato",
                              ),
                            ),
                          ),
                        ];
                      } else {
                        children = <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: _height/26.4),
                            child: Text(
                              "Ups... Algo salio mal",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colores.obtenerColorRiesgo(),
                                fontFamily: "Lato",
                              ),
                            ),
                          ),
                        ];
                      }
                    } else if (snapshot.hasError) {
                      children = <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: _height/26.4),
                          child: Text(
                            "Ups... Algo salio mal",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colores.obtenerColorRiesgo(),
                              fontFamily: "Lato",
                            ),
                          ),
                        ),
                      ];
                    } else {
                      children = <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: _height/26.4,
                              ),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(colores.obtenerColorUno()),
                              ),
                            ),
                          ],
                        ),
                      ];
                    }
                    return Column(
                      children: children,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        Container(
          height: _height/1.176820208023774,
          child: Stack(
            children: <Widget>[
              FondoCubo(),
              _imagenCarta(),
              _carta(),
              _interfazMinicartas(),
              _barraInferior(),
            ],
          ),
        ),
      ],
    );
  }
}