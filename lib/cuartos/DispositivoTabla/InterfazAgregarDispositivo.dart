import 'package:flutter/material.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/ServiciosDispositivo.dart';
import 'package:owleddomoapp/shared/PopUpImagenes.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/shared/TratarError.dart';
import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:flutter_particles/particles.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

final PaletaColores colores = new PaletaColores(); //Colores predeterminados.
final TratarError tratarError = new TratarError(); //Respuestas predeterminadas a las API.

///Esta clase se encarga de manejar la pantalla del formulario para agregar un dispositivo.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param usuario identificador del usuario.
///@see owleddomo_app/cuartos/DispositivoTabla/DispositivosLista.dart#class().
///@return un Widget Stack con el fondo animado y un formulario.

class InterfazAgregarDispositivo extends StatefulWidget {

  final String usuario; //Identificador del usuario.
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
  final String _usuario; //Identificador del usuario.
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
    _bordeImagen = colores.obtenerColorInactivo();
    _bordeQR = colores.obtenerColorDos();
    _letrasEscanealo = colores.obtenerColorInactivo();
    _estadoBoton = ButtonState.idle;
  }

  ///Controla los diferentes colores en los botones de selección de imagen y
  ///escaneo de código QR mediante la validación de sus respectivos campos.

  _validar() {
    setState(() {
      _bordeImagen = _imagen == null ? colores.obtenerColorRiesgo()
                                     : colores.obtenerColorInactivo();
      if (_qrResultado == "Vacio") {
        _bordeQR = colores.obtenerColorRiesgo();
        _letrasEscanealo = colores.obtenerColorRiesgo();
        _textoBotonQR = "¡Escanealo!";
      } else {
        _bordeQR = colores.obtenerColorCuatro();
        _letrasEscanealo = colores.obtenerColorCuatro();
        _textoBotonQR = "¡Perfecto!";
      }
    });
  }

  ///Controla la selección de la imagen mediante la lista predeterminada para el dispositivo.

  _seleccionarImagen(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return PopUpImagenes("dispositivos");
      },
    ).then((value) => {
      if (mounted) {
        setState(() {
          value == null ? _imagen = null : _imagen = value;
        })
      },
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
        colores.obtenerColorCuatro(),
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
                  color: colores.obtenerColorCuatro(),
                  width: _height/300,
                ),
                color: colores.obtenerColorCuatro(),
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
                color: colores.obtenerColorDos(),
                borderRadius: BorderRadius.circular(150),
              ),
              width: _width/2.25,
              height: _height/4.95,
              child: Icon(
                Icons.image,
                size: _height/8.0923,
                color: colores.obtenerColorInactivo(),
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
                primary: colores.obtenerColorUno(),
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
                color: colores.obtenerColorTres(),
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
          color: colores.obtenerColorDos(),
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
            primaryColor: colores.obtenerColorCuatro(),
          ),
          child: TextFormField(
            controller: _nombre,
            maxLength: 50,
            decoration: InputDecoration(
              filled: true,
              fillColor: colores.obtenerColorDos(),
              border: const OutlineInputBorder(),
              hintText: '¿Como va a llamar a este dispositivo?',
              labelText: 'Nombre',
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

    ///Agrega el dispositivo o genera un error en caso de cualquier eventualidad.
    ///@see owleddomo_app/cuartos/DisporitivoTabla/ServiciosDispositivo.agregarDispositivo#method().
    ///@see owleddomo_app/shared/TratarError.estadoServicioActualizar#method().
    ///@return no retorna nada en caso de no obtener una validación positiva de los campos.

    _agregarDispositivo() {
      ServiciosDispositivo.agregarDispositivo( _qrResultado, _usuario,
                                               _nombre.text, _imagen)
          .then((result) {
            String respuesta = tratarError.estadoServicioActualizar( result, [_nombre.text, _imagen] , context);
            if ( respuesta == "EXITO") {
              setState(() {
                _estadoBoton = ButtonState.success;
              });
            } else {
              setState(() {
                _bordeQR = colores.obtenerColorRiesgo();
                _letrasEscanealo = colores.obtenerColorRiesgo();
                _textoBotonQR = "Ya en uso";
                _estadoBoton = ButtonState.fail;
              });
            }
          });
    }

    ///Maneja el comportamiento al presionar el botón.
    ///@return un retorno vaico.

    void _alPresionarBoton() {
      if ( _qrResultado == "Vacio" || _usuario.isEmpty
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
      setState(() {
        _estadoBoton = _estadoBoton;
      });
    }

    ///Construye el Widget que maneja el botón para suministrar los datos del formulario.
    ///@return un Widget de Container que contiene un botón.

    Widget _boton() {
      return Container(
        width: _width/3.6,
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
          if (_formKey.currentState.validate()) {
            _alPresionarBoton();
          } else if (_estadoBoton == ButtonState.fail){
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

    return Stack(
      children: <Widget>[
        _particulas(),
        _pantallaFrontal(),
      ],
    );
  }
}