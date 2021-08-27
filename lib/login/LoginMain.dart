import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owleddomoapp/AppTrips.dart';
import 'package:owleddomoapp/login/territorio/ServiciosTerritorio.dart';
import 'package:owleddomoapp/login/territorio/Territorio.dart';
import 'package:owleddomoapp/login/ServiciosPersona.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'package:owleddomoapp/shared/SeleccionarIcono.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

///Esta clase se encarga de manejar la pantalla de entrada de la app.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@return un Widget SafeArea con un Scaffold que posee la pantalla de intro.

class LoginMain extends StatefulWidget {

  final String token;

  LoginMain(this.token); //Constructor de la clase.

  @override
  State<StatefulWidget> createState() {
    return _LoginMain(token); //Crea un estado mutable del Widget.
  }

}

///Esta clase se encarga de formar un estado mutable de la clase “LoginMain”.
///@param _imagen path de la imagen para el logo OWLED.
///@param _nombreCorreo controlador del campo de texto para el nombre del logueo.
///@param _clave controlador del campo de texto para la contraseña del logueo.
///@param _nombre controlador del nombre del nuevo usuario.
///@param _apellido controlador del apellido del nuevo usuario.
///@param _correo controlador del correo del nuevo usuario.
///@param _errorCorreo controlador del texto de error del campo del correo del nuevo usuario.
///@param _correoObtenidos lista con el mapeo de los correos.
///@param _telefono controlador del telefono del nuevo usuario.
///@param _ingresarClave controlador de la clave del nuevo usuario.
///@param _errorIngresarClave controlador del texto de error del campo de la clave del nuevo usuario.
///@param _confirmarClave controlador para confirmar la clave del nuevo usuario.
///@param _errorConfirmarClave controlador del texto de error del campo para confirmar la clave del nuevo usuario.
///@param _personasObtenidas lista con el mapeo de las personas.
///@param _ADMUNOObtenidos lista con el mapeo de las regiones obtenidas.
///@param _ADMUNOLista lista de elementos en el dropdown de regiones.
///@param _ADMUNOSeleccionado region seleccionada en el dropdown de regiones.
///@param _colorADMUNO color del dropdown de regiones.
///@param _errorDepartamento indica si ha habido un error al cargar los departamentos.
///@param _ADMDOSObtenidos lista con el mapeo de las ciudades obtenidas.
///@param _ADMDOSLista lista de elementos en el dropdown de ciudades.
///@param _ADMDOSSeleccionado ciudad seleccionada en el dropdown de ciudades.
///@param _colorADMDOS color del dropdown de ciudades.
///@param _estadoBoton estado entre las transiciones del botón.
///@param _formKey llave identificadora del formulario de login.
///@param _formKeyRegisterUno llave identificadora del formulario de nombre y apellido.
///@param _formKeyRegisterDos llave identificadora del formulario de territorios.
///@param _formKeyRegisterTres llave identificadora del formulario de correo y telefono.
///@param _formKeyRegisterCuatro llave identificadora del formulario de contraseña.
///@param _keyList llave identificadora de cada carta.
///@param _actualIndex posición actual en el formulario.
///@param _keyActual llave de la posición actual en el formulario.
///@param _width obtiene el ancho de la pantalla del dispositivo.
///@param _height obtiene el alto de la pantalla del dispositivo.
///

class _LoginMain extends State<LoginMain>{

  final String _token;

  _LoginMain(this._token); //Constructor de la clase.

  final String _imagen = "assets/img/Logo_OWLed_Blanco.png"; //Path de la imagen para el logo OWLED.

  TextEditingController _nombreCorreo; //Controlador del campo de texto para el nombre del logeo.
  TextEditingController _clave; //Controlador del campo de texto para la contraseña del logueo.

  TextEditingController _nombre; //Controlador del nombre del nuevo usuario.
  TextEditingController _apellido; //Controlador del apellido del nuevo usuario.

  TextEditingController _correo; //Controlador del correo del nuevo usuario.
  String _errorCorreo; //Controlador del texto de error del campo del correo del nuevo usuario.
  Future<List> _correoObtenidos; //Lista con el mapeo de los correos.
  TextEditingController _telefono; //Controlador del telefono del nuevo usuario.

  TextEditingController _ingresarClave; //Controlador de la clave del nuevo usuario.
  String _errorIngresarClave; //Controlador del texto de error del campo de la clave del nuevo usuario.
  TextEditingController _confirmarClave; //Controlador para confirmar la clave del nuevo usuario.
  String _errorConfirmarClave; //Controlador del texto de error del campo para confirmar la clave del nuevo usuario.

  Future<List> _personasObtenidas; //Lista con el mapeo de las personas.

  Future<List> _ADMUNOObtenidos; //Lista con el mapeo de las regiones obtenidas.
  List<Territorio> _ADMUNOLista; //Lista de elementos en el dropdown de regiones.
  Territorio _ADMUNOSeleccionado; //Region seleccionada en el dropdown de regiones.
  Color _colorADMUNO; //Color del dropdown de regiones.
  bool _errorDepartamento; //Indica si ha habido un error al cargar los departamentos.

  Future<List> _ADMDOSObtenidos; //Lista con el mapeo de las ciudades obtenidas.
  List<Territorio> _ADMDOSLista; //Lista de elementos en el dropdown de ciudades.
  Territorio _ADMDOSSeleccionado; //Ciudad seleccionada en el dropdown de ciudades.
  Color _colorADMDOS; //Color del dropdown de ciudades.

  ButtonState _estadoBoton; //Estado entre las transiciones del botón.

  final _formKey = GlobalKey<FormState>(); //Llave identificadora del formulario de login.
  final _formKeyRegisterUno = GlobalKey<FormState>(); //Llave identificadora del formulario de nombre y apellido.
  final _formKeyRegisterDos = GlobalKey<FormState>(); //Llave identificadora del formulario de territorios.
  final _formKeyRegisterTres = GlobalKey<FormState>(); //Llave identificadora del formulario de correo y telefono.
  final _formKeyRegisterCuatro = GlobalKey<FormState>(); //Llave identificadora del formulario de contraseña.

  final List<LabeledGlobalKey> _keyList = [GlobalKey(),GlobalKey(),GlobalKey(),
                                         GlobalKey(),GlobalKey()]; //Llave identificadora de cada carta.

  int _actualIndex; //Posición actual en el formulario.
  var _keyActual = new GlobalKey(); //Llave de la posicion actual en el formulario.

  @override

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState();
    _nombreCorreo = TextEditingController();
    _clave = TextEditingController();

    _nombre = TextEditingController();
    _apellido = TextEditingController();

    _ADMUNOSeleccionado = Territorio();
    _ADMUNOSeleccionado.nombre = 'Primero seleccione un pais';
    _ADMUNOLista = [Territorio()];
    _ADMUNOLista[0] = _ADMUNOSeleccionado;
    _colorADMUNO = Colors.black;
    _errorDepartamento = false;

    _ADMDOSSeleccionado = Territorio();
    _ADMDOSSeleccionado.nombre = 'Primero seleccione una region';
    _ADMDOSLista = [Territorio()];
    _ADMDOSLista[0] = _ADMDOSSeleccionado;
    _colorADMDOS = Colors.black;

    _correo = TextEditingController();
    _errorCorreo = "Ingresa un correo valido.";
    _telefono = TextEditingController();

    _ingresarClave = TextEditingController();
    _confirmarClave = TextEditingController();

    _estadoBoton = ButtonState.idle;
    _keyActual = _keyList[0];
    _actualIndex = 0;
    _ADMUNOObtenidos = _obtenerADMUNO();
  }

  ///Lleva los valores de todas las casillas para ingresar datos a su valor inicial.

  _reininiciarTextInputs() {
    setState(() {
      _nombreCorreo.text = "";
      _clave.text = "";
      _nombre.text = "";
      _apellido.text = "";
      _obtenerADMUNO();
      _ADMDOSSeleccionado = Territorio();
      _ADMDOSSeleccionado.nombre = 'Primero seleccione una region';
      _ADMDOSLista = [Territorio()];
      _ADMDOSLista[0] = _ADMDOSSeleccionado;
      _correo.text = "";
      _telefono.text = "";
      _ingresarClave.text = "";
      _confirmarClave.text = "";
    });
  }

  ///Hace una petición para conseguir un mapeo con la lista de los parámetros del
  ///usuario que solicita el ingreso.
  ///@see owleddomo_app/login/ServiciosPersona.login#method().
  ///@return Un mapeo con el usuario.

  Future<List> _obtenerLogin() async {
    var bytes1 = utf8.encode(_clave.text);
    var hash = sha256.convert(bytes1);
    _personasObtenidas =  ServiciosPersona.login(_nombreCorreo.text,hash, _token);
    return _personasObtenidas;
  }

  ///Hace una petición para conseguir un mapeo con la lista de los departamentos.
  ///@see owleddomo_app/login/territorio/ServiciosTerritorio.obtenerProvincias#method().
  ///@return Un mapeo con el usuario.

  Future<List> _obtenerADMUNO() async {
    _ADMUNOObtenidos = ServiciosTerritorio.obtenerProvincias("CO");
    _ADMUNOObtenidos.then((result) {
      if(mounted) {
        setState(() {
          _ADMUNOLista = [];
          if(result.first.toString()[0] == "2" && result.last.toString()[0] != "2"
              && result.last.toString() != "[]" ) {
            _ADMUNOSeleccionado.nombre = 'Provincia/Departamento/Region';
            _ADMUNOLista = [Territorio()];
            _ADMUNOLista[0] = _ADMUNOSeleccionado;
            _ADMUNOLista..addAll(result.last);
            _errorDepartamento = false;
            _colorADMUNO = Colors.black;
          } else {
            _ADMUNOSeleccionado.nombre = 'Error / Actualice por favor';
            _ADMUNOLista = [Territorio()];
            _ADMUNOLista[0] = _ADMUNOSeleccionado;
            _errorDepartamento = true;
            _colorADMUNO = Colors.red;
          }
        });
      }
    });
    return _ADMUNOObtenidos;
  }

  Future<List> _obtenerADMDOS(Territorio ADMUNO) async {
    setState(() {
      _ADMDOSObtenidos = ServiciosTerritorio.obtenerCiudades(ADMUNO.codigo_pais, ADMUNO.codigo_admin_uno);
    });
    _ADMDOSObtenidos.then((result) {
      if(mounted) {
        setState(() {
          _ADMDOSLista = [];
          if(result.first.toString()[0] == "2" && result.last.toString()[0] != "2" ) {
            _ADMDOSSeleccionado.nombre = 'Ciudad/Pueblo';
            _ADMDOSLista = [Territorio()];
            _ADMDOSLista[0] = _ADMDOSSeleccionado;
            _ADMDOSLista..addAll(result.last);
            _colorADMDOS = Colors.black;
          }
          else {
            _ADMDOSSeleccionado.nombre = 'Error / Actualice por favor';
            _ADMDOSLista = [Territorio()];
            _ADMDOSLista[0] = _ADMDOSSeleccionado;
            _colorADMDOS = Colors.red;
          }
        });
      }
    });
    return _ADMDOSObtenidos;
  }

  ///Hace una petición para conseguir una repuesta que corrobora si un correo esta
  ///o no disponible.
  ///@see owleddomo_app/login/ServiciosPersona.comprobarCorreo#method().
  ///@return Un mapeo con el correo.

  Future<List> _comprobarCorreo() async {
    _correoObtenidos =  ServiciosPersona.comprobarCorreo(_correo.text);
    return _correoObtenidos;
  }

  void autoLogIn(Persona usuario) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('persona_id', usuario.persona_id);
    prefs.setString('territorio_id', usuario.territorio_id.toString());
    prefs.setString('nombres', usuario.nombres);
    prefs.setString('apellidos', usuario.apellidos);
    prefs.setString('telefono', usuario.telefono);
    prefs.setString('fecha_nacimiento', usuario.fecha_nacimiento);
    prefs.setString('correo_electronico', usuario.correo_electronico);
    prefs.setString('url_foto', usuario.url_foto);
    prefs.setString('url_icono', usuario.url_icono);
    prefs.setString('rol', usuario.rol);
    prefs.setString('apodo', usuario.apodo);
    prefs.setString('codigo_usuario', usuario.codigo_usuario);
    prefs.setString('configuracion_id', usuario.configuracion_id);
    prefs.setString('tema', usuario.tema.toString());
  }

  _alConfirmar (Persona usuario) {
    autoLogIn(usuario);
    _reininiciarTextInputs();
    Route route = MaterialPageRoute (builder: (context) =>
        AppTrips(usuario)
    );
    Navigator.push(context, route).then((value)=>{
    });//Especifica la ruta hacia la interfaz para agregar un dispositivo.
  }

  ///Despliega la pantalla que advierte que se ha enviado un correo.
  ///@return un texto vacío.

  Widget _alertaConfirmarCorreo() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Color(0xFF08192d),
        title: const Text(
          '¡Ya casi!',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        content: const Text(
            'Te hemos enviado un mensaje a tu correo electrónico'
            ' para que confirmes la creación de tu cuenta.',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text(
                'OK',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ); //Indica que se ha desplegado una pantalla de carga.
    return  Text("");
  }

  _alPresionarRegistrar () {
    var bytes1 = utf8.encode(_ingresarClave.text);
    var hash = sha256.convert(bytes1);
    _alertaConfirmarCorreo();
    _reininiciarTextInputs();
    ServiciosPersona.agregarUsuario(_ADMDOSSeleccionado.territorio_id, _nombre.text,
                                     _apellido.text, _telefono.text, hash,
                                     _correo.text);
  }

  ///Controla los diferentes colores en los botones de selección de imagen y
  ///escaneo de código QR mediante la validación de sus respectivos campos.

  _validar() {
    if(_formKey.currentState.validate()) {
      Persona usuario;
      _obtenerLogin().then((value) =>
      {
        if (value.first.toString()[0] == "2" && value.last.toString()[0] != "2"
            && value.last.toString() != "[]" && mounted) {
          setState(() {
            usuario = value.last[0];
            _estadoBoton = ButtonState.idle;
          }),
          _alConfirmar(usuario),
        } else {
          if (mounted) {
            setState(() {
              _estadoBoton = ButtonState.fail;
            }),
          }
        }
      }
      );
    } else {
      _estadoBoton = ButtonState.fail;
    }
  }

  ///Maneja el comportamiento al presionar el botón.
  ///@return un retorno vaico.

  void _alPresionarBoton() {
    switch (_estadoBoton) {
      case ButtonState.idle:
        _estadoBoton = ButtonState.loading;
        _validar();
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

  ///Una ventana emergente que bloquea el resto de la interfaz hasta que se comprueba
  ///que el correo suministrado esta libre.
  ///@return un Alert dialog.

  _cargandoCorreo() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Color(0xFF08192d),
          content: SizedBox(
            child: Text(
              "Comprobando el correo...",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  _irAdelante() {
    bool validarTerritorios = false;
    bool validarTelefono = false;

    if(mounted) {
      setState(() {
        if(_keyActual == _keyList[2]) {
          if( _ADMUNOSeleccionado != null && _ADMUNOSeleccionado.nombre != 'Primero seleccione un pais'
              && _ADMUNOSeleccionado.nombre != 'Provincia/Departamento/Region' && _ADMUNOSeleccionado.nombre != "Error / Actualice por favor") {
            _colorADMUNO = Colors.black;
          } else {
            _colorADMUNO = Colors.red;
          }
          if( _ADMDOSSeleccionado != null && _ADMDOSSeleccionado.nombre != 'Primero seleccione una region'
              && _ADMDOSSeleccionado.nombre != "Ciudad/Pueblo" && _ADMDOSSeleccionado.nombre != "Error / Actualice por favor"){
            _colorADMDOS = Colors.black;
            validarTerritorios =true;
          } else {
            _colorADMDOS = Colors.red;
          }
        }

       if(_keyActual == _keyList[3]) {
         if(_telefono.text.isNotEmpty) {
           validarTelefono = true;
         }
         if(_correo.text.isNotEmpty && _correo.text.length <= 63) {
           if(_correo.text.contains('@',1) && _correo.text.contains('.',1)){
             if(_correo.text.contains('.',_correo.text.lastIndexOf('@'))
                 && !_correo.text.contains(' ')
                 && _correo.text.substring(_correo.text.indexOf('.')).length != 1) {
               _cargandoCorreo();
               _comprobarCorreo().then((result) {
                 if(mounted) {
                   setState(() {
                     if(result.last != null) {
                       if(result.first.toString()[0] == "2" && result.last.toString()[0] != "2" && result.last.toString() != "[]" ) {
                         _errorCorreo = null;
                         if(validarTelefono) {
                           _actualIndex++;
                           _keyActual = _keyList[ _actualIndex];
                           Scrollable.ensureVisible(
                             _keyActual.currentContext,
                             duration: Duration(milliseconds: 1200),
                           );
                         }
                       } else {
                         _errorCorreo = 'Ya esta en uso';
                       }
                     } else {
                       _errorCorreo = 'Error, intenda de nuevo';
                     }
                   });
                 }
                 _formKeyRegisterTres.currentState.validate();
                 Navigator.of(context).pop(null);
               });
             } else {
               _errorCorreo = "Ingresa un correo valido.";
             }
           } else {
             _errorCorreo = "Ingresa un correo valido.";
           }
         } else {
           _errorCorreo = "Ingresa un correo valido.";
         }
         _formKeyRegisterTres.currentState.validate();
       }
      });
    }

    if((_keyActual == _keyList[1] && _formKeyRegisterUno.currentState.validate())
        || (_keyActual == _keyList[2] && validarTerritorios)) {
      _actualIndex++;
      _keyActual = _keyList[ _actualIndex];
      Scrollable.ensureVisible(
        _keyActual.currentContext,
        duration: Duration(milliseconds: 1200),
      );
    }
  }

  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    ///Construye el Widget que maneja el fondo de la pantalla.
    ///@return un Widget de Container que posee un gradiente de color.

    Widget _fondo() {
      return Container(
        width: _width,
        height: _height,
        decoration: BoxDecoration(
          color: Color(0xFF08192d),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Color(0xFF08192d),
              Colors.black,
            ],
          ),
        ),
      );
    }

    ///Construye el Widget que maneja el campo de texto para introducir el correo
    ///o el nickname para entrar con una cuenta.
    ///@return un Widget de Container que posee un campo de texto.

    Widget _usuarioWidget() {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: _width/12,
        ),
        child: Theme(
          data: ThemeData(
            primaryColor: Color(0xFFbf930d),
          ),
          child: TextFormField(
            controller: _nombreCorreo,
            style: TextStyle(
              fontSize: _width/27.69230769230769,
              color: Colors.black,
              fontFamily: "Lato",
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFbf930d),
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF929292),
                  width: 2.0,
                ),
              ),
              labelText: 'Introduzca el Correo o Usuario',
              labelStyle: TextStyle(
                color: Color(0xFF929292),
                fontFamily: "Lato",
              ),
              icon: Icon(
                Icons.person_rounded,
                color: Color(0xFF929292),
                size: _width/14.4,
              ),
            ),
            validator: (value) {
              String mensaje;
              value.isEmpty ? mensaje='¡Hey! Te falta llenar esto.'
                  : mensaje=null;
              return mensaje;
            },
          ),
        ),
      );
    }

    ///Construye el Widget que maneja el campo de texto para la clave para entrar
    ///con una cuenta.
    ///@return un Widget de Container que posee un campo de texto.

    Widget _claveWidget() {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: _width/12,
        ),
        child: Theme(
          data: ThemeData(
            primaryColor: Color(0xFFbf930d),
          ),
          child: TextFormField(
            controller: _clave,
            obscureText: true,
            style: TextStyle(
              fontSize: _width/27.69230769230769,
              color: Colors.black,
              fontFamily: "Lato",
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFbf930d),
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF929292),
                  width: 2.0,
                ),
              ),
              labelText: 'Introduzca su Contraseña',
              labelStyle: TextStyle(
                color: Color(0xFF929292),
                fontFamily: "Lato",
              ),
              icon: Icon(
                Icons.lock_open_rounded,
                color: Color(0xFF929292),
                size: _width/14.4,
              ),
            ),
            validator: (value) {
              String mensaje;
              value.isEmpty ? mensaje='¡Hey! Te falta llenar esto.'
                  : mensaje=null;
              return mensaje;
            },
          ),
        ),
      );
    }

    ///Construye el Widget del boton de login del formularo.
    ///@return un Widget de Container que posee un boton.

    Widget _botonLogin() {
      return Container(
        width: _width/6.545454545454545,
        height: _width/6.545454545454545,
        child: ProgressButton.icon(
          iconedButtons: {
            ButtonState.idle: IconedButton(
              icon: Icon(
                Icons.login_rounded,
                color: Colors.white,
              ),
              color: Color(0xFF929292),
            ),
            ButtonState.loading:
            IconedButton(
              text: "Cargando",
              color: Color(0xFF08192d),
            ),
          ButtonState.fail: IconedButton(
              icon: Icon(
                Icons.cancel,
                color: Colors.white,
              ),
            color: Colors.red,
          ),
          ButtonState.success: IconedButton(
            text: "Exito",
            icon: Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
            color: Color(0xFF9BBF63),
          )
        }, onPressed: () {
            _alPresionarBoton();
        },
          state: _estadoBoton,
        ),
      );
    }

    ///Construye el Widget del botón de agregar persona.
    ///@return un Widget de Container que posee un botón.

    Widget _botonAgregarPersona() {
      return Container(
        decoration: BoxDecoration(
          color: Color(0xFF08192d),
          shape: BoxShape.circle,
          border: Border.all(
            color: Color(0xFF08192d),
            width: _width/180,
          ),
        ),
        child: IconButton(
          iconSize: _width/12,
          color: Color(0xFF9BBF63),
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
      );
    }

    ///Construye el Widget del botón de recuperar contraseña.
    ///@return un Widget de Container que posee un botón.

    Widget _botonRecuperarPassword() {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Color(0xFFbf930d),
            width: _width/180,
          ),
        ),
        child: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: SeleccionarIcono(
            "RecuperarContraseña",
            _width/12,
            Color(0xFFbf930d),
          ),
          onPressed: () {
          },
        ),
      );
    }

    ///Construye el Widget de la fila inferior con los botones para registrarse y
    ///recuperar la contraseña.
    ///@return un Widget de Row que posee dos botones.

    Widget _filaRegistro() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget> [
          _botonRecuperarPassword(),
          _botonAgregarPersona(),
        ],
      );
    }

    ///Construye el Widget de la fila que contiene los botones.
    ///@return un Widget de Container que posee una columna.

    Widget _botonesWidget() {
      return Container (
        margin: EdgeInsets.symmetric(horizontal: _width/15),
        alignment: Alignment.center,
        child: Column(
          children: <Widget> [
            _botonLogin(),
            _filaRegistro(),
          ],
        )
      );
    }

    ///Construye el Widget de la carta principal del login.
    ///@return un Widget de Container que posee una carta.

    Widget _cartaLogin() {
      return Container (
        key: _keyList[0],
        margin: EdgeInsets.symmetric(horizontal: _width/15),
        alignment: Alignment.center,
        child: Card(
          color: Colors.white,
          child: Container(
            height: _height/2.262857142857143,
            width: _width/1.2,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _usuarioWidget(),
                  _claveWidget(),
                  _botonesWidget(),
                ],
              ),
            ),
          ),
        ),
      );
    }

    ///Construye el Widget del botón de las tarjetas para retroceder.
    ///@return un Widget de Container que posee un boton.

    Widget _botonAtras() {
      return Container(
        margin: EdgeInsets.only(left: _width/36),
        child: ElevatedButton(
          child: Container (
            width: _width/4.5,
            child: Row (
              children: <Widget> [
                Container (
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: _width/18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Regresar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _width/25.71428571428571,
                    fontFamily: "Lato",
                  ),
                ),
              ],
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Colors.red,
            ),
          ),
          onPressed: () => {
            _irAtras(),
          },
        ),
      );
    }

    ///Construye el Widget del botón de las tarjetas para avanzar.
    ///@return un Widget de Container que posee un boton.

    Widget _botonSiguiente() {
      return Container(
        margin: EdgeInsets.only(right: _width/36),
        child: ElevatedButton(
          child: Container (
            width: _width/4.5,
            child: Row (
              children: <Widget> [
                Text(
                  "Siguiente",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _width/25.71428571428571,
                    fontFamily: "Lato",
                  ),
                ),
                Container (
                  child: Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: _width/18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Color(0xFF9BBF63),
            ),
          ),
          onPressed: () => {
            _irAdelante(),
          },
        ),
      );
    }

    ///Construye el Widget de la fila inferior para los botones
    ///de navegación.
    ///@return un Widget de Row que posee dos botones.

    Widget _barraNavegacion() {
      return Container(
        height: _height/15.84,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget> [
            _botonAtras(),
            _botonSiguiente(),
          ],
        ),
      );
    }

    ///Construye el Widget que maneja el campo de texto para el nombre de un
    ///nuevo usuario.
    ///@return un Widget de Padding que posee un campo de texto.

    Widget _nombreWidget() {
      return Container(
        height: _height/8.8,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: _height/158.4,
            horizontal: _width/28,
          ),
          child: Theme(
            data: ThemeData(
              primaryColor: Color(0xFFbf930d),
            ),
            child: TextFormField(
              controller: _nombre,
              style: TextStyle(
                fontSize: _width/27.69230769230769,
                color: Colors.black,
                fontFamily: "Lato",
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFbf930d),
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF929292),
                    width: 2.0,
                  ),
                ),
                hintText: '¿Cual es tu nombre?',
                hintStyle: TextStyle(
                  color: Color(0xFF929292),
                  fontFamily: "Lato",
                ),
                labelText: 'Ingresa tu Nombre',
                labelStyle: TextStyle(
                  color: Color(0xFF929292),
                  fontFamily: "Lato",
                ),
              ),
              validator: (value) {
                String mensaje;
                value.isEmpty ? mensaje='Ingresa tus nombres.'
                    : mensaje=null;
                return mensaje;
              },
            ),
          ),
        ),
      );
    }

    ///Construye el Widget que maneja el campo de texto para el apellido de un
    ///nuevo usuario.
    ///@return un Widget de Padding que posee un campo de texto.

    Widget _apellidoWidget() {
      return Container(
        height: _height/8.8,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: _height/158.4,
            horizontal: _width/28,
          ),
          child: Theme(
            data: ThemeData(
              primaryColor: Color(0xFFbf930d),
            ),
            child: TextFormField(
              controller: _apellido,
              style: TextStyle(
                fontSize: _width/27.69230769230769,
                color: Colors.black,
                fontFamily: "Lato",
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFbf930d),
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF929292),
                    width: 2.0,
                  ),
                ),
                hintText: '¿Cual es tu apellido?',
                hintStyle: TextStyle(
                  color: Color(0xFF929292),
                  fontFamily: "Lato",
                ),
                labelText: 'Ingresa tu Apellido',
                labelStyle: TextStyle(
                  color: Color(0xFF929292),
                  fontFamily: "Lato",
                ),
              ),
              validator: (value) {
                String mensaje;
                value.isEmpty ? mensaje='Ingresa tus apellidos.'
                    : mensaje=null;
                return mensaje;
              },
            ),
          ),
        ),
      );
    }

    ///Construye el Widget de la carta para agregar los parámetros de nombre y apellido.
    ///@return un Widget de Container que posee una carta.

    Widget _cartaNombApell() {
      return Container (
        key: _keyList[1],
        margin: EdgeInsets.symmetric(horizontal: _width/15),
        alignment: Alignment.center,
        child: Card(
          color: Colors.white,
          child: Container(
            height: _height/3.168,
            width: _width/1.2,
            child: Form(
              key: _formKeyRegisterUno,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: _width/1.285714285714286,
                    height: _height/4.4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: SeleccionarIcono(
                            "Astronauta",
                            _width/12,
                            Color(0xFF929292),
                          ),
                          margin: EdgeInsets.only(
                            left: _width/36,
                          ),
                        ),
                        Container(
                          width: _width/1.5,
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

    ///Construye el Widget que maneja la lista desplegable y seleccionable de los
    ///departamentos.
    ///@return Un Widget de Container con un dropDown.

    Widget _dropDownADMUNO() {
      return Container(
        width: _width/2,
        child: DropdownButton<Territorio>(
          isExpanded: true,
          value: _ADMUNOSeleccionado,
          menuMaxHeight: _height,
          elevation: 16,
          iconEnabledColor: _colorADMUNO,
          underline: Container(
            height: _height/396,
          ),
          onChanged: (Territorio nuevoValor) {
            setState(() {
              _ADMUNOSeleccionado = nuevoValor;
              if (_ADMUNOSeleccionado.nombre != "Error"
                  && _ADMUNOSeleccionado.codigo_admin_uno == null) {
              } else if (_ADMUNOSeleccionado.nombre == "Error"
                  && _ADMUNOSeleccionado.codigo_admin_uno == null) {
              } else {
                _obtenerADMDOS(_ADMUNOSeleccionado);
              }
            });
          },
          items: _ADMUNOLista.map((Territorio territorio) {
            return DropdownMenuItem<Territorio>(
              value: territorio,
              child: Text(
                territorio.nombre,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  color: _colorADMUNO,
                  fontFamily: 'Lato',
                  fontSize: _width/30,
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    ///Construye el Widget que maneja la lista desplegable y seleccionable de las
    ///ciudades.
    ///@return Un Widget de Container con un dropDown.

    Widget _dropDownADMDOS() {
      return Container(
        width: _width/2,
        child: DropdownButton<Territorio>(
          isExpanded: true,
          value: _ADMDOSSeleccionado,
          menuMaxHeight: _height,
          elevation: 16,
          iconEnabledColor: _colorADMDOS,
          underline: Container(
            height: _height/396,
          ),
          onChanged: (Territorio nuevoValor) {
            setState(() {
              _ADMDOSSeleccionado = nuevoValor;
              if (_ADMDOSSeleccionado.nombre != "Error"
                  && _ADMDOSSeleccionado.codigo_admin_dos == null) {
              } else if (_ADMDOSSeleccionado.nombre == "Error"
                  && _ADMDOSSeleccionado.codigo_admin_dos == null) {
              } else {
              }
            });
          },
          items: _ADMDOSLista.map((Territorio territorio) {
            return DropdownMenuItem<Territorio>(
              value: territorio,
              child: Text(
                territorio.nombre,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  color: _colorADMDOS,
                  fontFamily: 'Lato',
                  fontSize: _width/30,
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    ///Construye el Widget del botón para actualizar los departamentos en caso
    ///que no cargue correctamente.
    ///@return un Widget de Container que posee un boton.

    Widget _botonActualizarDepartamento() {
      return Container(
        width: _width/6,
        child: _errorDepartamento ? Container(
          height: _width/7.2,
          width: _width/7.2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: IconButton(
            iconSize: _width/9,
            color: Color(0xFF929292),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(
              Icons.update_rounded,
            ),
            onPressed: () => {
              _obtenerADMUNO(),
            },
          ),
        ) : SeleccionarIcono(
          "Localizacion",
          _width/12,
          Color(0xFF929292),
        ),
      );
    }

    ///Construye el Widget de la carta para agregar los parámetros de departamento y ciudad.
    ///@return un Widget de Container que posee una carta.

    Widget _cartaTerritorio() {
      return Container (
        key: _keyList[2],
        margin: EdgeInsets.symmetric(horizontal: _width/15),
        alignment: Alignment.center,
        child: Card(
          color:Colors.white,
          child: Container(
            height: _height/4.4,
            width: _width/1.2,
            child: Form(
              key: _formKeyRegisterDos,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: _width/1.285714285714286,
                    height: _height/7.92,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _botonActualizarDepartamento(),
                        Container(
                          width: _width/1.636363636363636,
                          child: Column(
                            children: <Widget> [
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

    ///Construye el Widget que maneja el campo de texto para el correo de un
    ///nuevo usuario.
    ///@return un Widget de Padding que posee un campo de texto.

    Widget _correoWidget() {
      return Container(
        height: _height/8.8,
        child:Padding(
          padding: EdgeInsets.symmetric(
            vertical: _height/158.4,
            horizontal: _width/28,
          ),
          child: Theme(
            data: ThemeData(
              primaryColor: Color(0xFFbf930d),
            ),
            child: TextFormField(
              controller: _correo,
              style: TextStyle(
                fontSize: _width/27.69230769230769,
                color: Colors.black,
                fontFamily: "Lato",
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFbf930d),
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF929292),
                    width: 2.0,
                  ),
                ),
                hintText: '¿Cual es tu correo?',
                hintStyle: TextStyle(
                  color: Color(0xFF929292),
                  fontFamily: "Lato",
                ),
                labelText: 'Ingresa tu correo',
                labelStyle: TextStyle(
                  color: Color(0xFF929292),
                  fontFamily: "Lato",
                ),
              ),
              validator: (value) {
                return _errorCorreo;
              },
            ),
          ),
        ),
      );
    }

    ///Construye el Widget que maneja el campo de texto para el telefono de un
    ///nuevo usuario.
    ///@return un Widget de Padding que posee un campo de texto.

    Widget _telefonoWidget() {
      return Container(
        height: _height/8.8,
        child:Padding(
          padding: EdgeInsets.symmetric(
            vertical: _height/158.4,
            horizontal: _width/28,
          ),
          child: Theme(
            data: ThemeData(
              primaryColor: Color(0xFFbf930d),
            ),
            child: TextFormField(
              controller: _telefono,
              style: TextStyle(
                fontSize: _width/27.69230769230769,
                color: Colors.black,
                fontFamily: "Lato",
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFbf930d),
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF929292),
                    width: 2.0,
                  ),
                ),
                hintText: '¿Cual es tu telefono?',
                hintStyle: TextStyle(
                  color: Color(0xFF929292),
                  fontFamily: "Lato",
                ),
                labelText: 'Ingresa tu telefono',
                labelStyle: TextStyle(
                  color: Color(0xFF929292),
                  fontFamily: "Lato",
                ),
              ),
              validator: (value) {
                String mensaje;
                value.isEmpty ? mensaje='Ingresa un numero valido.'
                    : mensaje=null;
                return mensaje;
              },
            ),
          ),
        ),
      );
    }

    ///Construye el Widget de la carta para agregar los parámetros de correo y telefono.
    ///@return un Widget de Container que posee una carta.

    Widget _cartaCorreoTel() {
      return Container (
        key: _keyList[3],
        margin: EdgeInsets.symmetric(horizontal: _width/15),
        alignment: Alignment.center,
        child: Card(
          color:Colors.white,
          child: Container(
            height: _height/3.168,
            width: _width/1.2,
            child: Form(
              key: _formKeyRegisterTres,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: _width/1.285714285714286,
                    height: _height/4.4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: SeleccionarIcono(
                            "Correo",
                            _width/12,
                            Color(0xFF929292),
                          ),
                          margin: EdgeInsets.only(left: _width/360),
                        ),
                        Container(
                          width: _width/1.5,
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

    ///Construye el Widget que maneja el campo de texto para la clave de un
    ///nuevo usuario.
    ///@return un Widget de Padding que posee un campo de texto.

    Widget _introducirClaveWidget() {
      return Container(
        height: _height/8.8,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: _height/158.4,
            horizontal: _width/28,
          ),
          child: Theme(
            data: ThemeData(
              primaryColor: Color(0xFFbf930d),
            ),
            child: TextFormField(
              controller: _ingresarClave,
              style: TextStyle(
                fontSize: _width/27.69230769230769,
                color: Colors.black,
                fontFamily: "Lato",
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFbf930d),
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF929292),
                    width: 2.0,
                  ),
                ),
                hintText: '¡Pon una super clave!',
                hintStyle: TextStyle(
                  color: Color(0xFF929292),
                  fontFamily: "Lato",
                ),
                labelText: 'Ingresa una clave',
                labelStyle: TextStyle(
                  color: Color(0xFF929292),
                  fontFamily: "Lato",
                ),
              ),
              validator: (value) {
                String mensaje;
                value.isEmpty ? mensaje='Ingresa una clave.'
                    : mensaje=_errorIngresarClave;
                return mensaje;
              },
            ),
          ),
        ),
      );
    }

    ///Construye el Widget que maneja el campo de texto para confirmar la clave de un
    ///nuevo usuario.
    ///@return un Widget de Padding que posee un campo de texto.

    Widget _confirmarClaveWidget() {
      return Container(
        height: _height/8.8,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: _height/158.4,
            horizontal: _width/28,
          ),
          child: Theme(
            data: ThemeData(
              primaryColor: Color(0xFFbf930d),
            ),
            child: TextFormField(
              controller: _confirmarClave,
              style: TextStyle(
                fontSize: _width/27.69230769230769,
                color: Colors.black,
                fontFamily: "Lato",
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFbf930d),
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF929292),
                    width: 2.0,
                  ),
                ),
                hintText: '¡Confirma tu super clave!',
                hintStyle: TextStyle(
                  color: Color(0xFF929292),
                  fontFamily: "Lato",
                ),
                labelText: 'Confirma esa clave',
                labelStyle: TextStyle(
                  color: Color(0xFF929292),
                  fontFamily: "Lato",
                ),
              ),
              validator: (value) {
                String mensaje;
                value.isEmpty ? mensaje='Confirma tu clave.'
                    : mensaje=_errorConfirmarClave;
                return mensaje;
              },
            ),
          ),
        ),
      );
    }

    ///Construye el Widget del botón de las tarjetas para enviar la informacion del
    ///nuevo usuario.
    ///@return un Widget de Container que posee un boton.

    Widget _botonRegistrarse() {
      return Container(
        margin: EdgeInsets.only(right: _width/36),
        child: ElevatedButton(
          child: Container (
            width: _width/4.5,
            child: Row (
              children: <Widget> [
                Text(
                  "Registrarse",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _width/25.71428571428571,
                    fontFamily: "Lato",
                  ),
                ),
              ],
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF08192d),),
          ),
          onPressed: () {
            bool clave = _ingresarClave.text.isEmpty ? false : true;
            bool confirmaClave = _confirmarClave.text.isEmpty ? false : true;
            if( clave && confirmaClave ) {
              if( _ingresarClave.text  == _confirmarClave.text) {
                _errorIngresarClave = null;
                _errorConfirmarClave = null;
                _alPresionarRegistrar();
                _actualIndex = 0;
                _keyActual = _keyList[0];
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
                });
              } else {
                _errorIngresarClave = 'No coincide con la de abajo.';
                _errorConfirmarClave = 'No coincide con la de arriba.';
              }
            }
            _formKeyRegisterCuatro.currentState.validate();
          },
        ),
      );
    }

    ///Construye el Widget de la fila inferior para los botones
    ///de navegación sustituyendo el boton de siguiente por el de registrarse.
    ///@return un Widget de Row que posee dos botones.

    Widget _barraNavegacionFinal() {
      return Container(
        height: _height/15.84,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget> [
            _botonAtras(),
            _botonRegistrarse(),
          ],
        ),
      );
    }

    ///Construye el Widget de la carta para agregar los parámetros de la clave.
    ///@return un Widget de Container que posee una carta.

    Widget _cartaClave() {
      return Container (
        key: _keyList[4],
        margin: EdgeInsets.symmetric(horizontal: _width/15),
        alignment: Alignment.center,
        child: Card(
          color: Colors.white,
          child: Container(
            height: _height/3.168,
            width: _width/1.2,
            child: Form(
              key: _formKeyRegisterCuatro,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: _width/1.285714285714286,
                    height: _height/4.4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Icon(
                            Icons.vpn_key_rounded,
                            color: Color(0xFF929292),
                            size: _width/12,
                          ),
                          margin: EdgeInsets.only(left: _width/36),
                        ),
                        Container(
                          width: _width/1.5,
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

    Widget _listaCartas() {
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
                      margin: EdgeInsets.only(top:_height/14.94339622,),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF08192d),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      height: _height/3.6,
                      width: _width/1.636363636363636,
                    ),
                    Container (
                      margin: EdgeInsets.only(top:_height/14.94339622),
                      height: _height/4.4,
                      width: _width/2,
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
                  margin: EdgeInsets.only(top: _height/39.6),
                  alignment: Alignment.center,
                  height: _height/1.98,
                  width: _width,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget> [
                      _cartaLogin(),
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
      child: Scaffold(
        backgroundColor: Color(0xFFECEFF1),
        body: Scaffold(
          body: Stack(children: <Widget>[
            _fondo(),
            _listaCartas(),
          ]),
        ),
      ),
    );
  }
}