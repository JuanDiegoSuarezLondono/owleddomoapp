import 'package:flutter/material.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/InterfazInformacionDispositivo.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/InterfazAgregarDispositivo.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/ServiciosDispositivo.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/CartaDispositivos.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/Dispositivo.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/shared/PantallaSinRed.dart';
import 'package:owleddomoapp/shared/SubPantallaUno.dart';
import 'package:owleddomoapp/shared/PantallaEspera.dart';
import 'package:owleddomoapp/shared/TratarError.dart';
import 'package:avatar_glow/avatar_glow.dart';

final PaletaColores colores = new PaletaColores(); //Colores predeterminados.
final TratarError tratarError = new TratarError(); //Respuestas predeterminadas a las API.

///Esta clase se encarga de manejar la pantalla del despliegue de la lista de los
///dispositivos y su lógica.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param usuario identificador del usuario.
///@see owleddomo_app/cuartos/CuartosMain.dart#class().
///@return un Widget Container con una lista de los dispositivos y su lógica en
///caso de un error.

class DispositivosLista extends StatefulWidget {

  final String usuario; //Identificador del usuario.
  DispositivosLista(this.usuario) :super(); //Constructor de la clase.

  @override
  _DispositivosLista createState() => _DispositivosLista(usuario); //Crea un estado mutable del Widget.

}

///Esta clase se encarga de formar un estado mutable de la clase “DispositivosLista”.
///@param _usuario identificador del usuario.
///@param _dispositivosLista lista de las cartas de los dispositivos.
///@param _dispositivosObtenidos lista con el mapeo de los dispositivos.
///@param _estado estado del servicio de obtener dispositivos.
///@param _refrescar indica si hay una pantalla de carga activa.
///@param _width obtiene el ancho de la pantalla del dispositivo.
///@param _height obtiene el alto de la pantalla del dispositivo.

class _DispositivosLista extends State<DispositivosLista> {

  final String _usuario; //Identificador del usuario.
  _DispositivosLista(this._usuario); //Constructor de la clase.

  List<Widget> _dispositivosLista; //Lista de las cartas de los dispositivos.
  Future<List> _dispositivosObtenidos; //Lista con el mapeo de los dispositivos.
  int _estado; //Estado del servicio de obtener dispositivos.
  bool _refrescar; //Indica si hay una pantalla de carga activa.

  @override

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState();
    _dispositivosLista = [];
    _estado = 0;
    _refrescar = false; //Inicializa este valor para que no haga un Navigator.pop al no tener pantalla de carga.
  }

  ///Hace una petición para conseguir un mapeo con la lista de los parámetros de
  ///los dispositivos, además actualiza el estado para saber la condición de la
  ///petición.
  ///@see owleddomo_app/cuartos/DisporitivoTabla/ServiciosDispositivo.todosDispositivo#method().
  ///@see owleddomo_app/shared/TratarError.estadoServicioLeer#method().
  ///@return un mapeo con los dispositivos.

  Future<List> _obtenerDispositivos() async {
    setState(() {
      _dispositivosObtenidos =  ServiciosDispositivo.todosDispositivo(_usuario);
    });
    _dispositivosObtenidos.then((value) => {
      _estado = tratarError.estadoServicioLeer(value.first),
    });
    return _dispositivosObtenidos;
  }

  ///Acción de navegación a la interfaz de agregar dispositivos al presionar el botón
  ///de agregar dispositivo, y al regresar actualiza la lista de dispositivos.
  ///@see owleddomo_app/shared/SubPantallaUno.dart#class().
  ///@see owleddomo_app/cuartos/DisporitivoTabla/InterfazAgregarDispositivo.dart#class().

  _alPresionarAgregarDispositivo () {
    Route route = MaterialPageRoute (builder: (context) =>
        SubPantallaUno(InterfazAgregarDispositivo(_usuario),"Añadir Dispositivo")
    ); //Especifica la ruta hacia la interfaz para agregar un dispositivo.
    Navigator.push(context, route).then((value)=>{
      setState(() {
        _estado = 5; //Al regresar a la lista, hace que se actualice.
      }),
      _obtenerDispositivos(), //Vuelve a cargar la lista luego de agregar el dispositivo.
    });
  }

  ///Acción de navegación a la interfaz de la información de un dispositivo al
  ///presionar la carta de un dispositivo, y al regresar actualiza la lista de dispositivos.
  ///@param dispositivo datos del dispositivo para pasarle a la interfaz del dispositivo.
  ///@see owleddomo_app/shared/SubPantallaUno.dart#class().
  ///@see owleddomo_app/cuartos/DisporitivoTabla/InterfazInformacionDispositivo.dart#class().

  _alPresionarCarta (Dispositivo dispositivo) {
    Route route = MaterialPageRoute (builder: (context) =>
        SubPantallaUno(InterfazInformacionDispositivo(dispositivo.relacion_id,
                                                      dispositivo.nombre,
                                                      dispositivo.url_foto,
                                                      dispositivo.fecha_modificacion,
                                                      _usuario),"Dispositivo"));
    Navigator.push(context, route).then((value)=>{
      setState(() {
        _estado = 5; //Al regresar a la lista, hace que se actualice.
      }),
      _obtenerDispositivos(), //Vuelve a cargar la lista luego de agregar dispositivo.
    });
  }

  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    ///Construye el Widget del botón agregar dispositivo.
    ///@return un AvatarGlow que contiene un botón agregar.

    Widget _botonAgregarDispositivo() {
      return AvatarGlow(
        glowColor: colores.obtenerColorTres(),
        endRadius: 90.0,
        duration: Duration(milliseconds: 2000),
        repeat: true,
        showTwoGlows: true,
        repeatPauseDuration: Duration(seconds: 2),
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                top: _height/31.68,
                left: _width/8.779,
              ),
              color: colores.obtenerColorFondo(),
              width: _height/19.8,
              height: _height/19.8,
            ),
            MaterialButton(
              onPressed: _alPresionarAgregarDispositivo,
              shape: CircleBorder(),
              child: Icon(
                Icons.add_circle,
                size: _height/8.799,
                color: colores.obtenerColorTres(),
              ),
            ),
          ],
        ),
      );
    }

    ///Construye el Widget de la carta para albergar el botón de agregar dispositivo.
    ///@return un container que fija las dimensiones de la carta del botón agregar dispositivo.

    Widget _tarjetaBotonAgregar() {
      return Container(
        height: _height/5.617,
        width: _width/2.553,
        child: _botonAgregarDispositivo(),
      );
    }

    ///Construye el Widget de la carta de los dispositivos.
    ///@param dispositivo datos del dispositivo para armar la carta.
    ///@return un Center que contiene una carta con el nombre y la imagen del dispositivo.

    Widget _botonCarta(Dispositivo dispositivo) {
      return Center(
        child: Card(
          margin: EdgeInsets.symmetric(vertical: _height/79.2),
          color: Color.fromRGBO(colores.obtenerColorCuatro().red,colores.obtenerColorCuatro().green, colores.obtenerColorCuatro().blue, 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            splashColor: colores.obtenerColorCuatro(),
            onTap: () {
              _alPresionarCarta (dispositivo);
            },
            child: CartaDispositivo(dispositivo.nombre, dispositivo.url_foto),
          ),
        ),
      );
    }

    ///Arma una lista con las cartas de los dispositivos obtenidos.
    ///@param dispositivosObtenidos Lista con un mapeo de los dispositivos.
    ///@return una lista con los Widgets de todas las cartas de los dispositivos.

    List<Widget> _armarTarjetasDispositivos(List dispositivosObtenidos)  {
      _dispositivosLista = [];
      for (var i = 0; i < dispositivosObtenidos.last.length; i++) {
        _dispositivosLista.insert(i, _botonCarta(dispositivosObtenidos.last[i]));
      }
      return _dispositivosLista;
    }

    ///Construye una fila de la lista de dispositivos.
    ///@param listaWidgets lista con todas las cartas.
    ///@param index index actual de la carta.
    ///@param rows lista con las cartas de esa fila.
    ///@param elementos el número de los elementos que contiene la fila.
    ///@return un Row con las cartas respectivas para la fila que se está armando.

    Widget _obtenerFila (List<Widget> listaWidgets, int index) {
      List<Widget> rows = []; //Lista con las cartas de esa fila.
      int elementos = 2; //El número de los elementos que contiene la fila.
      for (var indexWidget = index; indexWidget < index + elementos; indexWidget++) {
        //Completa la fila con el botón de agregar en caso de estar incompleta la fila.
        if (listaWidgets.length > indexWidget) {
          rows.add(listaWidgets[indexWidget]);
        }
        else {
          rows.add(_tarjetaBotonAgregar());
          break;
        }
      }
      return new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: rows,
      );
    }

    ///Construye una lista de filas con todas las cartas de dispositivos para armar la lista horizontal.
    ///@param listaWidgets lista con todas las cartas.
    ///@param columnas Lista con las filas de la lista.
    ///@return una lista con todas las Row que contienen las cartas de los dispositivos.

    List<Widget> _obtenerColumnas (List<Widget> listaWidgets) {
      List<Widget> columnas = []; //Lista con las filas de la lista de dispositivos.
      if(listaWidgets.length != 0) {
        for (var _indexWidget= 0; _indexWidget < listaWidgets.length; _indexWidget += 2) {
          columnas.add(_obtenerFila(listaWidgets, _indexWidget));
        }
        //Si no hay filas incompletas, agrega al inicio de la siguiente fila el botón de agregar.
        if (listaWidgets.length%2 == 0 && listaWidgets.length>0) {
          columnas.add(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _tarjetaBotonAgregar(),
                Container(
                  height: _height/5.617,
                  width: _width/2.553,
                ),
              ],
            ),
          );
        }
      }
      return columnas;
    }

    ///Pantalla en caso de no tener ningún dispositivo.
    ///@return un Center con un texto y el botón agregar dispositivo.

    Widget _pantallaSinDispositivos() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _botonAgregarDispositivo(),
            Text(
              "¡Añadamos un Dispositivo!",
              style: TextStyle(
                fontSize: _height/26.4,
                fontFamily: "Lato",
              ),
            ),
          ],
        ),
      );
    }

    ///Una ventana emergente que bloquea el resto de la interfaz.
    ///@see owleddomo_app/shared/PantallaEspera.dart#class().

    _plantillaCarga(BuildContext context) {
      Future.delayed(Duration(milliseconds: 0), () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext dialogContext) {
            return PantallaEspera();
          },
        );
      });
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
    ///para los dispositivos y los errores que se presenten.

    Widget _pantallaLogica() {
      return Container(
        child: Center(
          child: ListView(
            physics: BouncingScrollPhysics(),
            primary: false,
            addAutomaticKeepAlives: false,
            shrinkWrap: true,
            children: <Widget> [
              FutureBuilder<List>(
                future: _obtenerDispositivos(),
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    if (_refrescar) {
                      _refrescar = false;
                      Navigator.of(context).pop(null);
                    }
                    if ( _estado == 0 ) {
                      children = _obtenerColumnas(_armarTarjetasDispositivos(snapshot.data));
                    } else if(  _estado == 1) {
                      children = <Widget>[
                        _pantallaSinDispositivos(),
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
        ),
      );
    }

    return Container(
      child: _pantallaLogica(),
    );
  }
}
