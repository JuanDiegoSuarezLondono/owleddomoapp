import 'package:flutter/material.dart';
import 'package:owleddomoapp/cuartos/CuartoTabla/InterfazInformacionCuarto.dart';
import 'package:owleddomoapp/cuartos/CuartoTabla/InterfazAgregarCuarto.dart';
import 'package:owleddomoapp/cuartos/CuartoTabla/ServiciosCuarto.dart';
import 'package:owleddomoapp/cuartos/CuartoTabla/CartaCuarto.dart';
import 'package:owleddomoapp/cuartos/CuartoTabla/Cuarto.dart';
import 'package:owleddomoapp/shared/PantallaEspera.dart';
import 'package:owleddomoapp/shared/SubPantallaUno.dart';
import 'package:owleddomoapp/shared/PantallaSinRed.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/shared/TratarError.dart';
import 'package:avatar_glow/avatar_glow.dart';

final PaletaColores colores = new PaletaColores(); //Colores predeterminados.
final TratarError tratarError = new TratarError(); //Respuestas predeterminadas a las API.

///Esta clase se encarga de manejar la pantalla del despliegue de la lista de los
///cuartos y su lógica.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param usuario identificador del usuario.
///@see owleddomo_app/cuartos/CuartosMain.dart#class().
///@return Un Widget Container con una lista de los cuartos y su lógica en
///caso de un error.

class CuartosLista extends StatefulWidget {

  final String usuario; //Identificador del usuario.
  CuartosLista(this.usuario) :super(); //Constructor de la clase.

  @override
  _CuartosLista createState() => _CuartosLista(usuario); //Crea un estado mutable del Widget.

}

///Esta clase se encarga de formar un estado mutable de la clase “CuartosLista”.
///@param _usuario identificador del usuario.
///@param _cuartosLista lista de las cartas de los cuartos.
///@param _cuartosObtenidos lista con el mapeo de los cuartos.
///@param _estado estado del servicio de obtener cuartos.
///@param _refrescar indica si hay una pantalla de carga activa.
///@param _width obtiene el ancho de la pantalla del dispositivo.
///@param _height obtiene el alto de la pantalla del dispositivo.

class _CuartosLista extends State<CuartosLista> {

  final String _usuario; //Identificador del usuario.
  _CuartosLista(this._usuario); //Constructor de la clase.

  List<Widget> _cuartosLista; //Lista de las cartas de los cuartos.
  Future<List> _cuartosObtenidos; //Lista con el mapeo de los cuartos.
  int _estado; //Estado del servicio de obtener cuartos.
  bool _refrescar; //Endica si hay una pantalla de carga activa.

  @override

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState();
    _cuartosLista = [];
    _estado = 0;
    _refrescar = false; //Inicializa este valor para que no haga un Navigator.pop al no tener pantalla de carga.
  }

  ///Hace una petición para conseguir un mapeo con la lista de los parámetros de
  ///los cuartos, además actualiza el estado para saber la condición de la petición.
  ///@see owleddomo_app/cuartos/CuartoTabla/ServiciosCuarto.todosCuartos#method().
  ///@see owleddomo_app/shared/TratarError.estadoServicioLeer#method().
  ///@return Un mapeo con los cuartos.

  Future<List> _obtenerCuartos()  async {
    setState(() {
      _cuartosObtenidos =  ServiciosCuarto.todosCuartos(_usuario);
    });
    _cuartosObtenidos.then((value) => {
      _estado = tratarError.estadoServicioLeer(value.first),
    });
    return _cuartosObtenidos;
  }

  ///Acción de navegación a la interfaz de agregar cuartos al presionar el botón
  ///de agregar cuarto, y al regresar actualiza la lista de cuartos.
  ///@see owleddomo_app/shared/SubPantallaUno.dart#class().
  ///@see owleddomo_app/cuartos/CuartoTabla/InterfazAgregarCuarto.dart#class().

  _alPresionarAgregarCuarto () {
    Route route = MaterialPageRoute (builder: (context) =>
        SubPantallaUno(InterfazAgregarCuarto(_usuario),"Creando cuarto")
    ); //Especifica la ruta hacia la interfaz para agregar un cuarto.
    Navigator.push(context, route).then((value)=>{
      setState(() {
        _estado = 5; //Al regresar a la lista, hace que se actualice.
      }),
      _obtenerCuartos(), //Vuelve a cargar la lista luego de agregar el cuarto.
    });
  }

  ///Acción de navegación a la interfaz de la información de un cuarto al
  ///presionar la carta de un cuarto, y al regresar actualiza la lista de cuartos.
  ///@param cuarto datos del cuarto para pasarle a la interfaz del cuarto.
  ///@see owleddomo_app/shared/SubPantallaUno.dart#class().
  ///@see owleddomo_app/cuartos/CuartoTabla/InterfazInformacionCuarto.dart#class().

  _alPresionarCarta (Cuarto cuarto) {
    Route route = MaterialPageRoute (builder: (context) =>
        SubPantallaUno(InterfazInformacionCuarto(cuarto.cuarto_id,
                                                 cuarto.nombre,
                                                 cuarto.pathImagen,
                                                 cuarto.descripcion,_usuario),"Cuarto"));
    Navigator.push(context, route).then((value)=>{
      setState(() {
        _estado = 5; //Al regresar a la lista, hace que se actualice.
      }),
      _obtenerCuartos(), //Vuelve a cargar la lista luego de agregar el cuarto.
    });
  }

  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    ///Construye el Widget del botón agregar cuarto.
    ///@return un AvatarGlow que contiene un botón agregar.

    Widget _botonAgregarCuarto() {
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
              onPressed: _alPresionarAgregarCuarto,
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

    ///Construye el Widget de la carta para albergar el botón de agregar cuarto.
    ///@return un container que fija las dimensiones de la carta del botón agregar carta.

    Widget _tarjetaBotonAgregar() {
      return Container(
        height: _height/5.617,
        width: _width/2.553,
        child: _botonAgregarCuarto(),
      );
    }

    ///Construye el Widget de la carta de los cuartos.
    ///@param _cuarto datos del cuarto para armar la carta.
    ///@return un Center que contiene una carta con la imagen, el nombre y el numero
    ///de dispositivos que tiene el cuarto.

    Widget _botonCarta(Cuarto _cuarto) {
      return Center(
        child: Card(
          margin: EdgeInsets.symmetric(vertical: _height/79.2),
          color: colores.obtenerColorDos(),
          child: InkWell(
            splashColor: colores.obtenerColorCuatro(),
            onTap: () {
              _alPresionarCarta (_cuarto);
            },
            child: CartaCuarto(_cuarto.cuarto_id, _cuarto.nombre, _cuarto.pathImagen),
          ),
        ),
      );
    }

    ///Arma una lista con las cartas de los cuartos obtenidos.
    ///@param cuartosObtenidos Lista con un mapeo de los cuartos.
    ///@return una lista con los Widgets de todas las cartas de los cuartas.

    List<Widget> _armarTarjetasCuartos(List cuartosObtenidos)  {
      _cuartosLista = [];
      for (var i = 0; i < cuartosObtenidos.last.length; i++) {
        _cuartosLista.insert(i, _botonCarta(cuartosObtenidos.last[i]));
      }
      return _cuartosLista;
    }

    ///Construye una fila de la lista de cuartos.
    ///@param listaWidgets lista con todas las cartas.
    ///@param index index actual de la carta.
    ///@param rows lista con las cartas de esa fila.
    ///@param elementos el número de los elementos que contiene la fila.
    ///@return un Row con las cartas respectivas para la fila que se está armando.

    Widget _obtenerFila (List<Widget> listaWidgets, _index) {
      List<Widget> rows = []; //Lista con las cartas de esa fila.
      int elementos = 2; //El número de los elementos que contiene la fila.
      for (var _indexWidget = _index; _indexWidget < _index + elementos; _indexWidget++) {
        //Completa la fila con el botón de agregar en caso de estar incompleta la fila.
        if (listaWidgets.length > _indexWidget) {
          rows.add(listaWidgets[_indexWidget]);
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

    ///Construye una lista de filas con todas las cartas de cuartos para armar la lista horizontal.
    ///@param listaWidgets lista con todas las cartas.
    ///@param columnas Lista con las filas de la lista.
    ///@return una lista con todas las Row que contienen las cartas de los cuartos.

    List<Widget> _obtenerColumnas (List<Widget> listaWidgets) {
      List<Widget> columnas = []; //Lista con las filas de la lista de cuartos.
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

    ///Pantalla en caso de no tener ningún cuarto.
    ///@return un Center con un texto y el botón agregar cuarto.

    Widget _pantallaSinCuartos() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _botonAgregarCuarto(),
            Text(
              "¡Añadamos un Cuarto!",
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
      if (!_refrescar) {
        _plantillaCarga(context);
      }
      _refrescar = true; //Indica que se ha desplegado una pantalla de carga.
      return  Text("");
    }

    ///Se encarga de desplegar todas las posibles interfaces dependiendo de si
    ///hay datos para la lista o si hay un error de algún tipo.
    ///@return un Widget Container que posee un constructor futuro de una lista
    ///para los cuartos y los errores que se presenten.

    Widget _pantallaLogica() {
      return  Container(
        child: Center(
          child: ListView(
            physics: BouncingScrollPhysics(),
            primary: false,
            addAutomaticKeepAlives: false,
            shrinkWrap: true,
            children: <Widget> [
              FutureBuilder<List>(
                future: _obtenerCuartos(),
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    if (_refrescar) {
                      _refrescar = false;
                      Navigator.of(context).pop(null);
                    }
                    if ( _estado == 0 ) {
                      children = _obtenerColumnas(_armarTarjetasCuartos(snapshot.data));
                    } else if(  _estado == 1) {
                      children = <Widget>[
                        _pantallaSinCuartos(),
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
