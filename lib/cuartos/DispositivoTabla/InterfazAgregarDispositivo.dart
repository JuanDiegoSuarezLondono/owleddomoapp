import 'package:flutter/material.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/ServiciosDispositivo.dart';
import 'package:owleddomoapp/shared/PopUpImagenes.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/shared/TratarError.dart';
import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:flutter_particles/particles.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:owleddomoapp/login/Persona.dart';

///Esta clase se encarga de manejar la pantalla del formulario para agregar un dispositivo.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param usuario identificador del usuario.
///@see owleddomo_app/cuartos/DispositivoTabla/DispositivosLista.dart#class().
///@return un Widget Stack con el fondo animado y un formulario.

class InterfazAgregarDispositivo extends StatefulWidget {

  final Persona usuario; //Identificador del usuario.
  InterfazAgregarDispositivo(this.usuario); //Constructor de la clase.

  @override
  State<StatefulWidget> createState() {
    return _InterfazAgregarDispositivo(usuario); //Crea un estado mutable del Widget.
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

class _InterfazAgregarDispositivo extends State<InterfazAgregarDispositivo> {

  final _formKey = GlobalKey<FormState>(); //Llave identificadora del formulario.
  final Persona _usuario; //Identificador del usuario.
  _InterfazAgregarDispositivo(this._usuario); //Constructor de la clase.

  String _qrResultado; //Texto recuperado del código QR.
  String _textoBotonQR; //Texto del botón para escanear el código QR.
  TextEditingController _nombre; //Controlador del campo de texto para el nombre.
  String _imagen; //Path de la imagen para el dispositivo.
  Color _bordeImagen; //Color del borde del botón para seleccionar imagen.
  Color _bordeQR; //Color del borde del botón para escanear el código QR.
  Color _letrasEscanealo; //Color de las letras del botón para escanear el código QR.
  ButtonState _estadoBoton; //Estado entre las transiciones del botón.

  @override

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState();
    _nombre = TextEditingController();
    _qrResultado = "Vacio"; //Se indica que al inicio no hay codigo qr.
    _textoBotonQR = "¡Escanealo!";
    _imagen = null; //Se indica que no hay imagen por parte de la lista.
    _bordeImagen = PaletaColores(_usuario).obtenerColorInactivo();
    _bordeQR = PaletaColores(_usuario).obtenerColorInactivo();
    _letrasEscanealo = PaletaColores(_usuario).obtenerPrimario();
    _estadoBoton = ButtonState.idle;
  }

  ///Controla los diferentes colores en los botones de selección de imagen y
  ///escaneo de código QR mediante la validación de sus respectivos campos.

  _validar() {
    setState(() {
      _bordeImagen = _imagen == null ? PaletaColores(_usuario).obtenerColorRiesgo()
                                     : PaletaColores(_usuario).obtenerColorInactivo();
      if (_qrResultado == "Vacio") {
        _bordeQR = PaletaColores(_usuario).obtenerColorRiesgo();
        _letrasEscanealo = PaletaColores(_usuario).obtenerColorRiesgo();
        _textoBotonQR = "¡Escanealo!";
      } else {
        _bordeQR = PaletaColores(_usuario).obtenerCuaternario();
        _letrasEscanealo = PaletaColores(_usuario).obtenerCuaternario();
        _textoBotonQR = "¡Perfecto!";
      }
    });
  }

  ///Controla la selección de la imagen mediante la lista predeterminada para el dispositivo.

  _seleccionarImagen(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return PopUpImagenes("dispositivos",_usuario);
      },
    ).then((value) => {
      if (mounted) {
        setState(() {
          value == null ? _imagen = null : _imagen = value;
        })
      },
    });
  }

  ///Agrega el dispositivo o genera un error en caso de cualquier eventualidad.
  ///@see owleddomo_app/cuartos/DisporitivoTabla/ServiciosDispositivo.agregarDispositivo#method().
  ///@see owleddomo_app/shared/TratarError.estadoServicioActualizar#method().
  ///@return no retorna nada en caso de no obtener una validación positiva de los campos.

  _agregarDispositivo() {
    ServiciosDispositivo.agregarDispositivo( _qrResultado, _usuario.persona_id,
                                             _nombre.text, _imagen)
        .then((result) {

      String respuesta = TratarError(_usuario).tarjetaDeEstado(result,[_nombre.text,_imagen]
                                                      ,context).first.toString();
      if(mounted) {
        if ( respuesta == "2") {
          setState(() {
            _estadoBoton = ButtonState.success;
          });
        } else {
          setState(() {
            _bordeQR = PaletaColores(_usuario).obtenerColorRiesgo();
            _letrasEscanealo = PaletaColores(_usuario).obtenerColorRiesgo();
            _textoBotonQR = "Ya en uso";
            _estadoBoton = ButtonState.fail;
          });
        }
      }
    });
  }

  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    ///Construye el Widget que maneja las animaciones de partículas del fondo.
    ///@return un Widget de Particles que contiene la animación del fondo.

    Widget _particulas() {
      return Particles(
        20,
        PaletaColores(_usuario).obtenerCuaternario(),
      );
    }

    ///Construye el Widget que maneja el campo para seleccionar la imagen.
    ///@return un Widget de Padding que contiene un botón seleccionador de imágenes.

    Widget _seleccionarImagenWidget() {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: _height/52.8,
        ),
        child: InkWell(
        onTap: () {
          _seleccionarImagen(context);
        },
          child: Container(
            child: _imagen != null
                ? Container(
              width: _height/5.28,
              height: _height/5.28,
              decoration: BoxDecoration(
                border: Border.all(
                  color: PaletaColores(_usuario).obtenerCuaternario(),
                  width: _height/300,
                ),
                color: PaletaColores(_usuario).obtenerCuaternario(),
                borderRadius: BorderRadius.circular(150),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(_imagen),
                ),
              ),
            )
              : Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: _bordeImagen,
                  width: _height/300,
                ),
                color: PaletaColores(_usuario).obtenerContrasteInactivo(),
                borderRadius: BorderRadius.circular(150),
              ),
              width: _width/2.25,
              height: _height/4.95,
              child: Icon(
                Icons.image,
                size: _height/8.0923,
                color: PaletaColores(_usuario).obtenerColorInactivo(),
              ),
            ),
          ),
        ),
      );
    }

    ///Construye el Widget que contiene el botón para escanear el código QR y el texto
    ///que indica el estado del escaneo.
    ///@return un Widget de Container que contiene un botón y un texto.

    Widget _escanearProducto() {
      return Container(
        height: _height/4.95,
        width: _width/2.25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: PaletaColores(_usuario).obtenerPrimario(),
                padding: EdgeInsets.all(_height/39.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () async {
                String codeSanner = await BarcodeScanner.scan();
                setState(() {
                  _qrResultado = codeSanner;
                  _validar();
                });
              },
              child: Icon(
                Icons.qr_code_scanner_rounded,
                size: _height/15.84,
                color: PaletaColores(_usuario).obtenerTerciario(),
              ),
            ),
            Text(
              _textoBotonQR,
              style: TextStyle(
                fontFamily: "lato",
                fontSize: _height/39.6,
                color: _letrasEscanealo,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    ///Construye el Widget de la carta para contener el botón y el texto del
    ///escaño del producto.
    ///@return un Widget de Padding que contiene una carta.

    Widget _tarjetaEscanearProducto() {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: _height/31.68,
        ),
        child: Card(
        shape: BeveledRectangleBorder(
          side: BorderSide(
            color: _bordeQR,
            width: _height/528,
          ),
          borderRadius: BorderRadius.circular(25.0),
        ),
          color: PaletaColores(_usuario).obtenerLetraContrastePrimario(),
          child: _escanearProducto(),
        ),
      );
    }

    ///Construye el Widget que maneja el campo para introducir el nombre del dispositivo.
    ///@return un Widget de Padding que contiene un campo de texto.

    Widget _nombreWidget() {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: _height/158.4,
          horizontal: _width/12,
        ),
        child: Theme(
          data: ThemeData(
            primaryColor: PaletaColores(_usuario).obtenerCuaternario(),
          ),
          child: TextFormField(
            controller: _nombre,
            style: TextStyle(
              color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
              fontFamily: "Lato",
            ),
            maxLength: 50,
            decoration: InputDecoration(
              filled: true,
              fillColor: PaletaColores(_usuario).obtenerSecundario(),
              border: const OutlineInputBorder(),
              counterStyle: TextStyle(
                color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
                fontFamily: "Lato",
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: PaletaColores(_usuario).obtenerCuaternario(),
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: PaletaColores(_usuario).obtenerColorInactivo(),
                  width: 2.0,
                ),
              ),
              hintText: '¿Como va a llamar a este dispositivo?',
              hintStyle: TextStyle(
                color: PaletaColores(_usuario).obtenerColorInactivo(),
                fontFamily: "Lato",
              ),
              labelText: 'Nombre',
              labelStyle: TextStyle(
                color: PaletaColores(_usuario).obtenerColorInactivo(),
                fontFamily: "Lato",
              ),
            ),
            autofocus: true,
            validator: (value) {
              _validar();
              String mensaje;
              value.isEmpty ? mensaje='¡Espera!... Debes ponerle un nombre.'
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
      if ( _qrResultado == "Vacio" || _usuario.persona_id.isEmpty
          || _nombre.text.isEmpty || _imagen == null) {
        if (_estadoBoton == ButtonState.fail) {
          setState(() {
            _estadoBoton = ButtonState.idle;
          });
          return;
        }
        _validar();
        return;
      }
      switch (_estadoBoton) {
        case ButtonState.idle:
          _estadoBoton = ButtonState.loading;
          _agregarDispositivo();
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
      if(mounted) {
        setState(() {
          _estadoBoton = _estadoBoton;
        });
      }
    }

    ///Construye el Widget que maneja el botón para suministrar los datos del formulario.
    ///@return un Widget de Container que contiene un botón.

    Widget _boton() {
      return Container(
        width: _width/3.6,
        child: ProgressButton.icon(
            textStyle: TextStyle(
              color: PaletaColores(_usuario).obtenerContrasteInactivo(),
            ),
            iconedButtons: {
              ButtonState.idle: IconedButton(
                text: "Enviar",
                icon: Icon(
                  Icons.send,
                  color: PaletaColores(_usuario).obtenerContrasteInactivo(),
                ),
                color: PaletaColores(_usuario).obtenerColorInactivo(),
              ),
              ButtonState.loading: IconedButton(
                text: "Cargando",
                color: PaletaColores(_usuario).obtenerPrimario(),
              ),
              ButtonState.fail: IconedButton(
                icon: Icon(
                  Icons.cancel,
                  color: PaletaColores(_usuario).obtenerContrasteRiesgo(),
                ),
                color: PaletaColores(_usuario).obtenerColorRiesgo(),
              ),
              ButtonState.success: IconedButton(
              text: "Exito",
              icon: Icon(
                Icons.check_circle,
                color: PaletaColores(_usuario).obtenerContrasteRiesgo(),
              ),
                color: PaletaColores(_usuario).obtenerTerciario(),
              ),
            }, onPressed: () {
          if (_formKey.currentState.validate()) {
            _alPresionarBoton();
          } else if (_estadoBoton == ButtonState.fail) {
            _estadoBoton = ButtonState.idle;
          }
        },
            state: _estadoBoton),
      );
    }

    ///Construye el Widget que contiene en una fila el botón para escanear un código
    ///QR y el botón para seleccionar una imagen.
    ///@return un Widget de Padding que contiene una fila.

    Widget _filaSuperiror() {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: _height/52.8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _tarjetaEscanearProducto(),
            _seleccionarImagenWidget(),
          ],
        ),
      );
    }

    ///Construye el Widget que contiene todos los elementos del formulario.
    ///@return un Widget de Padding que contiene un ListView con el formulario.

    Widget _pantallaFrontal() {
      return Padding(
        padding: EdgeInsets.only(
          top: _height/14.94339622,
        ),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _filaSuperiror(),
                  _nombreWidget(),
                  _boton(),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        Container(
          color: PaletaColores(_usuario).obtenerColorFondo(),
          height: _height/1.161290322580645,
          child: Stack(
            children: <Widget>[
              _particulas(),
              _pantallaFrontal(),
            ],
          ),
        ),
      ],
    );
  }
}