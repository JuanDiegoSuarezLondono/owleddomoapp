import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owleddomoapp/AppTrips.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'package:owleddomoapp/login/ServiciosPersona.dart';
import 'package:owleddomoapp/login/territorio/ServiciosTerritorio.dart';
import 'package:owleddomoapp/login/territorio/Territorio.dart';
import 'package:owleddomoapp/shared/SeleccionarIcono.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/shared/TratarError.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:flutter/animation.dart';

final PaletaColores colores = new PaletaColores(); //Colores predeterminados.
final TratarError tratarError = new TratarError(); //Respuestas predeterminadas a las API.

///Esta clase se encarga de manejar la pantalla del formulario para agregar un dispositivo.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param usuario identificador del usuario.
///@see owleddomo_app/cuartos/DispositivoTabla/DispositivosLista.dart#class().
///@return un Widget Stack con el fondo animado y un formulario.

class LoginMain extends StatefulWidget {

  LoginMain(); //Constructor de la clase.

  @override
  State<StatefulWidget> createState() {
    return _LoginMain(); //Crea un estado mutable del Widget.
  }

}

///Esta clase se encarga de formar un estado mutable de la clase “InterfazAgregarDispositivo”.
///@param _formKey Llave identificadora del formulario.
///@param _usuario identificador del usuario.
///@param _qrResultado texto recuperado del código QR.
///@param _textoBotonQR texto del boton para escanear el código QR.
///@param _nombre controlador del campo de texto para el nombre.
///@param _imagen path de la imagen para el dispositivo.
///@param _bordeImagen Color del borde del botón para seleccionar imagen.
///@param _bordeQR color del borde del botón para escanear el código QR.
///@param _letrasEscanealo color de las letras del botón para escanear el código QR.
///@param _estadoBoton Estado entre las transiciones del botón.
///@param _width obtiene el ancho de la pantalla del dispositivo.
///@param _height obtiene el alto de la pantalla del dispositivo.

class _LoginMain extends State<LoginMain> with TickerProviderStateMixin{

  _LoginMain(); //Constructor de la clase.

  final String _imagen = "assets/img/Logo_OWLed_Blanco.png";

  TextEditingController _nombreCorreo; //Controlador del campo de texto para el nombre.
  TextEditingController _clave;
  TextEditingController _nombre;
  TextEditingController _apellido;
  TextEditingController _correo; //Controlador del campo de texto para el nombre.
  TextEditingController _telefono;
  TextEditingController _ingresarClave;
  TextEditingController _confirmarClave;

  Future<List> _personasObtenidas; //Lista con el mapeo de los dispositivos.

  Future<List> _PCLIObtenidos; //Lista con el mapeo de los dispositivos.
  List<Territorio> _PCLILista; //Lista de elementos en el dropdown de dispositivos.
  Territorio _PCLISeleccionado; //Dispositivo seleccionado en el dropdown de dispositivos.

  Future<List> _ADMUNOObtenidos; //Lista con el mapeo de los dispositivos.
  List<Territorio> _ADMUNOLista; //Lista de elementos en el dropdown de dispositivos.
  Territorio _ADMUNOSeleccionado; //Dispositivo seleccionado en el dropdown de dispositivos.

  Future<List> _ADMDOSObtenidos; //Lista con el mapeo de los dispositivos.
  List<Territorio> _ADMDOSLista; //Lista de elementos en el dropdown de dispositivos.
  Territorio _ADMDOSSeleccionado; //Dispositivo seleccionado en el dropdown de dispositivos.

  List<Territorio> _paisListas;
  List<Territorio> _provinciaListas;
  List<Territorio> _ciudadListas;
  ButtonState _estadoBoton; //Estado entre las transiciones del botón.

  //Animation
  Animation<double> backgroundAnimation;

//Animation Controller
  AnimationController _backgroundController;
  //Alignment tweens
  AlignmentTween alignmentTop = AlignmentTween(begin: Alignment.topRight, end: Alignment.topLeft);
  AlignmentTween alignmentBottom = AlignmentTween(begin: Alignment.bottomRight, end: Alignment.bottomLeft);

  final _formKey = GlobalKey<FormState>(); //Llave identificadora del formulario.
  final _formKeyRegisterUno = GlobalKey<FormState>();
  final _formKeyRegisterDos = GlobalKey<FormState>();
  final _formKeyRegisterTres = GlobalKey<FormState>();
  final _formKeyRegisterCuatro = GlobalKey<FormState>();

  final List<LabeledGlobalKey> _keyList= [GlobalKey(),GlobalKey(),GlobalKey(),
                                         GlobalKey(),GlobalKey()];
  int _actualIndex;
  var _keyActual = new GlobalKey();

  Animatable<Color> backgroundNormal = TweenSequence<Color>([
    TweenSequenceItem(
      weight: 0.5,
      tween: ColorTween(
        begin: colores.obtenerColorUno().withBlue(330),
        end: colores.obtenerColorCuatro(),
      ),
    ),
    TweenSequenceItem(
      weight: 0.5,
      tween: ColorTween(
        begin: colores.obtenerColorCuatro(),
        end: colores.obtenerColorUno().withBlue(330),
      ),
    ),
    TweenSequenceItem(
      weight: 0.5,
      tween: ColorTween(
        begin: colores.obtenerColorUno().withBlue(330),
        end: colores.obtenerColorTres(),
      ),
    ),
    TweenSequenceItem(
      weight: 0.5,
      tween: ColorTween(
        begin: colores.obtenerColorTres(),
        end: colores.obtenerColorUno().withBlue(330),
      ),
    ),
  ]);

  @override

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState();
    _nombreCorreo = TextEditingController();
    _nombre = TextEditingController();
    _apellido = TextEditingController();
    _clave = TextEditingController();

    _PCLISeleccionado = Territorio();
    _PCLISeleccionado.nombre = 'Cargando...';
    _PCLILista = [Territorio()];
    _PCLILista[0] = _PCLISeleccionado;

    _ADMUNOSeleccionado = Territorio();
    _ADMUNOSeleccionado.nombre = 'Primero seleccione un pais';
    _ADMUNOLista = [Territorio()];
    _ADMUNOLista[0] = _ADMUNOSeleccionado;

    _ADMDOSSeleccionado = Territorio();
    _ADMDOSSeleccionado.nombre = 'Primero seleccione una region';
    _ADMDOSLista = [Territorio()];
    _ADMDOSLista[0] = _ADMDOSSeleccionado;

    _correo = TextEditingController(); //Controlador del campo de texto para el nombre.
    _telefono = TextEditingController();
    _ingresarClave = TextEditingController();
    _confirmarClave = TextEditingController();
    _estadoBoton = ButtonState.idle;
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    backgroundAnimation = CurvedAnimation(parent: _backgroundController, curve: Curves.easeIn);
    _obtenerPCLI();
    _keyActual = _keyList[0];
    _actualIndex = 0;
  }

  Future<List> _obtenerLogin() async {
    setState(() {
      _personasObtenidas =  ServiciosPersona.login(_nombreCorreo.text,_clave.text);
    });
    return _personasObtenidas;
  }

  Future<List> _obtenerPCLI() async {
    setState(() {
      _PCLIObtenidos = ServiciosTerritorio.obtenerPaises();
    });
    _PCLIObtenidos.then((result) => {
      if(mounted) {
        setState(() {
          _PCLILista = [];
          if(result.first == "EXITO" && result.last != "EXITO" ) {
            _PCLISeleccionado.nombre = 'Pais';
            _PCLILista = [Territorio()];
            _PCLILista[0] = _PCLISeleccionado;
            _PCLILista..addAll(result.last);
          }
          else if (result.first == "VACIO") {
            _PCLISeleccionado.nombre = 'No hay paises';
            _PCLILista = [Territorio()];
            _PCLILista[0] = _PCLISeleccionado;
          }
          else {
            _PCLISeleccionado.nombre = 'Error';
            _PCLILista = [Territorio()];
            _PCLILista[0] = _PCLISeleccionado;
          }
        }),
      }
    });
    return _PCLIObtenidos;

  }

  Future<List> _obtenerADMUNO(Territorio PCLI) async {
    setState(() {
      _ADMUNOObtenidos = ServiciosTerritorio.obtenerProvincias(PCLI.codigo_pais);
    });
    _ADMUNOObtenidos.then((result) => {
      if(mounted) {
        setState(() {
          _ADMUNOLista = [];
          if(result.first == "EXITO" && result.last != "EXITO" ) {
            _ADMUNOSeleccionado.nombre = 'Provincia/Departamento/Region';
            _ADMUNOLista = [Territorio()];
            _ADMUNOLista[0] = _ADMUNOSeleccionado;
            _ADMUNOLista..addAll(result.last);
          }
          else if (result.first == "VACIO") {
            _ADMUNOSeleccionado.nombre = 'No hay lugares';
            _ADMUNOLista = [Territorio()];
            _ADMUNOLista[0] = _ADMUNOSeleccionado;
          }
          else {
            _ADMUNOSeleccionado.nombre = 'Error';
            _ADMUNOLista = [Territorio()];
            _ADMUNOLista[0] = _ADMUNOSeleccionado;
          }
        }),
      }
    });
    return _ADMUNOObtenidos;
  }

  Future<List> _obtenerADMDOS(Territorio ADMUNO) async {
    setState(() {
      _ADMDOSObtenidos = ServiciosTerritorio.obtenerCiudades(ADMUNO.codigo_pais, ADMUNO.codigo_admin_uno);
    });
    _ADMDOSObtenidos.then((result) => {
      if(mounted) {
        setState(() {
          _ADMDOSLista = [];
          if(result.first == "EXITO" && result.last != "EXITO" ) {
            _ADMDOSSeleccionado.nombre = 'Ciudad/Pueblo';
            _ADMDOSLista = [Territorio()];
            _ADMDOSLista[0] = _ADMDOSSeleccionado;
            _ADMDOSLista..addAll(result.last);
          }
          else if (result.first == "VACIO") {
            _ADMDOSSeleccionado.nombre = 'No hay lugares';
            _ADMDOSLista = [Territorio()];
            _ADMDOSLista[0] = _ADMDOSSeleccionado;
          }
          else {
            _ADMDOSSeleccionado.nombre = 'Error';
            _ADMDOSLista = [Territorio()];
            _ADMDOSLista[0] = _ADMDOSSeleccionado;
          }
        }),
      }
    });
    return _ADMDOSObtenidos;
  }

  _alPresionar (Persona usuario) {
    Route route = MaterialPageRoute (builder: (context) =>
        AppTrips(usuario)
    );
    Navigator.push(context, route).then((value)=>{
    });//Especifica la ruta hacia la interfaz para agregar un dispositivo.
  }

  _alPresionarRegistrar () {
    ServiciosPersona.agregarUsuario(_ADMDOSSeleccionado.territorio_id, _nombre.text,
                                     _apellido.text, _telefono.text, _ingresarClave.text,
                                     _correo.text);
  }

  ///Controla los diferentes colores en los botones de selección de imagen y
  ///escaneo de código QR mediante la validación de sus respectivos campos.

  _validar() {
    Persona usuario;
    _obtenerLogin().then((value) =>
        {
          if (value.first == "EXITO" && value.last != "EXITO") {
            usuario = value.last[0],
            _estadoBoton = ButtonState.idle,
            _alPresionar(usuario),
          } else {
            setState(() {
              _estadoBoton = ButtonState.fail;
            }),
          }
        }
    );
  }

  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    Widget _animacion() {
      return Container(
        width: _width,
        height: _height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: alignmentTop.evaluate(backgroundAnimation),
            end: alignmentBottom.evaluate(backgroundAnimation),
            colors: [
              colores.obtenerColorUno(),
              backgroundNormal.evaluate(backgroundAnimation),
              colores.obtenerColorUno().withBlue(10),
            ],
          ),
        ),
      );
    }

    ///Construye el Widget que maneja el campo para introducir el nombre del dispositivo.
    ///@return un Widget de Padding que contiene un campo de texto.

    Widget _nombreCorreoWidget() {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: _width/12,
        ),
        child: Theme(
          data: ThemeData(
            primaryColor: colores.obtenerColorCuatro(),
          ),
          child: TextFormField(
            style: TextStyle(fontSize: 13),
            controller: _nombreCorreo,
            decoration: InputDecoration(
              filled: true,
              fillColor: colores.obtenerColorDos(),
              border: const OutlineInputBorder(),
              labelText: 'Introduzca el Correo o Usuario',
              icon: Icon(
                Icons.person_rounded,
                color: colores.obtenerColorInactivo(),
                size: _width/14.4,
              ),
            ),
            validator: (value) {
              //_validar();
              String mensaje;
              value.isEmpty ? mensaje='¡Hey! Te falta llenar esto.'
                  : mensaje=null;
              return mensaje;
            },
          ),
        ),
      );
    }

    ///Construye el Widget que maneja el campo para introducir el nombre del dispositivo.
    ///@return un Widget de Padding que contiene un campo de texto.

    Widget _claveWidget() {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: _width/12,
        ),
        child: Theme(
          data: ThemeData(
            primaryColor: colores.obtenerColorCuatro(),
          ),
          child: TextFormField(
            obscureText: true,
            style: TextStyle(fontSize: 13),
            controller: _clave,
            decoration: InputDecoration(
              filled: true,
              fillColor: colores.obtenerColorDos(),
              border: const OutlineInputBorder(),
              labelText: 'Introduzca su Contraseña',
              icon: Icon(
                Icons.lock_open_rounded,
                color: colores.obtenerColorInactivo(),
                size: _width/14.4,
              ),
            ),
            validator: (value) {
              //_validar();
              String mensaje;
              value.isEmpty ? mensaje='¡Hey! Te falta llenar esto.'
                  : mensaje=null;
              return mensaje;
            },
          ),
        ),
      );
    }

    ///Maneja el comportamiento al presionar el botón.
    ///@return un retorno vaico.

    void _alPresionarBoton() {
      switch (_estadoBoton) {
        case ButtonState.idle:
          _validar();
          _estadoBoton = ButtonState.loading;
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
      setState(() {
        _estadoBoton = _estadoBoton;
      });
    }

    ///Construye el Widget que maneja el botón para suministrar los datos del formulario.
    ///@return un Widget de Container que contiene un botón.

    Widget _boton() {
      return Container(
        width: _width/6.545454545454545,
        child: ProgressButton.icon(iconedButtons: {
          ButtonState.idle: IconedButton(
              icon: Icon(Icons.login_rounded, color: Colors.white),
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
          if (_formKey.currentState.validate()) {
            _alPresionarBoton();
          } else if (_estadoBoton == ButtonState.fail){
            _estadoBoton = ButtonState.idle;
          }
        },
            state: _estadoBoton),
      );
    }

    Widget _filaRegistro() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget> [
          Container(
            decoration: BoxDecoration(
              color: colores.obtenerColorUno(),
              shape: BoxShape.circle,
              border: Border.all(
                color: colores.obtenerColorUno(),
                width: 2,
              ),
            ),
            child: IconButton(
              iconSize: 30,
              color: colores.obtenerColorTres(),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Icon(
                Icons.person_add,
              ),
              onPressed: () => {
                _keyActual = _keyList[1],
                _actualIndex = 1,
                Scrollable.ensureVisible(
                  _keyList[1].currentContext,
                  duration: Duration(milliseconds: 1200),
                ),
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colores.obtenerColorCuatro(),
                width: 2,
              ),
            ),
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: SeleccionarIcono("RecuperarContraseña", _width/12, colores.obtenerColorCuatro()),
              onPressed: () {
              },
            ),
          ),
        ],
      );
    }

    Widget _botonesWidget() {
      return Container (
        margin: EdgeInsets.symmetric(horizontal: 24),
        alignment: Alignment.center,
        child: Column(
          children: <Widget> [
            _boton(),
            _filaRegistro(),
          ],
        )
      );
    }

    Widget _cartaIntro() {
      return Container (
        key: _keyList[0],
        margin: EdgeInsets.symmetric(horizontal: 24),
        alignment: Alignment.center,
        child: Card(
          child: Container(
            height: 350,
            width: 300,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _nombreCorreoWidget(),
                  _claveWidget(),
                  _botonesWidget(),
                ],
              ),
            ),
          ),
        ),
      );
    }

    _irAtras() {
      if( _keyActual != _keyList[0] ) {
        _actualIndex--;
        _keyActual = _keyList[ _actualIndex];
        Scrollable.ensureVisible(
          _keyActual.currentContext,
          duration: Duration(milliseconds: 1200),
        );
      };
    }

    _irAdelante() {
      if( _keyActual != _keyList[4] ) {
        _actualIndex++;
        _keyActual = _keyList[ _actualIndex];
        Scrollable.ensureVisible(
          _keyActual.currentContext,
          duration: Duration(milliseconds: 1200),
        );
      };
    }

    Widget _botonAtras() {
      return Container(
        margin: EdgeInsets.only(left: 10),
        child: ElevatedButton(
          child: Container (
            width: 80,
            child: Row (
              children: <Widget> [
                Container (
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                  ),
                ),
                Text(
                  "Regresar",
                  style: TextStyle(
                    color: colores.obtenerColorDos(),
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(colores.obtenerColorRiesgo()),
          ),
          onPressed: () => {
            _irAtras(),
          },
        ),
      );
    }

    Widget _botonSiguiente() {
      return Container(
        margin: EdgeInsets.only(right: 10),
        child: ElevatedButton(
          child: Container (
            width: 80,
            child: Row (
              children: <Widget> [
                Text(
                  "Siguiente",
                  style: TextStyle(
                    color: colores.obtenerColorDos(),
                    fontSize: 14.0,
                  ),
                ),
                Container (
                  child: Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(colores.obtenerColorTres()),
          ),
          onPressed: () => {
            _irAdelante(),
          },
        ),
      );
    }

    Widget _barraNavegacion() {
      return Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget> [
            _botonAtras(),
            _botonSiguiente(),
          ],
        ),
      );
    }

    Widget _nombreWidget() {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: _height/158.4,
          horizontal: _width/28,
        ),
        child: Theme(
          data: ThemeData(
            primaryColor: colores.obtenerColorCuatro(),
          ),
          child: TextFormField(
            controller: _nombre,
            decoration: InputDecoration(
              filled: true,
              fillColor: colores.obtenerColorDos(),
              border: const OutlineInputBorder(),
              hintText: '¿Como va a llamar a este dispositivo?',
              labelText: 'Ingrese su Nombre',
            ),
            validator: (value) {
              //_validar();
              String mensaje;
              value.isEmpty ? mensaje='¡Espera!... Debes ponerle un nombre.'
                  : mensaje=null;
              return mensaje;
            },
          ),
        ),
      );
    }

    Widget _apellidoWidget() {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: _height/158.4,
          horizontal: _width/28,
        ),
        child: Theme(
          data: ThemeData(
            primaryColor: colores.obtenerColorCuatro(),
          ),
          child: TextFormField(
            controller: _apellido,
            decoration: InputDecoration(
              filled: true,
              fillColor: colores.obtenerColorDos(),
              border: const OutlineInputBorder(),
              hintText: '¿Como va a llamar a este dispositivo?',
              labelText: 'Ingrese se Apellido',
            ),
            validator: (value) {
              //_validar();
              String mensaje;
              value.isEmpty ? mensaje='¡Espera!... Debes ponerle un nombre.'
                  : mensaje=null;
              return mensaje;
            },
          ),
        ),
      );
    }

    Widget _cartaNombApell() {
      return Container (
        key: _keyList[1],
        margin: EdgeInsets.symmetric(horizontal: 24),
        alignment: Alignment.center,
        child: Card(
          child: Container(
            height: 240,
            width: 300,
            child: Form(
              key: _formKeyRegisterUno,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 280,
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: SeleccionarIcono("Astronauta", _width/12, colores.obtenerColorInactivo()),
                          margin: EdgeInsets.only(left: 10),
                        ),
                        Container(
                          width: 240,
                          child: Column(
                            children: <Widget> [
                              _nombreWidget(),
                              _apellidoWidget(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  _barraNavegacion(),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget _dropDownPCLI() {
      return Container(
        width: _width/2,
        child: DropdownButton<Territorio>(
          isExpanded: true,
          value: _PCLISeleccionado,
          menuMaxHeight: _height/1,

          /*icon: Icon(
            _iconoDispositivo,
            color: _dispositivoColorDrowDown,
          ),
          iconSize: _width/18,*/
          elevation: 16,
          underline: Container(
            height: _height/396,
            //color: _dispositivoColorDrowDown,
          ),
          onChanged: (Territorio nuevoValor) {
            setState(() {
              _PCLISeleccionado = nuevoValor;
              if (_PCLISeleccionado.nombre != "Error"
                  && _PCLISeleccionado.codigo_pais == null) {
                //_dispositivoColorDrowDown = colores.obtenerColorInactivo();
                //_iconoDispositivo = Icons.device_unknown_rounded;
                //_estado = 0;
              } else if (_PCLISeleccionado.nombre == "Error"
                  && _PCLISeleccionado.codigo_pais == null) {
               //_iconoDispositivo = Icons.error_outline_rounded;
                //_estado = 0;
              } else {
                //_dispositivoColorDrowDown = colores.obtenerColorCuatro();
                //_iconoDispositivo = Icons.check_rounded;
                //_estado = 2;
                _obtenerADMUNO(_PCLISeleccionado);
              }
            });
          },
          items: _PCLILista.map((Territorio dispositivo) {
            return DropdownMenuItem<Territorio>(
              value: dispositivo,
              child: Text(
                dispositivo.nombre,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  //color: _dispositivoColorDrowDown,
                  fontFamily: 'Lato',
                  fontSize: _width/30,
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    Widget _dropDownADMUNO() {
      return Container(
        width: _width/2,
        child: DropdownButton<Territorio>(
          isExpanded: true,
          value: _ADMUNOSeleccionado,
          menuMaxHeight: _height/1,

          /*icon: Icon(
            _iconoDispositivo,
            color: _dispositivoColorDrowDown,
          ),
          iconSize: _width/18,*/
          elevation: 16,
          underline: Container(
            height: _height/396,
            //color: _dispositivoColorDrowDown,
          ),
          onChanged: (Territorio nuevoValor) {
            setState(() {
              _ADMUNOSeleccionado = nuevoValor;
              if (_ADMUNOSeleccionado.nombre != "Error"
                  && _ADMUNOSeleccionado.codigo_admin_uno == null) {
                //_dispositivoColorDrowDown = colores.obtenerColorInactivo();
                //_iconoDispositivo = Icons.device_unknown_rounded;
                //_estado = 0;
              } else if (_ADMUNOSeleccionado.nombre == "Error"
                  && _ADMUNOSeleccionado.codigo_admin_uno == null) {
                //_iconoDispositivo = Icons.error_outline_rounded;
                //_estado = 0;
              } else {
                //_dispositivoColorDrowDown = colores.obtenerColorCuatro();
                //_iconoDispositivo = Icons.check_rounded;
                //_estado = 2;
                _obtenerADMDOS(_ADMUNOSeleccionado);
              }
            });
          },
          items: _ADMUNOLista.map((Territorio dispositivo) {
            return DropdownMenuItem<Territorio>(
              value: dispositivo,
              child: Text(
                dispositivo.nombre,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  //color: _dispositivoColorDrowDown,
                  fontFamily: 'Lato',
                  fontSize: _width/30,
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    Widget _dropDownADMDOS() {
      return Container(
        width: _width/2,
        child: DropdownButton<Territorio>(
          isExpanded: true,
          value: _ADMDOSSeleccionado,
          menuMaxHeight: _height/1,

          /*icon: Icon(
            _iconoDispositivo,
            color: _dispositivoColorDrowDown,
          ),
          iconSize: _width/18,*/
          elevation: 16,
          underline: Container(
            height: _height/396,
            //color: _dispositivoColorDrowDown,
          ),
          onChanged: (Territorio nuevoValor) {
            setState(() {
              _ADMDOSSeleccionado = nuevoValor;
              if (_ADMDOSSeleccionado.nombre != "Error"
                  && _ADMDOSSeleccionado.codigo_admin_dos == null) {
                //_dispositivoColorDrowDown = colores.obtenerColorInactivo();
                //_iconoDispositivo = Icons.device_unknown_rounded;
                //_estado = 0;
              } else if (_ADMDOSSeleccionado.nombre == "Error"
                  && _ADMDOSSeleccionado.codigo_admin_dos == null) {
                //_iconoDispositivo = Icons.error_outline_rounded;
                //_estado = 0;
              } else {
                //_dispositivoColorDrowDown = colores.obtenerColorCuatro();
                //_iconoDispositivo = Icons.check_rounded;
                //_estado = 2;
              }
            });
          },
          items: _ADMDOSLista.map((Territorio dispositivo) {
            return DropdownMenuItem<Territorio>(
              value: dispositivo,
              child: Text(
                dispositivo.nombre,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  //color: _dispositivoColorDrowDown,
                  fontFamily: 'Lato',
                  fontSize: _width/30,
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    Widget _cartaTerritorio() {
      return Container (
        key: _keyList[2],
        margin: EdgeInsets.symmetric(horizontal: 24),
        alignment: Alignment.center,
        child: Card(
          child: Container(
            height: 300,
            width: 300,
            child: Form(
              key: _formKeyRegisterDos,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 280,
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: SeleccionarIcono("Localizacion", _width/12, colores.obtenerColorInactivo()),
                          margin: EdgeInsets.only(left: 10),
                        ),
                        Container(
                          width: 240,
                          child: Column(
                            children: <Widget> [
                              _dropDownPCLI(),
                              _dropDownADMUNO(),
                              _dropDownADMDOS(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  _barraNavegacion(),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget _correoWidget() {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: _height/158.4,
          horizontal: _width/28,
        ),
        child: Theme(
          data: ThemeData(
            primaryColor: colores.obtenerColorCuatro(),
          ),
          child: TextFormField(
            controller: _correo,
            decoration: InputDecoration(
              filled: true,
              fillColor: colores.obtenerColorDos(),
              border: const OutlineInputBorder(),
              hintText: '¿Como va a llamar a este dispositivo?',
              labelText: 'Ingrese su correo',
            ),
            validator: (value) {
              //_validar();
              String mensaje;
              value.isEmpty ? mensaje='¡Espera!... Debes ponerle un nombre.'
                  : mensaje=null;
              return mensaje;
            },
          ),
        ),
      );
    }

    Widget _telefonoWidget() {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: _height/158.4,
          horizontal: _width/28,
        ),
        child: Theme(
          data: ThemeData(
            primaryColor: colores.obtenerColorCuatro(),
          ),
          child: TextFormField(
            controller: _telefono,
            decoration: InputDecoration(
              filled: true,
              fillColor: colores.obtenerColorDos(),
              border: const OutlineInputBorder(),
              hintText: '¿Como va a llamar a este dispositivo?',
              labelText: 'Ingrese su telefono',
            ),
            validator: (value) {
              //_validar();
              String mensaje;
              value.isEmpty ? mensaje='¡Espera!... Debes ponerle un nombre.'
                  : mensaje=null;
              return mensaje;
            },
          ),
        ),
      );
    }

    Widget _cartaCorreoTel() {
      return Container (
        key: _keyList[3],
        margin: EdgeInsets.symmetric(horizontal: 24),
        alignment: Alignment.center,
        child: Card(
          child: Container(
            height: 240,
            width: 300,
            child: Form(
              key: _formKeyRegisterTres,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 280,
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: SeleccionarIcono("Correo", _width/12, colores.obtenerColorInactivo()),
                          margin: EdgeInsets.only(left: 10),
                        ),
                        Container(
                          width: 240,
                          child: Column(
                            children: <Widget> [
                              _correoWidget(),
                              _telefonoWidget(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  _barraNavegacion(),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget _introducirClaveWidget() {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: _height/158.4,
          horizontal: _width/28,
        ),
        child: Theme(
          data: ThemeData(
            primaryColor: colores.obtenerColorCuatro(),
          ),
          child: TextFormField(
            controller: _ingresarClave,
            decoration: InputDecoration(
              filled: true,
              fillColor: colores.obtenerColorDos(),
              border: const OutlineInputBorder(),
              hintText: '¿Como va a llamar a este dispositivo?',
              labelText: 'Ingresar clave',
            ),
            validator: (value) {
              //_validar();
              String mensaje;
              value.isEmpty ? mensaje='¡Espera!... Debes ponerle un nombre.'
                  : mensaje=null;
              return mensaje;
            },
          ),
        ),
      );
    }

    Widget _confirmarClaveWidget() {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: _height/158.4,
          horizontal: _width/28,
        ),
        child: Theme(
          data: ThemeData(
            primaryColor: colores.obtenerColorCuatro(),
          ),
          child: TextFormField(
            controller: _confirmarClave,
            decoration: InputDecoration(
              filled: true,
              fillColor: colores.obtenerColorDos(),
              border: const OutlineInputBorder(),
              hintText: '¿Como va a llamar a este dispositivo?',
              labelText: 'Confirmar Clave',
            ),
            validator: (value) {
              //_validar();
              String mensaje;
              value.isEmpty ? mensaje='¡Espera!... Debes ponerle un nombre.'
                  : mensaje=null;
              return mensaje;
            },
          ),
        ),
      );
    }

    Widget _botonEnviar() {
      return Container(
        margin: EdgeInsets.only(right: 10),
        child: ElevatedButton(
          child: Container (
            width: 80,
            child: Row (
              children: <Widget> [
                Text(
                  "Registrarse",
                  style: TextStyle(
                    color: colores.obtenerColorDos(),
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(colores.obtenerColorUno()),
          ),
          onPressed: () => {
            _actualIndex = 0,
            _keyActual = _keyList[0],
            Scrollable.ensureVisible(
              _keyList[3].currentContext,
              duration: Duration(milliseconds: 400),
            ).then((value) => {
              Scrollable.ensureVisible(
                _keyList[2].currentContext,
                duration: Duration(milliseconds: 400),
              ).then((value) => {
                Scrollable.ensureVisible(
                  _keyList[1].currentContext,
                  duration: Duration(milliseconds: 400),
                ).then((value) => {
                  Scrollable.ensureVisible(
                    _keyList[0].currentContext,
                    duration: Duration(milliseconds: 400),
                  ),
                }),
              }),
            }),
            _alPresionarRegistrar(),
          },
        ),
      );
    }

    Widget _barraNavegacionFinal() {
      return Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget> [
            _botonAtras(),
            _botonEnviar(),
          ],
        ),
      );
    }

    Widget _cartaClave() {
      return Container (
        key: _keyList[4],
        margin: EdgeInsets.symmetric(horizontal: 24),
        alignment: Alignment.center,
        child: Card(
          child: Container(
            height: 240,
            width: 300,
            child: Form(
              key: _formKeyRegisterCuatro,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 280,
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Icon(
                            Icons.vpn_key_rounded,
                            color: colores.obtenerColorInactivo(),
                            size: _width/12,
                          ),
                          margin: EdgeInsets.only(left: 10),
                        ),
                        Container(
                          width: 240,
                          child: Column(
                            children: <Widget> [
                              _introducirClaveWidget(),
                              _confirmarClaveWidget(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  _barraNavegacionFinal(),
                ],
              ),
            ),
          ),
        ),
      );
    }

    ///Construye el Widget que contiene todos los elementos del formulario.
    ///@return un Widget de Padding que contiene un ListView con el formulario.

    Widget _pantallaFrontal() {
      return Center (
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Column (
                children: <Widget>[
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top:_height/14.94339622),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colores.obtenerColorUno(),
                          boxShadow: [
                            BoxShadow(color: colores.obtenerColorDos(), spreadRadius: 2),
                          ],
                        ),
                        height: 220,
                        width: 220,
                      ),
                      Container (
                        margin: EdgeInsets.only(top:_height/14.94339622),
                        height: 180,
                        width: 180,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                            image: AssetImage(_imagen),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container (
                    margin: EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    height: 400,
                    width: _width,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget> [
                        _cartaIntro(),
                        _cartaNombApell(),
                        _cartaTerritorio(),
                        _cartaCorreoTel(),
                        _cartaClave(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
      );
    }

    return SafeArea(
      child: AnimatedBuilder(
          animation: backgroundAnimation,
          builder: (context, child) {
            return Scaffold(
              body: Stack(children: <Widget>[
                _animacion(),
                _pantallaFrontal(),
              ]),
            );
          }),
    );
  }
}