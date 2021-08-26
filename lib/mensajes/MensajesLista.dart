import 'package:flutter/material.dart';
import 'package:owleddomoapp/mensajes/CartaMensaje.dart';
import 'package:owleddomoapp/mensajes/ServiciosMensaje.dart';
import 'package:owleddomoapp/mensajes/Mensaje.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'package:owleddomoapp/shared/PantallaEspera.dart';
import 'package:owleddomoapp/shared/PantallaSinRed.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/shared/TratarError.dart';

///Esta clase se encarga de manejar la pantalla del despliegue de la lista de las
///rutinas y su lógica.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param usuario identificador del usuario.
///@see owleddomo_app/rutinas/RutinasMain.dart#class().
///@return Un Widget Container con una lista de las rutinas y su lógica en
///caso de un error.

class MensajesLista extends StatefulWidget {

  final Persona usuario; //Identificador del usuario.
  MensajesLista(this.usuario) :super(); //Constructor de la clase.

  @override
  _MensajesLista createState() => _MensajesLista(usuario); //Crea un estado mutable del Widget.

}

///Esta clase se encarga de formar un estado mutable de la clase “RutinasLista”.
///@param _usuario identificador del usuario.
///@param _rutinasListaWidget lista de los Widgets de las rutinas de los dispositivos.
///@param _rutinasObtenidas lista con el mapeo de las rutinas.
///@param _rutinasLista lista de las rutinas de los dispositivos.
///@param _numeroRutinas; //Indica el numero de rutinas actiales.
///@param _estado estado del servicio de obtener rutinas.
///@param _refrescar indica si hay una pantalla de carga activa.
///@param _dias lista con las listas de estados para los siete días de la semana para cada rutina.
///@param _habilitarDias indica que ya se han inicializado los días.
///@param _horas hora seleccionada.
///@param _minutos minutos seleccionados.
///@param _tiempo horas y minutos seleccionados para cada rutina.
///@param _tiempoSeleccionado controlador del tiempo actual del reloj para cada rutina.
///@param _controladorReloj controlador del texto del reloj para cada rutina.
///@param _actualizarTiempo indica si hay que actualizar el tiempo de las tarjetas.
///@param _width obtiene el ancho de la pantalla del dispositivo.
///@param _height obtiene el alto de la pantalla del dispositivo.

class _MensajesLista extends State<MensajesLista> {

  final Persona _usuario; //Identificador del usuario.
  _MensajesLista(this._usuario); //Constructor de la clase.

  List<Widget> _mensajesListaWidget; //Lista de los Widgets de las rutinas de los dispositivos.
  Future<List> _mensajesObtenidos; //Lista con el mapeo de las rutinas.
  List<Mensaje> _mensajesLista; //Lista de las rutinas de los dispositivos.

  int _estado; //Estado del servicio de obtener rutinas.
  bool _refrescar; //Indica si hay una pantalla de carga activa.

  @override

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState();
    _mensajesListaWidget = [];
    _mensajesLista = [];
    _estado = 0;
    _refrescar = false; //Inicializa este valor para que no haga un Navigator.pop al no tener pantalla de carga.
    _mensajesObtenidos = _obtenerMensaje();
  }

  ///Hace una petición para conseguir un mapeo con la lista de los parámetros
  ///de las rutinas.
  ///@see owleddomo_app/rutinas/ServiciosRutina.todasRutinas#method().
  ///@return un mapeo con las rutinas.

  Future<List> _obtenerMensaje() async {
    setState(() {
      _mensajesObtenidos =  ServiciosMensaje.todosMensajes(_usuario);
    });
    _mensajesObtenidos.then((value) => {
      print(value.first),
      _estado = TratarError(_usuario).estadoServicioLeer(value.first),
      if(value.first == "EXITO" && value.last != "EXITO" ) {
      } else if (value.first == "EXITO") {
        _estado = 1,
      }
    });
    return _mensajesObtenidos;
  }

  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

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

    ///Construye el Widget de la carta de las rutinas.
    ///@param rutina datos del la rutina para armar la carta.
    ///@param index posicion de los datos en la lista.
    ///@return Un Card que contiene un contenedor expansible.

    Widget _botonCarta(Mensaje mensaje, int index) {
      return Container (
        margin: EdgeInsets.all(10),
        alignment: Alignment.centerLeft,
        child: CartaMensaje(_usuario,"rutina", mensaje.evento,"perPro", mensaje.asociacion.toString(),
                            0, mensaje.notificacion_id, mensaje.fecha_creacion.substring(11,16), mensaje.fecha_creacion.substring(0,10)),
      );
    }

    ///Arma una lista con las cartas de las rutinas obtenidos.
    ///@param rutinasObtenidas Lista con un mapeo de las rutinas.
    ///@return Una lista con los Widgets de todas las cartas de las rutinas.

    List<Widget> _armarTarjetaMensaje(List mensajesObtenidos) {
      _mensajesListaWidget = [];
      for (var i = 0; i < mensajesObtenidos.last.length; i++) {
        _mensajesListaWidget.insert(i, _botonCarta(mensajesObtenidos.last[i], i));
      }
      return _mensajesListaWidget;
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
      return columnas;
    }

    ///Pantalla en caso de no tener ningúna rutina.
    ///@return un Center con un texto y el botón agregar rutinas.

    Widget _pantallaSinRutinas() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Nada que reportar capitan",
              style: TextStyle(
                fontSize: _height/26.4,
                fontFamily: "Lato",
              ),
            ),
          ],
        ),
      );
    }

    ///Despliega la pantalla de carga mediante un Widget de tipo Text.
    ///@return un texto vacío.

    Widget _cargando() {
      _refrescar = true; //Indica que se ha desplegado una pantalla de carga.
      _plantillaCarga(context);
      return  Text("");
    }

    ///Se encarga de desplegar todas las posibles interfaces dependiendo de si
    ///hay datos para la lista o si hay un error de algún tipo.
    ///@return un Widget Container que posee un constructor futuro de una lista
    ///para los cuartos y los errores que se presenten.

    Widget _pantallaLogica() {
      return  Container(
        child: ListView(
          physics: BouncingScrollPhysics(),
          primary: false,
          addAutomaticKeepAlives: false,
          shrinkWrap: true,
          children: <Widget> [
            FutureBuilder<List>(
              future: _mensajesObtenidos,
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  if (_refrescar) {
                    _refrescar = false;
                    Navigator.of(context).pop(null);
                  }
                  if ( _estado == 0 ) {
                    children = _obtenerFilas(_armarTarjetaMensaje(snapshot.data));
                  } else if(  _estado == 1) {
                    children = <Widget>[
                      _pantallaSinRutinas(),
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
                          Text(
                            "¡Rayos! Algo pasa con la app...",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: PaletaColores(_usuario).obtenerColorRiesgo(),
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
                              color: PaletaColores(_usuario).obtenerCuaternario(),
                            ),
                          ),
                          Text(
                            "Un avión tumbo nuestra nube...\nEstamos trabajando en ello :)",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: PaletaColores(_usuario).obtenerCuaternario(),
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
                        child: PantallaCargaSinRed(),
                      ),
                    ];
                  } else if ( _estado == 5) {
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

    return SingleChildScrollView(
      child: Container(
        child: _pantallaLogica(),
      ),
    );
  }
}