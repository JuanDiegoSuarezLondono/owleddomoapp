import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/Variable/ServiciosVariable.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/ServiciosDispositivo.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/Variable/Variable.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/Dispositivo.dart';
import 'package:owleddomoapp/rutinas/ServiciosRutina.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/shared/TratarError.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:date_format/date_format.dart';

final PaletaColores colores = new PaletaColores(); //Colores predeterminados.
final TratarError tratarError = new TratarError(); //Respuestas predeterminadas a las API.

///Esta clase se encarga de manejar la pantalla del formulario para agregar una rutina.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param usuario identificador del usuario.
///@param relacionDispositivo identificador de la rutina en el dispositivo.
///@see owleddomo_app/rutinas/RutinasLista.dart#class().
///@return Un Widget ListView con un formulario.

class InterfazAgregarRutina extends StatefulWidget {

  final String usuario; //Identificador del usuario.
  final int relacionDispositivo; //Identificador de la rutina en el dispositivo.
  InterfazAgregarRutina(this.usuario, this.relacionDispositivo); //Constructor de la clase.

  @override
  State<StatefulWidget> createState() {
    return _InterfazAgregarRutina(usuario, relacionDispositivo); //Crea un estado mutable del Widget.
  }

}

///Esta clase se encarga de formar un estado mutable de la clase “InterfazAgregarRutina”.
///@param _formKey Llave identificadora del formulario.
///@param _usuario identificador del usuario.
///@param _relacionDispositivo identificador de la rutina en el dispositivo.
///@param _nombre controlador del campo de texto para el nombre.
///@param _activar controlador del bool encargado de activar o desactivar el switch.
///@param _dispositivosObtenidos lista de dispositivos obtenidos.
///@param _dispositivosLista lista de elementos en el dropdown de dispositivos.
///@param _dispositivoSeleccionado dispositivo seleccionado en el dropdown de dispositivos.
///@param _iconoDispositivo controlador del icono del dropdown de dispositivos.
///@param _dispositivoColorDrowDown controlador del color de los elementos del dropdown de dispositivos.
///@param _variablesObtenidas lista de variables obtenidas.
///@param _listaVariables lista de variables obtenidas del dispositivos seleccionado.
///@param _activarVariable lista que indica la acción a tomar para cada variable.
///@param _estado estado del servicio de obtener variables.
///@param _dias lista de estados para los siete dias de la semana.
///@param _horas hora seleccionada.
///@param _minutos minuto seleccionado.
///@param _tiempo horas y minutos seleccionados.
///@param _tiempoSeleccionado controlador del tiempo actual del reloj.
///@param _controladorReloj controlador del texto del reloj.
///@param _estadoBoton estado entre las transiciones del botón.
///@param _restorationId id de restauracion del switch.
///@param _width obtiene el ancho de la pantalla del dispositivo.
///@param _height obtiene el alto de la pantalla del dispositivo.

class _InterfazAgregarRutina extends State<InterfazAgregarRutina> with RestorationMixin {

  final _formKey = GlobalKey<
      FormState>(); //Llave identificadora del formulario.
  final String _usuario; //Identificador del usuario.
  final int _relacionDispositivo; //Identificador de la rutina en el dispositivo.
  _InterfazAgregarRutina(this._usuario, this._relacionDispositivo); //Constructor de la clase.

  TextEditingController _nombre; //Controlador del campo de texto para el nombre.
  RestorableBool _activar; //Controlador del bool encargado de activar o desactivar el switch.

  Future<List> _dispositivosObtenidos; //Lista de dispositivos obtenidos.
  List<Dispositivo> _dispositivosLista; //Lista de elementos en el dropdown de dispositivos.
  Dispositivo _dispositivoSeleccionado; //Dispositivo seleccionado en el dropdown de dispositivos.
  IconData _iconoDispositivo; //Controlador del icono del dropdown de dispositivos.
  Color _dispositivoColorDrowDown; //Controlador del color de los elementos del dropdown de dispositivos.

  Future<List> _variablesObtenidas;//Lista con el mapeo de las variables.
  List _listaVariables; //Lista de variables obtenidas del dispositivos seleccionado.
  List<bool> _activarVariable; //Lista que indica la acción a tomar para cada variable.
  int _estado; //Estado del servicio de obtener variables.

  List<bool> _dias; //Lista de estados para los siete dias de la semana.

  String _horas; //Hora seleccionada.
  String _minutos; //Minuto seleccionado.
  String _tiempo; //Horas y minutos seleccionados.
  TimeOfDay _tiempoSeleccionado; //Controlador del tiempo actual del reloj.
  TextEditingController _controladorReloj; //Controlador del texto del reloj.

  ButtonState _estadoBoton; //Estado entre las transiciones del botón.
  String get restorationId => 'interruptor_activar'; //Id de restauracion del switch.

  @override

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState();
    _nombre = TextEditingController();
    _activar = RestorableBool(true);
    _dispositivoColorDrowDown = colores.obtenerColorInactivo();
    _iconoDispositivo = Icons.device_unknown_rounded;
    _dispositivoSeleccionado = Dispositivo();
    _dispositivoSeleccionado.nombre = 'Cargando...';
    _dispositivosLista = [Dispositivo()];
    _dispositivosLista[0] = _dispositivoSeleccionado;
    _obtenerDispositivos();
    _listaVariables = [];
    _activarVariable = [];
    _estado = 0;
    _dias = [false,false,false,false,false,false,false];
    _tiempo = DateTime.now().hour.toString() + ':' + DateTime.now().minute.toString();
    _tiempoSeleccionado = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
    _controladorReloj = TextEditingController();
    _controladorReloj.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    _estadoBoton = ButtonState.idle;
  }

  ///Registra las propiedades del "RestoreableBool"

  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    registerForRestoration(_activar, 'switch_value');
  }

  ///Hace una petición para conseguir un mapeo con la lista de los parámetros
  ///de los dispositivos.
  ///@see owleddomo_app/cuartos/DisporitivoTabla/ServiciosDispositivo.dispositivoCuarto#method().
  ///@return un mapeo con los dispositivos.

  Future<List> _obtenerDispositivos() async {
    setState(() {
      _dispositivosObtenidos =  ServiciosDispositivo.todosDispositivo(_usuario);//_usuario
    });
    _dispositivosObtenidos.then((result) => {
      if(mounted) {
        setState(() {
          _dispositivosLista = [];
          _dispositivoColorDrowDown = colores.obtenerColorInactivo();
          if(result.first == "EXITO" && result.last != "EXITO" ) {
            _dispositivoSeleccionado.nombre = 'Dispositivos';
            _dispositivosLista = [Dispositivo()];
            _dispositivosLista[0] = _dispositivoSeleccionado;
            _dispositivosLista..addAll(result.last);
          }
          else if (result.first == "VACIO") {
            _dispositivoSeleccionado.nombre = 'No hay dispositivos';
            _dispositivosLista = [Dispositivo()];
            _dispositivosLista[0] = _dispositivoSeleccionado;
          }
          else {
            _dispositivoColorDrowDown = colores.obtenerColorRiesgo();
            _dispositivoSeleccionado.nombre = 'Error';
            _dispositivosLista = [Dispositivo()];
            _dispositivosLista[0] = _dispositivoSeleccionado;
          }
        }),
      }
    });
    return _dispositivosObtenidos;
  }

  ///Hace una petición para conseguir un mapeo con la lista de los parámetros
  ///de las variables.
  ///@param dispositivoSeleccionado dispositivo seleccionado en el dropdown de la lista de dispositivos.
  ///@see owleddomo_app/cuartos/DisporitivoTabla/ServiciosVariable.variableByMAC#method().
  ///@return un mapeo con las variables.

  Future<List> _obtenerVariables(Dispositivo dispositivoSeleccionado) async {
    setState(() {
      _variablesObtenidas =  ServiciosVariable.variableByMAC(dispositivoSeleccionado.relacion_id);
    });
    _variablesObtenidas.then((result) => {
      _listaVariables = [],
      _activarVariable = [],
      if(result.first == "EXITO" && result.last != "EXITO") {
        for(Variable variable in result.last){
          if(variable.variable_id == '9HZA7L57GRSYG' ){
            _listaVariables.add(variable),
            _activarVariable.add(false),
          } else if (variable.variable_id == 'QRNSS74XFQMED') {
            _listaVariables.add(variable),
            _activarVariable.add(false),
          },
        },
        _estado = 1,
      } else {
        _estado = 3,
      },
    });
    return _variablesObtenidas;
  }

  ///Despliega una interfaz para poder seleccionar una hora y minuto del dia.
  ///@param seleccionador variable que almacena el valor de la pantalla desplegada
  ///en el showTimePicker.

  Future<Null> _seleccionarTiempo(BuildContext context) async {
    final TimeOfDay seleccionador = await showTimePicker(
      context: context,
      initialTime: _tiempoSeleccionado,
    ); //Seleccionador variable que almacena el valor de la pantalla desplegada en el showTimePicker.
    if (seleccionador != null)
      setState(() {
        _tiempoSeleccionado = seleccionador;
        _horas = _tiempoSeleccionado.hour.toString();
        _minutos = _tiempoSeleccionado.minute.toString();
        _tiempo = _horas + ':' + _minutos;
        _controladorReloj.text = _tiempo;
        _controladorReloj.text = formatDate(
            DateTime(2019, 08, 1, _tiempoSeleccionado.hour, _tiempoSeleccionado.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  ///Agrega la rutina o genera un error en caso de cualquier eventualidad.
  ///@see owleddomo_app/rutinas/ServiciosRutina.agregarRutina#method().
  ///@see owleddomo_app/shared/TratarError.estadoServicioActualizar#method().
  ///@return No retorna nada en caso de no obtener una validación positiva de los campos.

  _agregarCuarto() {
    String dias = '';
    String acciones= '';
    for (int i = 0; i<7 ; i++) {
      dias = '${dias}${_dias[i] ? 1 : 0}';
    }

    for (int i = 0; i<_activarVariable.length ; i++) {
      acciones = '${acciones}${_activarVariable[i] ? 1 : 0}';
    }
    if(_tiempo.substring(1,2) == ":") {
      _tiempo = '0${_tiempo}';
    }
    ServiciosRutina.agregarRutina(_usuario, _dispositivoSeleccionado.relacion_id, _nombre.text,
                                  _activar.value ? '1' : '0',_relacionDispositivo.toString(),
                                  dias, _tiempo, acciones)
        .then((result) {
          String respuesta = tratarError.estadoServicioActualizar( result, ['agregado'], context);
          if ( respuesta == "EXITO") {
            setState(() {
              _estadoBoton = ButtonState.success;
            });
          } else {
            setState(() {
              _estadoBoton = ButtonState.fail;
            });
          }
        });
  }

  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    ///Construye el Widget que maneja el campo para introducir el nombre de la rutina.
    ///@return Un Widget de Container con un campo de texto para el nombre.

    Widget _nombreWidget() {
      return Container(
        width: _width/2.4,
        child: Theme(
          data: ThemeData(
            primaryColor: colores.obtenerColorCuatro(),
          ),
          child: TextFormField(
            controller: _nombre,
            maxLength: 8,
            decoration: InputDecoration(
              filled: true,
              fillColor: colores.obtenerColorDos(),
              border: const OutlineInputBorder(),
              hintText: '¡Nombrala!',
              labelText: 'Nombre',
            ),
            autofocus: false,
            validator: (value) {
              String mensaje;
              value.isEmpty ? mensaje ='Un nombre corto' :
              mensaje = null;
              return mensaje;
            },
          ),
        ),
      );
    }

    ///Construye el Widget que maneja el switch para activar o desactivar la rutina.
    ///@return Un Widget de Padding con un switch cupertino.

    Widget _activarWidget() {
      return Padding(
        padding: EdgeInsets.only(
          bottom: _height/16.5,
        ),
        child: CupertinoSwitch(
          activeColor: colores.obtenerColorCuatro(),
          trackColor: colores.obtenerColorInactivo(),
          value: _activar.value,
          onChanged: (valor) {
            setState(() {
              _activar.value = valor;
            });
            },
        ),
      );
    }

    ///Construye el Widget que contiene los elementos de la primera fila, es decir,
    ///nombre y activar/desactivar.
    ///@return Un Widget de Container con la tarjeta que posee los campos de nombre y activo.

    Widget _primeraFila() {
      return Container(
        alignment: Alignment.centerLeft,
          child: Card(
            margin: EdgeInsets.only(top: _height/39.6),
            color: colores.obtenerColorDos(),
            child: Container(
              width: _width/1.2,
              margin: EdgeInsets.only(top: _height/52.8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  _nombreWidget(),
                  _activarWidget(),
                ],
              ),
            ),
          ),
      );
    }

    ///Construye el Widget que maneja la lista desplegable y seleccionable de los
    ///dispositivos.
    ///@return Un Widget de Container con un dropDown.

    Widget _dropDownDispositivo() {
      return Container(
        width: _width/4,
        child: DropdownButton<Dispositivo>(
          isExpanded: true,
          value: _dispositivoSeleccionado,
          menuMaxHeight: _height/2.64,
          icon: Icon(
            _iconoDispositivo,
            color: _dispositivoColorDrowDown,
          ),
          iconSize: _width/18,
          elevation: 16,
          underline: Container(
            height: _height/396,
            color: _dispositivoColorDrowDown,
          ),
          onChanged: (Dispositivo nuevoValor) {
            setState(() {
              _dispositivoSeleccionado = nuevoValor;
              if (_dispositivoSeleccionado.nombre != "Error"
                  && _dispositivoSeleccionado.relacion_id == null) {
                _dispositivoColorDrowDown = colores.obtenerColorInactivo();
                _iconoDispositivo = Icons.device_unknown_rounded;
                _estado = 0;
              } else if (_dispositivoSeleccionado.nombre == "Error"
                         && _dispositivoSeleccionado.relacion_id == null) {
                _iconoDispositivo = Icons.error_outline_rounded;
                _estado = 0;
              } else {
                _dispositivoColorDrowDown = colores.obtenerColorCuatro();
                _iconoDispositivo = Icons.check_rounded;
                _estado = 2;
                _obtenerVariables(_dispositivoSeleccionado);
              }
            });
            },
          items: _dispositivosLista.map((Dispositivo dispositivo) {
            return DropdownMenuItem<Dispositivo>(
              value: dispositivo,
              child: Text(
                dispositivo.nombre,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  color: _dispositivoColorDrowDown,
                  fontFamily: 'Lato',
                  fontSize: _width/30,
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    ///Construye el Widget que contiene una fila de un tipo de variable que tenga
    ///el dispositivo a manera de lista horizontal y unos botones activables.
    ///@param lista lista de las variables de un tipo del dispositivo seleccionado.
    ///@param tipo tipo de las variables en la fila.
    ///@return un Widget de Container con una lista horizontal de una fila con las variables.

    Widget _filaVariable (List<Widget> lista, String tipo) {
      return Container(
        width: _width,
        height: _height/15.84,
        alignment: Alignment.center,
        child: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: <Widget> [
            Row(
              children: [
                Text('${tipo}:'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: lista,
                )
              ],
            )
          ],
        ),
      );
    }

    ///Organiza las variables obtenidas en filas y columnas a manera de lista vertical.
    ///@param variables columna con todas las filas de variables obtenidas.
    ///@param filaLuz fila con todas las interfaces para cada variable de tipo luz.
    ///@param filaGrabar fila con todas las interfaces para cada variable de tipo grabar.
    ///@param filaOpenClose fila con todas las interfaces para cada variable de tipo Open/Close.
    ///@param contadorGrabar enumerador de las variables de tipo grabar.
    ///@param contadorLuz enumerador de las variables de tipo luz.
    ///@param contadorOpenClose enumerador de las variables de tipo Open/Close.
    ///@return una ventana emergente de dialogo que posee un constructor futuro
    ///de una lista horizontal con el activador de cada variable del dispositivo.

    Widget _popUpVariables () {
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              List<Widget> variables = []; //Columna con todas las filas de variables obtenidas.
              List<Widget> filaLuz = []; //Fila con todas las interfaces para cada variable de tipo luz.
              List<Widget> filaGrabar = []; //Fila con todas las interfaces para cada variable de tipo grabar.
              List<Widget> filaOpenClose = []; //Fila con todas las interfaces para cada variable de tipo Open/Close.

              int contadorGrabar = 0; //Enumerador de las variables de tipo grabar.
              int contadorLuz = 0; //Enumerador de las variables de tipo luz.
              int contadorOpenClose = 0; //Enumerador de las variables de tipo Open/Close.

              if( _listaVariables != null) {
                for (int i = 0; i < _listaVariables.length; i++) {
                  switch (_listaVariables[i].variable_id) {
                    case "4TBPNLLAQPZAR":
                      contadorGrabar++;
                      filaGrabar.add(Text("contadorGrabar"));
                      break;
                    case "9HZA7L57GRSYG":
                      contadorLuz++;
                      filaLuz.add(InkWell(
                        onTap: () {
                          setState(() {
                            _activarVariable[i] = _activarVariable[i] ? false : true;
                          });
                        },
                        child: Container(
                          width: _width/25.71428571428571,
                          height: _width/25.71428571428571,
                          margin: EdgeInsets.symmetric(
                            horizontal: _height/79.2,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _activarVariable[i] ? colores.obtenerColorTres()
                                : colores.obtenerColorInactivo(),
                            boxShadow: [
                              BoxShadow(
                                color: _activarVariable[i] ? colores.obtenerColorTres()
                                    : colores.obtenerColorInactivo(),
                                spreadRadius: _activarVariable[i] ? 5 : 0,
                                blurRadius: _activarVariable[i] ? 7 : 0,
                              ),
                            ],
                          ),
                        ),
                      )
                      );
                      break;
                    case "QRNSS74XFQMED":
                      contadorOpenClose++;
                      filaOpenClose.add(Text("contadorOpenClose"));
                      break;
                  }
                }
                if (contadorGrabar > 0) {
                  variables.add( _filaVariable(filaGrabar, "Grabar"));
                }
                if (contadorLuz > 0) {
                  variables.add( _filaVariable(filaLuz, "Luz"));
                }
                if (contadorOpenClose > 0) {
                  variables.add( _filaVariable(filaOpenClose, "Abrir/Cerrar"));
                }
              }
              return AlertDialog(
                backgroundColor: colores.obtenerColorDos(),
                title: Text(
                  "¿Que hago al llegar la hora?",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Lato",
                    fontSize: _height/44,
                  ),
                ),
                content:
                _estado != 0 ? _estado == 1 ?
                Padding(
                  padding: EdgeInsets.only(
                    top: 0,
                  ),
                  child: Container(
                    height: _height/15.84,
                    child: Center(
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        primary: false,
                        shrinkWrap: true,
                        children: variables,
                      ),
                    ),
                  ),
                ) :
                Text("Un momento por favor...") :
                Text("Antes hay que seleccionar un dispositivo"),//
              );
            },
          );
        },
      );
    }

    ///Construye el Widget con un botón que despliega la ventana emergente de las variables.
    ///@return un Widget de Container con un botón de icono.

    Widget _botonVariable() {
      return Container(
        child:IconButton(
          icon: Icon(
            Icons.account_tree_rounded,
            size: _height/19.8,
            color: colores.obtenerColorInactivo(),
          ),
          onPressed: () {
            _popUpVariables();
          },
        ),
      );
    }

    ///Construye el Widget que contiene los elementos de la segunda fila, es decir,
    ///la lista desplegable seleccionable de dispositivos y las acciones a tomar de las
    ///variables.
    ///@return Un Widget de Padding que contiene Row.

    Widget _segundaFila() {
      return Container(
        alignment: Alignment.centerRight,
        child: Card(
          margin: EdgeInsets.only(top: _height/39.6),
          color: colores.obtenerColorDos(),
          child: Container(
            width: _width/1.2,
            margin: EdgeInsets.symmetric(vertical: _height/79.2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _dropDownDispositivo(),
                _botonVariable(),
              ],
            ),
          ),
        ),
      );
    }

    ///Construye el boton de uno de los dias de la semana.
    ///@param dia texto con la letra del dia de la semana.
    ///@param index posición del bool que controla el día en la lista de bool de los días.
    ///@param actorAncho factor de anchura del boton.
    ///@return Un Widget de InkWell que contiene un Container.

    Widget _botonDia(String dia, int index, double factorAncho) {
      return InkWell(
        onTap: () {
          setState(() {
            _dias[index] = !_dias[index];
          });
        },
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: _dias[index]
              ? colores.obtenerColorCuatro()
              : colores.obtenerColorInactivo()),
          child: Padding(
            padding: EdgeInsets.all(_height/79.2),
            child: Center(
              heightFactor: 1,
              widthFactor: factorAncho,
              child:Text(
                dia,
                style: TextStyle(
                  fontSize: _height/39.6,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }

    ///Construye el Widget que contiene los elementos de la tercela fila, es decir,
    ///los botones de "D" (domingo), "L" (lunes), "M" (martes) y "Mi" (miercoles).
    ///@return Un Widget de Padding que contiene Row.

    Widget _terceraFila() {
      return Container(
        alignment: Alignment.centerLeft,
        child: Card(
          margin: EdgeInsets.only(top: _height/39.6),
          color: colores.obtenerColorDos(),
          child: Container(
            width: _width/1.2,
            margin: EdgeInsets.symmetric(vertical: _height/52.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _botonDia("D", 0, 2),
                _botonDia("L", 1, 2),
                _botonDia("M", 2, 1.4),
                _botonDia("Mi", 3, 1),
              ],
            ),
          ),
        ),
      );
    }

    ///Construye el Widget que contiene los elementos de la cuarta fila, es decir,
    ///los botones de "J" (jueves), "V" (viernes) y "S" (sabado).
    ///@return Un Widget de Padding que contiene Row.

    Widget _cuartaFila() {
      return Container(
        alignment: Alignment.centerRight,
        child: Card(
          margin: EdgeInsets.only(top: _height/79.2),
          color: colores.obtenerColorDos(),
          child: Container(
            width: _width/1.2,
            margin: EdgeInsets.symmetric(vertical: _height/52.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                _botonDia("J", 4, 2),
                _botonDia("V", 5, 2),
                _botonDia("S", 6, 2),
              ],
            ),
          ),
        ),
      );
    }

    ///Construye el Widget que contiene los elementos de la quinta fila, es decir,
    ///el seleccionador de tiempo para la rutina.
    ///@return Un Widget de Padding que contiene un selector de tiempo.

    Widget _quintaFila() {
      return Container(
        child: InkWell(
          onTap: () {
            _seleccionarTiempo(context);
            },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: _height/52.8, horizontal: _width/36),
            width: _width/1.2,
            height: _height/7.92,
            alignment: Alignment.center,
            child: TextFormField(
              style: TextStyle(fontSize: _width/6),
              textAlign: TextAlign.center,
              enabled: false,
              keyboardType: TextInputType.text,
              controller: _controladorReloj,
              decoration: InputDecoration(
                  disabledBorder:
                  UnderlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.all(_width/72)),
            ),
          ),
        ),
      );
    }

    ///Maneja el comportamiento al presionar el botón.
    ///@return un retorno vaico.

    void _alPresionarBoton() {
      _formKey.currentState.validate();
      if ( _usuario.isEmpty || _nombre.text.isEmpty || _activar == null ||
           _dispositivoSeleccionado.relacion_id == null || !_formKey.currentState.validate()) {
        setState(() {
          if( _dispositivoSeleccionado.nombre == "Dispositivos" &&
              _dispositivoSeleccionado.relacion_id == null) {
            _dispositivoColorDrowDown = colores.obtenerColorRiesgo();
          }
          if (_estadoBoton == ButtonState.fail) {
            _estadoBoton = ButtonState.idle;
          }
        });
        return;
      }
      setState(() {
        switch (_estadoBoton) {
          case ButtonState.idle:
            _estadoBoton = ButtonState.loading;
            _agregarCuarto();
            break;
          case ButtonState.loading:
            break;
          case ButtonState.success:
            _estadoBoton = ButtonState.idle;
            break;
          case ButtonState.fail:
            _estadoBoton = ButtonState.idle;
            break;
        }
      });
    }

    ///Construye el Widget que maneja el botón para suministrar los datos del formulario.
    ///@return Un Widget de Container que contiene un botón.

    Widget _boton() {
      return Container(
        width: _width/3.6,
        margin: EdgeInsets.only(bottom: _height/52.8),
        child: ProgressButton.icon(iconedButtons: {
          ButtonState.idle: IconedButton(
              text: "Enviar",
              icon: Icon(Icons.send, color: Colors.white),
              color: colores.obtenerColorInactivo()),
          ButtonState.loading:
          IconedButton(text: "Cargando", color: colores.obtenerColorUno()),
          ButtonState.fail: IconedButton(
              icon: Icon(Icons.cancel, color: Colors.white),
              color: colores.obtenerColorRiesgo()),
          ButtonState.success: IconedButton(
              text: "Exito",
              icon: Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              color: colores.obtenerColorTres())
        }, onPressed: () {
          if (_estadoBoton == ButtonState.fail){
            setState(() {
              _estadoBoton = ButtonState.idle;
            });
          } else {
            _alPresionarBoton();
          }
        },
            state: _estadoBoton),
      );
    }

    ///Construye el Widget de una carta que contiene el seleccionador de tiempo y
    ///el botón para suministrar el formulario.
    ///@return Un Widget de Container que posee una carta.

    Widget _ultimaCarta() {
      return Container(
        alignment: Alignment.center,
        child: Card(
          margin: EdgeInsets.only(top: _height/39.6),
          color: colores.obtenerColorDos(),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                _quintaFila(),
                Container (
                  width: _width/1.2,
                  child: Divider(
                    color: Colors.grey,
                    height: 20,
                    thickness: 1,
                    indent: 30,
                    endIndent: 30,
                  ),
                ),
                _boton(),
              ],
            ),
          ),
        ),
      );
    }

    ///Construye el Widget que contiene todos los elementos del formulario.
    ///@return Un Widget de ListView con el formulario.

    Widget _pantallaFrontal() {
      return ListView(
        physics: BouncingScrollPhysics(),
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _primeraFila(),
                  _segundaFila(),
                  _terceraFila(),
                  _cuartaFila(),
                  _ultimaCarta(),
                ],
              ),
            ),
          ],
      );
    }
    return _pantallaFrontal();
  }

}

