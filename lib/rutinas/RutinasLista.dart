import 'package:flutter/material.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:owleddomoapp/rutinas/InterfazAgregarRutina.dart';
import 'package:owleddomoapp/rutinas/ServiciosRutina.dart';
import 'package:owleddomoapp/rutinas/CartaRutina.dart';
import 'package:owleddomoapp/rutinas/Rutina.dart';
import 'package:owleddomoapp/shared/PantallaEspera.dart';
import 'package:owleddomoapp/shared/SubPantallaUno.dart';
import 'package:owleddomoapp/shared/PantallaSinRed.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/shared/TratarError.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:date_format/date_format.dart';

///Esta clase se encarga de manejar la pantalla del despliegue de la lista de las
///rutinas y su lógica.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param usuario identificador del usuario.
///@see owleddomo_app/rutinas/RutinasMain.dart#class().
///@return Un Widget Container con una lista de las rutinas y su lógica en
///caso de un error.

class RutinasLista extends StatefulWidget {

  final Persona usuario; //Identificador del usuario.
  RutinasLista(this.usuario) :super(); //Constructor de la clase.

  @override
  _RutinasLista createState() => _RutinasLista(usuario); //Crea un estado mutable del Widget.

}

///Esta clase se encarga de formar un estado mutable de la clase “RutinasLista”.
///@param _usuario identificador del usuario.
///@param _rutinasListaWidget lista de los Widgets de las rutinas de los dispositivos.
///@param _rutinasObtenidas lista con el mapeo de las rutinas.
///@param _rutinasLista lista de las rutinas de los dispositivos.
///@param _numeroRutinas indica el numero de rutinas actuales.
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

class _RutinasLista extends State<RutinasLista> {

  final Persona _usuario; //Identificador del usuario.
  _RutinasLista(this._usuario); //Constructor de la clase.

  List<Widget> _rutinasListaWidget; //Lista de los Widgets de las rutinas de los dispositivos.
  Future<List> _rutinasObtenidas; //Lista con el mapeo de las rutinas.
  List<Rutina> _rutinasLista; //Lista de las rutinas de los dispositivos.
  int _numeroRutinas; //Indica el numero de rutinas actuales.

  int _estado; //Estado del servicio de obtener rutinas.
  bool _refrescar; //Indica si hay una pantalla de carga activa.

  List<List<bool>> _dias;  //Lista con las listas de estados para los siete dias de la semana para cada rutina.
  bool _habilitarDias; //Indica que ya se han inicializado los días.

  String _horas; //Hora seleccionada.
  String _minutos; //Minuto seleccionado.
  List<String> _tiempo; //Horas y minutos seleccionados para cada rutina.
  List<TimeOfDay> _tiempoSeleccionado; //Controlador del tiempo actual del reloj para cada rutina.
  List<TextEditingController> _controladorReloj; //Controlador del texto del reloj para cada rutina.
  bool _actualizarTiempo; //Indica si hay que actualizar el tiempo de las tarjetas.

  @override

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState();
    _rutinasListaWidget = [];
    _rutinasLista = [];
    _numeroRutinas = 1;
    _estado = 0;
    _refrescar = false; //Inicializa este valor para que no haga un Navigator.pop al no tener pantalla de carga.
    _dias = [];
    _habilitarDias = true;
    _horas = "00";
    _minutos = "00";
    _tiempo = [];
    _tiempoSeleccionado = [];
    _controladorReloj = [];
    _actualizarTiempo = false;
    _rutinasObtenidas = _obtenerRutinas();
  }

  ///Actualiza la rutina o genera un error en caso de cualquier eventualidad.
  ///@param rutina parametros de la rutina a actualizar.
  ///@param tiempo nuevo tiempo de la rutina a actualizar.
  ///@see owleddomo_app/rutinas/ServiciosRutina.actualizarRutina#method().
  ///@see owleddomo_app/shared/TratarError.estadoServicioActualizar#method().
  ///@return no retorna nada en caso de no obtener una validación positiva de los campos.
  _actualizarRutina(Rutina rutina, String tiempo) async {
    ServiciosRutina.actualizarRutina(_usuario.persona_id, rutina.rutina_id, rutina.persona_producto_id,
                                     rutina.relacion_dispositivo,rutina.dias, tiempo,
                                     rutina.nuevo_valor)
        .then((result) {
          TratarError(_usuario).estadoSnackbar(result, context).first.toString();
          if ( result.first.toString() == "200" && _actualizarTiempo == true) {
            _actualizarTiempo = false;
          };
        });

  }

  ///Hace una petición para conseguir un mapeo con la lista de los parámetros
  ///de las rutinas.
  ///@see owleddomo_app/rutinas/ServiciosRutina.todasRutinas#method().
  ///@return un mapeo con las rutinas.

  Future<List> _obtenerRutinas()  async {
      _rutinasObtenidas =  ServiciosRutina.todasRutinas(_usuario.persona_id);
      _rutinasObtenidas.then((value) {
        if (mounted) {
          setState(() {
            _numeroRutinas = 0;
            _estado = TratarError(_usuario).estadoServicioLeer(value);
            if( value.first.toString() == "200" && value.last.toString() != "200" ) {
              _numeroRutinas = value.last.length;
              _tiempo = [];
              _tiempoSeleccionado = [];
              _controladorReloj = [];
              for(int i=0 ; i<value.last.length ; i++) {
                _tiempo.add(value.last[i].tiempo.substring(0,2) + ':' + value.last[i].tiempo.substring(3,5));
                _tiempoSeleccionado.add(TimeOfDay(hour: int.parse(value.last[i].tiempo.substring(0,2)),
                    minute: int.parse(value.last[i].tiempo.substring(3,5))));
                _controladorReloj.add(TextEditingController());
                _controladorReloj[i].text = formatDate(
                    DateTime(2019, 08, 1, int.parse(value.last[i].tiempo.substring(0,2)),
                        int.parse(value.last[i].tiempo.substring(3,5))),
                    [hh, ':', nn, " ", am]).toString();
                if(_habilitarDias) {
                  _rutinasLista = [];
                  _rutinasLista.addAll(value.last);
                  _dias.add([
                    _rutinasLista[i].dias.substring(0,1) == '0' ? false : true,
                    _rutinasLista[i].dias.substring(1,2) == '0' ? false : true,
                    _rutinasLista[i].dias.substring(2,3) == '0' ? false : true,
                    _rutinasLista[i].dias.substring(3,4) == '0' ? false : true,
                    _rutinasLista[i].dias.substring(4,5) == '0' ? false : true,
                    _rutinasLista[i].dias.substring(5,6) == '0' ? false : true,
                    _rutinasLista[i].dias.substring(6) == '0' ? false : true,
                  ]);
                };
              };
            } else if (value.first.toString() == "200") {
              _estado = 1;
            }
          });
        }
      });
      return await _rutinasObtenidas;
  }

  ///Despliega una interfaz para poder seleccionar una hora y minuto del dia.
  ///@param seleccionador variable que almacena el valor de la pantalla desplegada
  ///en el showTimePicker.
  ///@param rutina parametros de la rutina a la cual se actualiza el tiempo.
  ///@param index posicion de las variables en cada variable tipo lista
  ///que almacenan los controladores correspondientes a la carta de la rutina.

  Future<Null> _seleccionarTiempo(BuildContext context, Rutina rutina, int index) async {
    final TimeOfDay seleccionador = await showTimePicker(
      usuario: _usuario,
      context: context,
      initialTime: _tiempoSeleccionado[index],
    );
    if (seleccionador != null) {
      _actualizarTiempo = true;
      _tiempoSeleccionado[index] = seleccionador;
      _horas = _tiempoSeleccionado[index].hour.toString();
      _minutos = _tiempoSeleccionado[index].minute.toString();
      _tiempo[index] = _horas + ':' + _minutos;
      _controladorReloj[index].text = _tiempo[index];
      _controladorReloj[index].text = formatDate(
          DateTime(2019, 08, 1, _tiempoSeleccionado[index].hour,
              _tiempoSeleccionado[index].minute),
          [hh, ':', nn, " ", am]).toString();
      _actualizarRutina(rutina, _tiempo[index]);
    }
  }

  ///Acción de navegación a la interfaz de agregar rutina al presionar el botón
  ///de agregar rutina, y al regresar actualiza la lista de rutinas.
  ///@see owleddomo_app/shared/SubPantallaUno.dart#class().
  ///@see owleddomo_app/rutinas/InterfazAgregarRutina.dart#class().

  _alPresionarAgregarRutina () {
    Route route = MaterialPageRoute (builder: (context) =>
        SubPantallaUno(InterfazAgregarRutina(_usuario,_numeroRutinas+1),"Creando rutina", _usuario)
    ); //Especifica la ruta hacia la interfaz para agregar una rutina.
    Navigator.push(context, route).then((valorUno)=>{
      _dias.clear(),
      _habilitarDias = true,
      if(mounted) {
        setState(() {
          _estado = 8; //Al regresar a la lista, hace que se actualice.
          _obtenerRutinas().then((valorDos) => _habilitarDias=false); //Vuelve a cargar la lista luego de agregar la rutina.
        }),
      }
    });
  }

  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    ///Construye el Widget del botón agregar rutina.
    ///@return Un Container con un AvatarGlow de botón agregar.

    Widget _botonAgregarRutina() {
      return Container (
        margin: EdgeInsets.only(top: _height/79.2),
        child: MaterialButton(
          color: PaletaColores(_usuario).obtenerSecundario().withOpacity(0.3),
          onPressed: _alPresionarAgregarRutina,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
              side: BorderSide(
                color: PaletaColores(_usuario).obtenerSecundario().withOpacity(0.5),
              )
          ),
          child: Container(
            alignment: Alignment.center,
            height: _height/15.84,
            width: _width/1.333333333333333,
            child: AvatarGlow(
              glowColor: PaletaColores(_usuario).obtenerTerciario(),
              endRadius: _width/12,
              duration: Duration(milliseconds: 2000),
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: Duration(seconds: 2),
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      left: _height/79.2,
                      top: _height/79.2,
                    ),
                    color: PaletaColores(_usuario).obtenerTerciario(),
                    width: _height/39.6,
                    height: _height/39.6,
                  ),
                  Icon(
                      Icons.add_circle,
                      size: _height/19.8,
                      color: PaletaColores(_usuario).obtenerColorInactivo(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    ///Construye el Widget que contiene los elementos de la primera fila de los botones
    ///de los dias, es decir, los botones de "D" (domingo), "L" (lunes), "M" (martes) y "Mi" (miercoles).
    ///@param rutina parametros de la rutina a la cual se actualiza.
    ///@param index posicion de las variables en cada variable tipo lista.
    ///@return Un Widget de Container que posee un Row.

    Widget _filaUnoDias(Rutina rutina, int index) {
      return Container(
        width: _width/1.44,
        margin: EdgeInsets.only(top: _height/39.6),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget> [
          InkWell(
            onTap: () {
              if(mounted){
                setState(() {
                  _dias[index][0] = !_dias[index][0];
                });
              }
              _rutinasLista[index].dias = '${_dias[index][0] ? "1":"0"}${_rutinasLista[index].dias.substring(1)}';
              _actualizarRutina(_rutinasLista[index], _tiempo[index]);
            },
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: _dias[index][0]
                                        ? PaletaColores(_usuario).obtenerCuaternario()
                                        : PaletaColores(_usuario).obtenerColorInactivo()),
              child: Padding(
                padding: EdgeInsets.all(_height/79.2),
                child: Center(
                  heightFactor: 1,
                  widthFactor: 1.6,
                  child:Text(
                    "D",
                    style: TextStyle(
                      fontSize: _height/39.6,
                      color: PaletaColores(_usuario).obtenerContrasteInactivo(),
                      fontWeight: FontWeight.bold,
                      fontFamily: "Lato",
                    ),
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if(mounted) {
                setState(() {
                  _dias[index][1] = !_dias[index][1];
                });
              }
              _rutinasLista[index].dias = '${_rutinasLista[index].dias.substring(0,1)}${_dias[index][1] ? "1":"0"}'
                                          '${_rutinasLista[index].dias.substring(2)}';
              _actualizarRutina(_rutinasLista[index], _tiempo[index]);
            },
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: _dias[index][1]
                                        ? PaletaColores(_usuario).obtenerCuaternario()
                                        : PaletaColores(_usuario).obtenerColorInactivo()),
              child: Padding(
                padding: EdgeInsets.all(_height/79.2),
                child: Center(
                  heightFactor: 1,
                  widthFactor: 2.5,
                  child:Text(
                    "L",
                    style: TextStyle(
                      fontSize: _height/39.6,
                      color: PaletaColores(_usuario).obtenerContrasteInactivo(),
                      fontWeight: FontWeight.bold,
                      fontFamily: "Lato",
                    ),
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if(mounted) {
                setState(() {
                  _dias[index][2] = !_dias[index][2];
                });
              }
              _rutinasLista[index].dias = '${_rutinasLista[index].dias.substring(0,2)}'
                                          '${_dias[index][2] ? "1":"0"}'
                                          '${_rutinasLista[index].dias.substring(3)}';
              _actualizarRutina(_rutinasLista[index], _tiempo[index]);
            },
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: _dias[index][2]
                                        ? PaletaColores(_usuario).obtenerCuaternario()
                                        : PaletaColores(_usuario).obtenerColorInactivo()),
              child: Padding(
                padding: EdgeInsets.all(_height/79.2),
                child: Center(
                  heightFactor: 1,
                  widthFactor: 1.4,
                  child:Text(
                    "M",
                    style: TextStyle(
                      fontSize: _height/39.6,
                      color: PaletaColores(_usuario).obtenerContrasteInactivo(),
                      fontWeight: FontWeight.bold,
                      fontFamily: "Lato",
                    ),
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if(mounted){
                setState(() {
                  _dias[index][3] = !_dias[index][3];
                });
              }
              _rutinasLista[index].dias = '${_rutinasLista[index].dias.substring(0,3)}'
                                          '${_dias[index][3] ? "1":"0"}'
                                          '${_rutinasLista[index].dias.substring(4)}';
              _actualizarRutina(_rutinasLista[index], _tiempo[index]);
            },
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: _dias[index][3]
                                        ? PaletaColores(_usuario).obtenerCuaternario()
                                        : PaletaColores(_usuario).obtenerColorInactivo()),
              child: Padding(
                padding: EdgeInsets.all(_height/79.2),
                child: Center(
                  heightFactor: 1,
                  widthFactor: 1,
                  child:Text(
                    "Mi",
                    style: TextStyle(
                      fontSize: _height/39.6,
                      color: PaletaColores(_usuario).obtenerContrasteInactivo(),
                      fontWeight: FontWeight.bold,
                      fontFamily: "Lato",
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      );
    }

    ///Construye el Widget que contiene los elementos de la segunda fila de los botones
    ///de los dias, es decir, los botones de "J" (jueves), "V" (viernes) y "S" (sabado).
    ///@param rutina parametros de la rutina a la cual se actualiza.
    ///@param index posicion de las variables en cada variable tipo lista.
    ///@return Un Widget de Container que posee un Row.

    Widget _filaDosDias(Rutina rutina, int index) {
      return Container(
        width: _width/2,
        margin: EdgeInsets.only(top: _height/79.2),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget> [
          InkWell(
            onTap: () {
              if(mounted) {
                setState(() {
                  _dias[index][4] = !_dias[index][4];
                });
              }
              _rutinasLista[index].dias = '${_rutinasLista[index].dias.substring(0,4)}'
                                          '${_dias[index][4] ? "1":"0"}'
                                          '${_rutinasLista[index].dias.substring(5)}';
              _actualizarRutina(_rutinasLista[index], _tiempo[index]);
            },
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: _dias[index][4]
                                        ? PaletaColores(_usuario).obtenerCuaternario()
                                        : PaletaColores(_usuario).obtenerColorInactivo()),
              child: Padding(
                padding: EdgeInsets.all(_height/79.2),
                child: Center(
                  heightFactor: 1,
                  widthFactor: 2.6,
                  child:Text(
                    "J",
                    style: TextStyle(
                      fontSize: _height/39.6,
                      color: PaletaColores(_usuario).obtenerContrasteInactivo(),
                      fontWeight: FontWeight.bold,
                      fontFamily: "Lato",
                    ),
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if(mounted) {
                setState(() {
                  _dias[index][5] = !_dias[index][5];
                });
              }
              _rutinasLista[index].dias = '${_rutinasLista[index].dias.substring(0,5)}'
                                          '${_dias[index][5] ? "1":"0"}'
                                          '${_rutinasLista[index].dias.substring(6)}';
              _actualizarRutina(_rutinasLista[index], _tiempo[index]);
            },
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: _dias[index][5]
                                        ? PaletaColores(_usuario).obtenerCuaternario()
                                        : PaletaColores(_usuario).obtenerColorInactivo()),
              child: Padding(
                padding: EdgeInsets.all(_height/79.2),
                child: Center(
                  heightFactor: 1,
                  widthFactor: 2,
                  child:Text(
                    "V",
                    style: TextStyle(
                      fontSize: _height/39.6,
                      color: PaletaColores(_usuario).obtenerContrasteInactivo(),
                      fontWeight: FontWeight.bold,
                      fontFamily: "Lato",
                    ),
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if(mounted) {
                setState(() {
                  _dias[index][6] = !_dias[index][6];
                });
              }
              _rutinasLista[index].dias = '${_rutinasLista[index].dias.substring(0,6)}'
                                          '${_dias[index][6] ? "1":"0"}';
              _actualizarRutina(_rutinasLista[index], _tiempo[index]);
            },
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: _dias[index][6]
                                        ? PaletaColores(_usuario).obtenerCuaternario()
                                        : PaletaColores(_usuario).obtenerColorInactivo()),
              child: Padding(
                padding: EdgeInsets.all(_height/79.2),
                child: Center(
                  heightFactor: 1,
                  widthFactor: 2.2,
                  child:Text(
                    "S",
                    style: TextStyle(
                      fontSize: _height/39.6,
                      color: PaletaColores(_usuario).obtenerContrasteInactivo(),
                      fontWeight: FontWeight.bold,
                      fontFamily: "Lato",
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      );
    }

    ///Construye el Widget que arma los botones para cambiar las acciones del dispositivo.
    ///@param indexVariable posición de la rutina en la lista de rutinas.
    ///@param indexAccion posición de la acción en la lista de las acciones en una rutina.
    ///@return Un Widget que contiene un InkWell.

    Widget _botonAccion(int indexVariable, int indexAccion){
     List<String> cara;
     String nuevoValor = "";
      return
        InkWell(
        onTap: () {
          if(mounted) {
            setState(() {
              cara = [];
              cara.addAll(_rutinasLista[indexVariable].nuevo_valor.characters);
              cara[indexAccion] = cara[indexAccion] == "0" ? '1' : '0' ;
              for(int i=0 ; i<cara.length ; i++) {
                nuevoValor = nuevoValor+cara[i];
              }
              _rutinasLista[indexVariable].nuevo_valor = nuevoValor;
            });
          }
          _actualizarRutina(_rutinasLista[indexVariable], _tiempo[indexVariable]);
        },
        child: Container(
          width: 20,
          height: 20,
          margin: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _rutinasLista[indexVariable].nuevo_valor[indexAccion] == "1" ? PaletaColores(_usuario).obtenerCuaternario()
                : PaletaColores(_usuario).obtenerColorInactivo(),
            boxShadow: [
              BoxShadow(
                color: _rutinasLista[indexVariable].nuevo_valor[indexAccion] == "1" ? PaletaColores(_usuario).obtenerCuaternario()
                    : PaletaColores(_usuario).obtenerColorInactivo(),
                spreadRadius: _rutinasLista[indexVariable].nuevo_valor[indexAccion] == "1" ? 5 : 0,
                blurRadius: _rutinasLista[indexVariable].nuevo_valor[indexAccion] == "1" ? 7 : 0,
              ),
            ],
          ),
        ),
      );
    }

    ///Construye el Widget que contiene las acciones de la variable de la rutina.
    ///@param rutina parametros de la rutina.
    ///@param index posicion de las variables en cada variable tipo lista.
    ///@return Un Widget de Container que posee un Row.

    Widget _filaTresAcciones(Rutina rutina, int index) {
      List<Widget> acciones = [];
      for(int i= 0; i < rutina.nuevo_valor.length; i++) {
        acciones.add(_botonAccion(index,i));
      }
      return Container(
        width: _width,
        height: _height/15.84,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: _height/26.4),
        child: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: <Widget> [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: acciones,
            )
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
            return PantallaEspera(_usuario);
          },
        );
      });
    }

    ///Construye el Widget que despliega una ventana emergente para confirmar el
    ///borrar la rutina.

    _confirmarBorrar (Rutina rutina) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (buildcontext) {
            return AlertDialog(
              backgroundColor: PaletaColores(_usuario).obtenerPrimario(),
              title: Text(
                "¿Está seguro?",
                style: TextStyle(
                  color: PaletaColores(_usuario).obtenerLetraContrastePrimario(),
                  fontFamily: "Lato",
                ),
              ),
              content: Text(
                "Al eliminar esta rutina se perderá la configuración de la misma.",
                style: TextStyle(
                  color: PaletaColores(_usuario).obtenerLetraContrastePrimario(),
                  fontFamily: "Lato",
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: PaletaColores(_usuario).obtenerTerciario(),
                  ),
                  child:Container (
                    width: _width/6.428571428571429,
                    child: Row (
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        Icon(
                          Icons.warning_rounded,
                          color: PaletaColores(_usuario).obtenerContrasteRiesgo(),
                          size: _height/26.4,
                        ),
                        Text(
                          "OK",
                          style: TextStyle(
                            color: PaletaColores(_usuario).obtenerContrasteRiesgo(),
                            fontFamily: "Lato",
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    _plantillaCarga(context);
                    ServiciosRutina.borrarRutina(_usuario.persona_id, rutina.rutina_id, rutina.persona_producto_id,
                                                 rutina.relacion_dispositivo)
                        .then((result) {
                          if(mounted) {
                            setState(() {
                              Navigator.of(context).pop(false);
                              _obtenerRutinas();
                              _estado = 8;
                            });
                          }

                          TratarError(_usuario).estadoSnackbar(result, context);
                        });
                    },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: PaletaColores(_usuario).obtenerColorRiesgo(),
                  ),
                  child:Container (
                    width: _width/6.428571428571429,
                    child: Row (
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        Text(
                          "Cancelar",
                          style: TextStyle(
                            color: PaletaColores(_usuario).obtenerContrasteRiesgo(),
                          ),
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

    ///Construye el Widget que maneja el botón para borrar la rutina.
    ///@return un Widget de Container con un ConstrainedBox que actúa como
    ///botón.

    Widget _botonBorrar (Rutina rutina) {
      return Container(
        margin: EdgeInsets.only(bottom: _height/79.2),
        child:ConstrainedBox(
          constraints: BoxConstraints.tightFor(height: _height/17.6),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: PaletaColores(_usuario).obtenerColorRiesgo(),
              shape: CircleBorder(),
            ),
            onPressed: () {
              _confirmarBorrar(rutina);
            },
            child: Icon(
              Icons.delete_rounded,
              color: PaletaColores(_usuario).obtenerContrasteRiesgo(),
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

    Widget _botonCarta(Rutina rutina, int index) {
      return Card(
        margin: EdgeInsets.only(top: _height/79.2),
        color: PaletaColores(_usuario).obtenerSecundario(),
        child: Container(
          width: _width/1.2,
          child: ExpansionCard(
            usuario: _usuario,
            trailing: Container(
              width: 0,
              margin: EdgeInsets.all(0),
            ),
            margin: EdgeInsets.all(0),
            title: CartaRutina(_usuario, rutina.rutina_id, rutina.nombre_dispositivo,
                               rutina.persona_producto_id, rutina.nombre,
                               rutina.activo, rutina.relacion_dispositivo,
                               rutina.tiempo.substring(0,5)),
            children: <Widget>[
              _filaUnoDias(rutina, index),
              _filaDosDias(rutina, index),
              _filaTresAcciones(rutina, index),
              InkWell(
                onTap: () {
                  _seleccionarTiempo(context, rutina, index);
                },
                child: Container(
                  width: _width/1.2,
                  height: _height/7.2,
                  alignment: Alignment.center,
                  child: TextFormField(
                    style: TextStyle(
                      fontSize: _height/15.84,
                      color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
                    ),
                    textAlign: TextAlign.center,
                    enabled: false,
                    keyboardType: TextInputType.text,
                    controller: _controladorReloj[index],
                    decoration: InputDecoration(
                        disabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                        // labelText: 'Time',
                        contentPadding: EdgeInsets.all(_width/72)),
                  ),
                ),
              ),
              Divider(
                color: PaletaColores(_usuario).obtenerColorInactivo(),
                height: _height/39.6,
                thickness: 1,
                indent: _width/24,
                endIndent: _width/24,
              ),
              _botonBorrar(rutina),
            ],
          ),
        ),
      );
    }

    ///Arma una lista con las cartas de las rutinas obtenidos.
    ///@param rutinasObtenidas Lista con un mapeo de las rutinas.
    ///@return Una lista con los Widgets de todas las cartas de las rutinas.

    List<Widget> _armarTarjetaRutina(List rutinasObtenidas) {
      _rutinasListaWidget = [];
      for (var i = 0; i < rutinasObtenidas.last.length; i++) {
        _rutinasListaWidget.insert(i, _botonCarta(rutinasObtenidas.last[i], i));
      }
      return _rutinasListaWidget;
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
      columnas.add(_botonAgregarRutina());
      return columnas;
    }

    ///Pantalla en caso de no tener ningúna rutina.
    ///@return un Center con un texto y el botón agregar rutinas.

    Widget _pantallaSinRutinas() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _botonAgregarRutina(),
            Text(
              "¡Progama tus rutinas!",
              style: TextStyle(
                fontSize: _height/26.4,
                fontFamily: "Lato",
                color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
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
              future: _rutinasObtenidas,
              builder: (context, AsyncSnapshot<List> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  if (_refrescar) {
                    _refrescar = false;
                    Navigator.of(context).pop(null);
                  }
                  if ( _estado == 0 ) {
                      children = _obtenerFilas(_armarTarjetaRutina(snapshot.data));
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
                              Icons.cloud_off_rounded,
                              size: _height/7.92,
                              color: PaletaColores(_usuario).obtenerCuaternario(),
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
                      Container(
                        height: _height/1.36551724137931,
                        child: PantallaCargaSinRed(),
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

    return SingleChildScrollView(
      child: Container(
        child: _pantallaLogica(),
      ),
    );
  }
}