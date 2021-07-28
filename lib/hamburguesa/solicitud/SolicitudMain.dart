import 'package:flutter/material.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'package:owleddomoapp/shared/PantallaEspera.dart';
import 'package:owleddomoapp/hamburguesa/solicitud/CartaSolicitud.dart';
import 'package:owleddomoapp/hamburguesa/solicitud/ServiciosSolicitud.dart';
import 'package:owleddomoapp/shared/TratarError.dart';

///Esta clase se encarga de la pantalla donde se direcciona la barra del menu al
///seleccionar solicitudes para compartir.
///@version 1.0, 06/04/21
///@author Juan Diego Suárez Londoño
///@param usuario identificador del usuario.
///@see owleddomo_app/shared/MenuHamburguesa.dart#class().
///return un Widget Container con una columna que contiene todas las solicitudes.

class SolicitudMain extends StatefulWidget {

  final Persona usuario; //Identificador del usuario.

  SolicitudMain(this.usuario);

  @override
  State<StatefulWidget> createState () {
    return _SolicitudMain(usuario);
  }

}

///Esta clase se encarga de formar un estado mutable de la clase “SolicitudMain”.
///@param _usuario identificador del usuario.
///@param _peticionesListaWidget lista de las cartas de las peticiones.
///@param _peticionesObtenidas lista con el mapeo de las peticiones.
///@param _estado estado del servicio de obtener peticiones.
///@param _refrescar indica si hay una pantalla de carga activa.
///@param _width obtiene el ancho de la pantalla del dispositivo.
///@param _height obtiene el alto de la pantalla del dispositivo.

class _SolicitudMain extends State<SolicitudMain> {

  final Persona _usuario;
  _SolicitudMain(this._usuario);

  List<Widget> _peticionesListaWidget; //Lista de las cartas de las peticiones.
  Future<List> _peticionesObtenidas; //Lista con el mapeo de las peticiones.

  int _estado; //Estado del servicio de obtener peticiones.
  bool _refrescar; //Indica si hay una pantalla de carga activa.

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState();
    _peticionesListaWidget = [];
    _estado = 1;
    _refrescar = false; //Inicializa este valor para que no haga un Navigator.pop al no tener pantalla de carga.
    _peticionesObtenidas= _obtenerPermisos();
  }

  ///Hace una petición para conseguir un mapeo con la lista de los parámetros de
  ///las peticiones, además actualiza el estado para saber la condición de la petición.
  ///@see owleddomo_app/hamburguesa/solicitud/ServiciosSolicitud.todasSolicitud#method().
  ///@see owleddomo_app/shared/TratarError.estadoServicioLeer#method().
  ///@return Un mapeo con las solicitudes.

  Future<List> _obtenerPermisos() async {
    _peticionesObtenidas =  ServiciosSolicitud.todasSolicitud(_usuario.persona_id);
    _peticionesObtenidas .then((result) {
      if (mounted) {
        setState(() {
          _estado = TratarError(_usuario).estadoServicioLeer(result);
        });
      }
    });
    return _peticionesObtenidas;
  }

  @override
  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    ///Arma una lista con las cartas de las peticiones obtenidas.
    ///@param peticionesObtenidas Lista con un mapeo de las peticiones.
    ///@return Una lista con los Widgets de todas las cartas de las peticiones.

    List<Widget> _armarTarjetaPermiso(List peticionesObtenidas) {
      _peticionesListaWidget = [];
      for (var i = 0; i < peticionesObtenidas.last.length; i++) {
        _peticionesListaWidget.insert(i, CartaSolicitud(_usuario,peticionesObtenidas.last[i]));
      }
      return _peticionesListaWidget;
    }

    ///Construye una fila de la lista de las peticiones.
    ///@param listaWidgets lista con todas las cartas.
    ///@param columnas lista con las cartas de esa columna.
    ///@return un Row con las cartas respectivas para la fila que se está armando.

    List<Widget> _obtenerFilas (List<Widget> listaWidgets) {
      List<Widget> columnas = []; //Lista con las cartas de esa columna.
      if(listaWidgets.length != 0) {
        for (var _indexWidget= 0; _indexWidget < listaWidgets.length; _indexWidget ++) {
          columnas.add(listaWidgets[_indexWidget]);
        }
      }
      columnas.add(Text(""));
      return columnas;
    }

    ///Una ventana emergente que bloquea el resto de la interfaz.
    ///@see owleddomo_app/shared/PantallaEspera.dart#class().

    _plantillaCarga(BuildContext context) {
      Future.delayed(Duration(milliseconds: 0), () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext dialogContext) {
            return PantallaEspera(_usuario);
          },
        );
      });
    }

    ///Despliega la pantalla de carga mediante un Widget de tipo Text.
    ///@return un texto vacío.

    Widget _cargando() {
      if (!_refrescar) {
        _plantillaCarga(context);
      }
      _refrescar = true; //Indica que se ha desplegado una pantalla de carga.
      return  Text("");
    }

    ///Se encarga de desplegar todas las posibles interfaces dependiendo de si
    ///hay datos para la lista o si hay un error de algún tipo.
    ///@return un Widget Container que posee un constructor futuro de una lista
    ///para las peticiones y los errores que se presenten.

    Widget _pantallaLogica() {
      return  Container(
        child: ListView(
          physics: BouncingScrollPhysics(),
          primary: false,
          addAutomaticKeepAlives: false,
          shrinkWrap: true,
          children: <Widget>[
            FutureBuilder<List>(
              future: _peticionesObtenidas,
              builder: (context, AsyncSnapshot<List> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  if (_refrescar) {
                    _refrescar = false;
                    Navigator.of(context).pop(null);
                  }
                  if ( _estado == 0 ) {
                    children = _obtenerFilas(_armarTarjetaPermiso(snapshot.data));
                  } else if(  _estado == 1) {
                    children = <Widget>[
                      //_pantallaSinRutinas(),
                    ];
                  } else if ( _estado == 2) {
                    children = <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.precision_manufacturing_sharp,
                              size: _height/7.92,
                              color: PaletaColores(_usuario).obtenerColorRiesgo(),
                            ),
                          ),
                          Container(
                            child: Text(
                              "No se pudo conectar con el dispositivo",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: _width/16.36363636363636,
                                color: PaletaColores(_usuario).obtenerColorRiesgo(),
                                fontFamily: "Lato",
                              ),
                            ),
                            width: _width/1.2,
                          ),
                        ],
                      ),
                    ];
                  } else if ( _estado == 3) {
                    children = <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.local_police_rounded,
                              size: _height/7.92,
                              color: PaletaColores(_usuario).obtenerColorRiesgo(),
                            ),
                          ),
                          Container(
                            child: Text(
                              "No te identificamos...\n¿Esto es tuyo?",
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: _width/16.36363636363636,
                                color: PaletaColores(_usuario).obtenerColorRiesgo(),
                                fontFamily: "Lato",
                              ),
                            ),
                            width: _width/1.2,
                          ),
                        ],
                      ),
                    ];
                  } else if ( _estado == 4) {
                    children = <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.cloud_off_rounded,
                              size: _height/7.92,
                              color: PaletaColores(_usuario).obtenerCuaternario(),
                            ),
                          ),
                          Container(
                            child: Text(
                              "Un avión tumbo nuestra nube...\nEstamos trabajando en ello :)",
                              maxLines: 5,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: _width/16.36363636363636,
                                color: PaletaColores(_usuario).obtenerCuaternario(),
                                fontFamily: "Lato",
                              ),
                            ),
                            width: _width/1.2,
                          ),
                        ],
                      ),
                    ];
                  } else if ( _estado == 5) {
                    children = <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.device_unknown_rounded,
                              size: _height/7.92,
                              color: PaletaColores(_usuario).obtenerColorRiesgo(),
                            ),
                          ),
                          Text(
                            "¡Rayos! Algo pasa con la app...",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: _width/16.36363636363636,
                              color: PaletaColores(_usuario).obtenerColorRiesgo(),
                              fontFamily: "Lato",
                            ),
                          ),
                        ],
                      ),
                    ];
                  } else if ( _estado == 6) {
                    children = <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.wifi_off_outlined,
                              size: _height/7.92,
                              color: PaletaColores(_usuario).obtenerColorInactivo(),
                            ),
                          ),
                          Container(
                            child: Text(
                              "Si la vida te da internet, has limonada",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: _width/16.36363636363636,
                                color: PaletaColores(_usuario).obtenerColorInactivo(),
                                fontFamily: "Lato",
                              ),
                            ),
                            width: _width/1.2,
                          ),
                        ],
                      ),
                    ];
                  } else if ( _estado == 8) {
                    children = <Widget>[
                      _cargando(),
                    ];
                  } else {
                    children = <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.error_rounded,
                              size: _height/7.92,
                              color: PaletaColores(_usuario).obtenerColorRiesgo(),
                            ),
                          ),
                          Text(
                            "Ups... Algo salio mal",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: _width/16.36363636363636,
                              color: PaletaColores(_usuario).obtenerColorRiesgo(),
                              fontFamily: "Lato",
                            ),
                          ),
                        ],
                      ),
                    ];
                  }
                } else if (snapshot.hasError) {
                  if (_refrescar) {
                    _refrescar = false;
                    Navigator.of(context).pop(null);
                  }
                  children = <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.error_rounded,
                            size: _height/7.92,
                            color: PaletaColores(_usuario).obtenerColorRiesgo(),
                          ),
                        ),
                        Text(
                          "Ups... Algo salio mal",
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: _width/16.36363636363636,
                            color: PaletaColores(_usuario).obtenerColorRiesgo(),
                            fontFamily: "Lato",
                          ),
                        ),
                      ],
                    ),
                  ];
                } else {
                  children = <Widget>[
                    _cargando(),
                  ];
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  ),
                );
              },
            ),
          ],
        ),
      );
    }

    return Container(
      child: _pantallaLogica(),
    );
  }
}