import 'package:flutter/material.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/ServiciosDispositivo.dart';
import 'package:owleddomoapp/shared/PopUpImagenes.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/shared/TratarError.dart';
import 'package:flutter_particles/particles.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

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
  final Persona usuario; //Identificador del usuario.
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
  final Persona _usuario; //Identificador del usuario.
  _InterfazEditarDispositivo(this._relacionId,this._nombre, this._pathFoto, this._usuario); //Constructor de la clase.

  TextEditingController _nombreCampo; //Controlador del campo para el nombre en el formulario.
  Color _bordeImagen; //Controlador del color del borde del contenedor de la imagen.
  ButtonState _estadoBoton; //Estado entre las transiciones del botón.

  @override

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState();
    _nombreCampo = TextEditingController(text: _nombre);//Asigna el actual nombre al campo de texto.
    _bordeImagen = PaletaColores(_usuario).obtenerColorInactivo();
    _estadoBoton = ButtonState.idle;
  }

  ///Cambia el color del borde del contenedor de la imagen dependiendo de si hay
  ///una imagen cargada o no.

  _validar() {
    if(mounted) {
      setState(() {
        _bordeImagen = _pathFoto == null ? PaletaColores(_usuario).obtenerColorRiesgo()
                                         : PaletaColores(_usuario).obtenerColorInactivo();
      });
    }
  }

  ///Controla la selección de la imagen mediante la lista predeterminada para el dispositivo.

  _seleccionarImagen(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return PopUpImagenes("dispositivos", _usuario);
      },
    ).then((value) => {
      if (mounted) {
        setState(() {
          _bordeImagen = value == null ? PaletaColores(_usuario).obtenerColorRiesgo()
                                       : PaletaColores(_usuario).obtenerCuaternario();
          value == null ? _pathFoto= null : _pathFoto = value;
        })
      },
    });
  }

  ///Actualiza el dispositivo o genera un error en caso de cualquier eventualidad.
  ///@see owleddomo_app/cuartos/DisporitivoTabla/ServiciosDispositivo.actualizarDispositivo#method().
  ///@see owleddomo_app/shared/TratarError.estadoServicioActualizar#method().
  ///@return no retorna nada en caso de no obtener una validación positiva de los campos.

  _actualizarDispositivo() {
    ServiciosDispositivo.actualizarDispositivo(_relacionId, _usuario.persona_id,
                                               _nombreCampo.text,_pathFoto)
        .then((result) {
      String respuesta = TratarError(_usuario).tarjetaDeEstado( result, [_nombreCampo.text,
                         _pathFoto], context).first.toString();
      if(mounted) {
        if ( respuesta == "2") {
          setState(() {
            _estadoBoton = ButtonState.success;
          });
        } else {
          setState(() {
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
                  color: PaletaColores(_usuario).obtenerCuaternario(),
                  width: _height/300,
                ),
                color: PaletaColores(_usuario).obtenerCuaternario(),
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
            primaryColor: PaletaColores(_usuario).obtenerCuaternario(),
          ),
          child: TextFormField(
            controller: _nombreCampo,
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
      if ( (_nombreCampo.text.isEmpty || _usuario.persona_id.isEmpty || _pathFoto == null) && mounted) {
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
              color: PaletaColores(_usuario).obtenerLetraContrastePrimario(),
            ),
            iconedButtons: {
              ButtonState.idle: IconedButton(
                text: "Enviar",
                icon: Icon(
                  Icons.send,
                  color: PaletaColores(_usuario).obtenerLetraContrastePrimario(),
                ),
                color: PaletaColores(_usuario).obtenerColorInactivo(),
              ),
              ButtonState.loading:
              IconedButton(
                text: "Cargando",
                color: PaletaColores(_usuario).obtenerPrimario(),
              ),
              ButtonState.fail: IconedButton(
                icon: Icon(
                  Icons.cancel,
                  color: PaletaColores(_usuario).obtenerLetraContrastePrimario(),
                ),
                color: PaletaColores(_usuario).obtenerColorRiesgo(),
              ),
              ButtonState.success: IconedButton(
                text: "Exito",
                icon: Icon(
                  Icons.check_circle,
                  color: PaletaColores(_usuario).obtenerLetraContrastePrimario(),
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