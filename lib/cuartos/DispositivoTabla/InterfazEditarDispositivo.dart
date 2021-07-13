import 'package:flutter/material.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/ServiciosDispositivo.dart';
import 'package:owleddomoapp/shared/PopUpImagenes.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/shared/TratarError.dart';
import 'package:flutter_particles/particles.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

final PaletaColores colores = new PaletaColores(); //Colores predeterminados.
final TratarError tratarError = new TratarError(); //Respuestas predeterminadas a las API.

///Esta clase se encarga de manejar la interfaz con el formulario para editar el
///dispositivo suministrado.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param relacionId identificador del producto.
///@param nombre nombre del dispositivo.
///@param pathFoto path de la imagen del dispositivo.
///@param usuario identificador del usuario.
///@see owleddomo_app/cuartos/DispositivoTabla/InterfazInformacionDispositivo.dart#class().
///@return un Widget Stack con un formulario para cambiar la imagen o el nombre
///de un dispositivo.

class InterfazEditarDispositivo extends StatefulWidget {

  final String relacionId; //Identificador del producto.
  final String nombre; //Nombre del dispositivo.
  final String pathFoto; //Path de la imagen del dispositivo.
  final String usuario; //Identificador del usuario.
  InterfazEditarDispositivo(this.relacionId, this.nombre, this.pathFoto, this.usuario) : super(); //Constructor de la clase.

  @override
  _InterfazEditarDispositivo createState() => _InterfazEditarDispositivo(relacionId, nombre, pathFoto, usuario); //Crea un estado mutable del Widget.

}

///Esta clase se encarga de formar un estado mutable de la clase “InterfazEditarDispositivo”.
///@param _formKey identificador del formulario.
///@param _relacionId identificador del producto.
///@param _nombre nombre del dispositivo.
///@param _pathFoto path de la imagen del dispositivo.
///@param _usuario identificador del usuario.
///@param _nombreCampo controlador del campo para el nombre en el formulario.
///@param _bordeImagen controlador del color del borde del contenedor de la imagen.
///@param _width obtiene el ancho de la pantalla del dispositivo.
///@param _height obtiene el alto de la pantalla del dispositivo.

class _InterfazEditarDispositivo extends State<InterfazEditarDispositivo> {

  final _formKey = GlobalKey<FormState>(); //Identificador del formulario.
  final String _relacionId; //Identificador del producto.
  String _nombre; //Nombre del dispositivo.
  String _pathFoto; //Path de la imagen del dispositivo.
  final String _usuario; //Identificador del usuario.
  _InterfazEditarDispositivo(this._relacionId,this._nombre, this._pathFoto, this._usuario); //Constructor de la clase.

  TextEditingController _nombreCampo; //Controlador del campo para el nombre en el formulario.
  Color _bordeImagen; //Controlador del color del borde del contenedor de la imagen.
  ButtonState _estadoBoton; //Estado entre las transiciones del botón.

  @override

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState();
    _nombreCampo = TextEditingController(text: _nombre);//Asigna el actual nombre al campo de texto.
    _bordeImagen = PaletaColores().obtenerColorInactivo();
    _estadoBoton = ButtonState.idle;
  }

  ///Cambia el color del borde del contenedor de la imagen dependiendo de si hay
  ///una imagen cargada o no.

  _validar() {
    setState(() {
      _bordeImagen = _pathFoto == null ? PaletaColores().obtenerColorRiesgo()
                                       : PaletaColores().obtenerColorInactivo();
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
          _bordeImagen = value == null ? PaletaColores().obtenerColorRiesgo()
                                       : PaletaColores().obtenerCuaternario();
          value == null ? _pathFoto= null : _pathFoto = value;
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

    ///Construye el Widget que maneja el campo para seleccionar la imagen, así como
    ///su lógica en caso no encontrar la imagen que ya tiene el dispositivo,
    ///si el campo está vacío o al cargar una nueva imagen.
    ///@return un Widget de Padding que contiene un botón seleccionador de imágenes.

    Widget _seleccionarImagenWidget() {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: _height/52.8,
        ),
        child: GestureDetector(
          onTap: () {
            _seleccionarImagen(context);
          },
          child: Container(
            child: _pathFoto != null
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
                  image: AssetImage(_pathFoto),
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

    ///Construye el Widget que maneja el campo para introducir el nombre editado
    ///del dispositivo.
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
            controller: _nombreCampo,
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

    ///Actualiza el dispositivo o genera un error en caso de cualquier eventualidad.
    ///@see owleddomo_app/cuartos/DisporitivoTabla/ServiciosDispositivo.actualizarDispositivo#method().
    ///@see owleddomo_app/shared/TratarError.estadoServicioActualizar#method().
    ///@return no retorna nada en caso de no obtener una validación positiva de los campos.

    _actualizarDispositivo() {
      ServiciosDispositivo.actualizarDispositivo(_relacionId, _usuario,
                                                 _nombreCampo.text,_pathFoto)
          .then((result) {
            String respuesta = tratarError.estadoServicioActualizar( result, [_nombreCampo.text, _pathFoto], context);
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

    ///Maneja el comportamiento al presionar el botón.
    ///@return un retorno vaico.

    void _alPresionarBoton() {
      if ( _nombreCampo.text.isEmpty || _usuario.isEmpty || _pathFoto == null) {
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
          _actualizarDispositivo();
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
          } else if (_estadoBoton == ButtonState.fail) {
            _estadoBoton = ButtonState.idle;
          }
        },
            state: _estadoBoton),
      );
    }

    ///Construye el Widget que contiene todos los componentes para el formulario.
    ///@return un Widget de Padding que contiene el formulario.

    Widget _pantallaFrontal() {
      return Padding(
        padding: EdgeInsets.only(
          top: _height/14.94339622,
        ),
        child: ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _seleccionarImagenWidget(),
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