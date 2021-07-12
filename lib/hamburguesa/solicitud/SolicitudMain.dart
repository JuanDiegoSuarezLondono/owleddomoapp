import 'package:flutter/material.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'package:owleddomoapp/hamburguesa/solicitud/Solicitud.dart';
import 'package:owleddomoapp/hamburguesa/solicitud/ServiciosSolicitud.dart';

final  colores = new PaletaColores();

class SolicitudMain extends StatefulWidget {

  final Persona usuario;
  SolicitudMain(this.usuario);

  @override
  State<StatefulWidget> createState () {
    return _SolicitudMain(usuario);
  }

}

class _SolicitudMain extends State<SolicitudMain> {

  final Persona _usuario;
  _SolicitudMain(this._usuario);

  List<Widget> _peticionesListaWidget; //Lista de los Widgets de las rutinas de los dispositivos.
  Future<List> _peticionesObtenidas; //Lista con el mapeo de las rutinas.
  List<Solicitud> _peticionesLista; //Lista de las rutinas de los dispositivos.

  int _estado; //Estado del servicio de obtener rutinas.
  bool _refrescar; //Indica si hay una pantalla de carga activa.

  void initState() {
    super.initState();
    _estado = 0;
    _refrescar = false; //Inicializa este valor para que no haga un Navigator.pop al no tener pantalla de carga.
    _obtenerPermisos();
  }

  ///Acción de navegación a la interfaz de la información de un cuarto al
  ///presionar la carta de un cuarto, y al regresar actualiza la lista de cuartos.
  ///@param cuarto datos del cuarto para pasarle a la interfaz del cuarto.
  ///@see owleddomo_app/shared/SubPantallaUno.dart#class().
  ///@see owleddomo_app/cuartos/CuartoTabla/InterfazInformacionCuarto.dart#class().

  _alPresionar (Solicitud solicitud, String accion) {
    if(accion == "1") {
      ServiciosSolicitud.aceptarSolicitud(_usuario.persona_id, solicitud.permiso_id);
    } else {
      ServiciosSolicitud.negarSolicitud(_usuario.persona_id,solicitud.permiso_id);
    }

  }

  Future<List> _obtenerPermisos() async {
    setState(() {
      _peticionesObtenidas =  ServiciosSolicitud.todasSolicitud(_usuario.persona_id);
    });
    _peticionesObtenidas .then((value) => {
      if(value.first != value.last) {
        _peticionesLista = value.last,
      }
    });
    return _peticionesObtenidas;
  }

  @override
  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    Widget _botonNegar (Solicitud solicitud) {
      return Container(
        child:ConstrainedBox(
          constraints: BoxConstraints.tightFor(height: _height/17.6),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: colores.obtenerColorRiesgo(),
              shape: CircleBorder(),
            ),
            onPressed: () {
              _alPresionar (solicitud, "0");
            },
            child: Icon(
              Icons.clear,
              color: colores.obtenerColorDos(),
              size: _height/26.4,
            ),
          ),
        ),
      );
    }

    Widget _botonAceptar (Solicitud solicitud) {
      return Container(
        child:ConstrainedBox(
          constraints: BoxConstraints.tightFor(height: _height/17.6),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: colores.obtenerColorTres(),
              shape: CircleBorder(),
            ),
            onPressed: () {
              _alPresionar (solicitud, "1");
            },
            child: Icon(
              Icons.thumb_up,
              color: colores.obtenerColorDos(),
              size: _height/26.4,
            ),
          ),
        ),
      );
    }

    ///Construye el Widget de la carta de las rutinas.
    ///@param rutina datos del la rutina para armar la carta.
    ///@param index posicion de los datos en la lista.
    ///@return Un Card que contiene un contenedor expansible.

    Widget _botonCarta(Solicitud solicitud, int index) {
      String remitente = "Fulano";
      if(solicitud.apodo != null) {
        remitente = solicitud.apodo;
      } else {
        remitente = '${solicitud.nombres} ${solicitud.apellidos}';
      }
      return Card(
        margin: EdgeInsets.only(top: _height/79.2),
        color: colores.obtenerColorUno(),
        child: Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.all(20),
          width: 280,
          child: Column (
            children: <Widget>[
              Text(
                '¡Alguien confía en ti!',
                style: TextStyle(
                  color: colores.obtenerColorDos(),
                  fontSize: 25,
                  fontFamily: "Lato",
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  '\nPropietario: ${remitente}.\n\n Tipo de dispositivo: ${solicitud.tipo}.'
                      '\n\n Nombre dispositivo: ${solicitud.nombre}.',
                  style: TextStyle(
                    color: colores.obtenerColorDos(),
                    fontSize: 15,
                    fontFamily: "Lato",
                    height: 1,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: solicitud.estado == "pendiente" ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
                  children: [
                    solicitud.estado == "pendiente" ? _botonAceptar (solicitud)
                        : Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Text(
                        "Has aceptado",
                        style: TextStyle(
                          color: colores.obtenerColorDos(),
                          fontSize: 15,
                          fontFamily: "Lato",
                          height: 1,
                        ),
                      ),
                    ),
                    solicitud.estado == "pendiente" ? _botonNegar (solicitud)
                        : Icon(
                      Icons.favorite,
                      color: colores.obtenerColorCuatro(),
                      size: 24.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    ///Arma una lista con las cartas de las rutinas obtenidos.
    ///@param rutinasObtenidas Lista con un mapeo de las rutinas.
    ///@return Una lista con los Widgets de todas las cartas de las rutinas.

    List<Widget> _armarTarjetaPermiso(List peticionesObtenidas) {
      _peticionesListaWidget = [];
      for (var i = 0; i < peticionesObtenidas.last.length; i++) {
        _peticionesListaWidget.insert(i, _botonCarta(peticionesObtenidas.last[i], i));
      }
      return _peticionesListaWidget;
    }

    ///Construye una fila de la lista de rutinas.
    ///@param listaWidgets lista con todas las cartas.
    ///@param columnas lista con las cartas de esa columna.
    ///@return un Row con las cartas respectivas para la fila que se está armando.

    List<Widget> _obtenerFilas (List<Widget> listaWidgets) {
      List<Widget> columnas = []; //Lista con las filas de la lista de cuartos.
      if(listaWidgets.length != 0) {
        for (var _indexWidget= 0; _indexWidget < listaWidgets.length; _indexWidget ++) {
          columnas.add(listaWidgets[_indexWidget]);
        }
      }
      columnas.add(Text(""));
      return columnas;
    }

    return Container(
      child: ListView(
        physics: BouncingScrollPhysics(),
        primary: false,
        addAutomaticKeepAlives: false,
        shrinkWrap: true,
        children: <Widget>[
          FutureBuilder<List>(
            future: _obtenerPermisos(),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
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
                            color: colores.obtenerColorRiesgo(),
                          ),
                        ),
                        Text(
                          "¡Rayos! Algo pasa con la app...",
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colores.obtenerColorRiesgo(),
                            fontFamily: "Lato",
                          ),
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
                            Icons.cloud_off_rounded,
                            size: _height/7.92,
                            color: colores.obtenerColorCuatro(),
                          ),
                        ),
                        Text(
                          "Un avión tumbo nuestra nube...\nEstamos trabajando en ello :)",
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colores.obtenerColorCuatro(),
                            fontFamily: "Lato",
                          ),
                        ),
                      ],
                    ),
                  ];
                } else if ( _estado == 4) {
                  children = <Widget>[
                    Container(
                      height: _height/1.427027027027027,
                      child: Text(""),//PantallaCargaSinRed(),
                    ),
                  ];
                } else if ( _estado == 5) {
                  children = <Widget>[
                    //_cargando(),
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
                            color: colores.obtenerColorRiesgo(),
                          ),
                        ),
                        Text(
                          "Ups... Algo salio mal",
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colores.obtenerColorRiesgo(),
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
                          color: colores.obtenerColorRiesgo(),
                        ),
                      ),
                      Text(
                        "Ups... Algo salio mal",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colores.obtenerColorRiesgo(),
                          fontFamily: "Lato",
                        ),
                      ),
                    ],
                  ),
                ];
              } else {
                children = <Widget>[
                  //_cargando(),
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
}