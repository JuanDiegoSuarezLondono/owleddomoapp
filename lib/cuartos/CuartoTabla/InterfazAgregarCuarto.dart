import 'dart:io';
import 'package:flutter/material.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'package:owleddomoapp/cuartos/CuartoTabla/ServiciosCuarto.dart';
import 'package:owleddomoapp/shared/PopUpImagenes.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/shared/TratarError.dart';
import 'package:owleddomoapp/shared/FondoCubo.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:image_picker/image_picker.dart';

///Esta clase se encarga de manejar la pantalla del formulario para agregar un cuarto.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param usuario identificador del usuario.
///@see owleddomo_app/cuartos/CuartoTable/CuartosLista.dart#class().
///@return Un Widget ListView con el fondo animado y un formulario.

class InterfazAgregarCuarto extends StatefulWidget {

  final Persona usuario; //Identificador del usuario.
  InterfazAgregarCuarto(this.usuario); //Constructor de la clase.

  @override
  State<StatefulWidget> createState() {
    return _InterfazAgregarCuarto(usuario); //Crea un estado mutable del Widget.
  }

}

///Esta clase se encarga de formar un estado mutable de la clase “InterfazAgregarCuarto”.
///@param _formKey Llave identificadora del formulario.
///@param _usuario identificador del usuario.
///@param _imagen imagen seleccionada de la lista.
///@param _imagenCamara imagen seleccionada con la camara.
///@param _imagenFinal imagen final del cuarto.
///@param _bordeImagen color del borde del botón para seleccionar imagen.
///@param _nombreColor color del borde del nombre.
///@param _descripcionColor color del borde de la descripción.
///@param _nombre controlador del campo de texto para el nombre.
///@param _descripcion controlador del campo de texto para la descripción.
///@param _estadoBoton Estado entre las transiciones del botón.
///@param _width obtiene el ancho de la pantalla del dispositivo.
///@param _height obtiene el alto de la pantalla del dispositivo.

class _InterfazAgregarCuarto extends State<InterfazAgregarCuarto> {

  final _formKey = GlobalKey<FormState>(); //Llave identificadora del formulario.
  final Persona _usuario; //Identificador del usuario.
  _InterfazAgregarCuarto(this._usuario); //Constructor de la clase.

  String _imagen; //Imagen seleccionada de la lista.
  File _imagenCamara; //Imagen seleccionada con la camara.
  String _imagenFinal; //Imagen final del cuarto.
  Color _bordeImagen; //Color del borde del botón para seleccionar imagen.
  TextEditingController _nombre; //Controlador del campo de texto para el nombre.
  TextEditingController _descripcion; //Controlador del campo de texto para la descripción.
  ButtonState _estadoBoton; //Estado entre las transiciones del botón.

  @override

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState();
    _imagen = null; //Se indica que no hay imagen por parte de la lista.
    _imagenCamara = null; //Se indica que no hay imagen por parte de la camara.
    _imagenFinal = null; //Se indica que no hay imagen.
    _bordeImagen = PaletaColores(_usuario).obtenerColorInactivo();
    _nombre = TextEditingController();
    _descripcion = TextEditingController();
    _estadoBoton = ButtonState.idle;
  }

  ///Controla la selección de la imagen mediante la lista predeterminada para el cuarto.

  _seleccionarImagen(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return PopUpImagenes("cuartos",_usuario);
      },
    ).then((value) => {
      if (mounted) {
        setState(() {
          _imagenCamara = null;
          value != null ? _imagen = value : _imagen = null;
          _bordeImagen = value != null ?  PaletaColores(_usuario).obtenerCuaternario()
                                       :  PaletaColores(_usuario).obtenerColorRiesgo();
        })
      },
    });
  }

  ///Abre un selector para poder guardar una imagen de la galería del móvil.
  ///@param imagen imagen seleccionada de la galeria.

  _imagenGaleria() async {
    final selector = ImagePicker();
    var imagen = await selector.getImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    ); //Imagen seleccionada.
    setState(() {
      if(imagen != null) {
        File archivoImagen = File(imagen.path);
        _imagenCamara = archivoImagen;
        _bordeImagen = PaletaColores(_usuario).obtenerCuaternario();
      } else {
        _bordeImagen = PaletaColores(_usuario).obtenerColorRiesgo();
        _imagenCamara = null;
      }
      _imagen = null;
    });
  }

  ///Agrega el cuarto o genera un error en caso de cualquier eventualidad.
  ///@see owleddomo_app/cuartos/CuartoTabla/ServiciosCuarto.agregarCuarto#method().
  ///@see owleddomo_app/shared/TratarError.estadoServicioActualizar#method().
  ///@return No retorna nada en caso de no obtener una validación positiva de los campos.

  _agregarCuarto() {
    ServiciosCuarto.agregarCuarto(_usuario.persona_id, _nombre.text, _imagenFinal, _descripcion.text)
        .then((result) {

      String respuesta = TratarError(_usuario).tarjetaDeEstado( result, [_imagenFinal, _nombre.text,
                                                      _descripcion.text], context).first.toString();

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

    ///Construye el Widget que maneja el campo para seleccionar la imagen mediante la galeria.
    ///@return Un Widget de Padding que contiene un botón seleccionador de imagenes de la galeria.

    Widget _camara() {
      return Padding(
        padding: EdgeInsets.only(
          top: _height/26.4,
          left: _width/1.714285714285714,
        ),
        child: GestureDetector(
          onTap: () {
            _imagenGaleria();
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: PaletaColores(_usuario).obtenerColorInactivo(),
                width: _height/300,
              ),
              color: PaletaColores(_usuario).obtenerContrasteInactivo(),
              borderRadius: BorderRadius.circular(150),
            ),
            height: _height/11.31428571428571,
            width: _height/11.31428571428571,
            child: Icon(
              Icons.camera_alt_rounded,
              size: _height/22.62857142857143,
              color: PaletaColores(_usuario).obtenerColorInactivo(),
            ),
          ),
        ),
      );
    }

    ///Construye el Widget que maneja el campo para seleccionar la imagen mediante la lista predeterminada,
    ///ademas muestra la imagen actualmente seleccionada.
    ///@return Un Widget de Padding que contiene un botón seleccionador de imagenes predeterminadas.

    Widget _imagenWidget() {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: _height/52.8,
        ),
        child: InkWell(
          onTap: () {
            _seleccionarImagen(context);
            },
          child: (_imagen != null || _imagenCamara != null) ?
          Container(
            width: _height/3.96,
            height: _height/3.96,
            decoration: BoxDecoration(
              border: Border.all(
                color: _bordeImagen,
                width: _height/300,
              ),
              color: PaletaColores(_usuario).obtenerSecundario(),
              borderRadius: BorderRadius.circular(150),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: _imagenCamara == null  ?
                       AssetImage(_imagen) :
                       FileImage(_imagenCamara)
              ),
            ),
          ) :
          Container(
            width: _height/3.96,
            height: _height/3.96,
            decoration: BoxDecoration(
              border: Border.all(
                color: _bordeImagen,
                width: _height/300,
              ),
              color: PaletaColores(_usuario).obtenerContrasteInactivo(),
              borderRadius: BorderRadius.circular(150),
            ),
            child: Icon(
              Icons.image,
              size: _height/6.6,
              color: PaletaColores(_usuario).obtenerColorInactivo(),
            ),
          ),
        ),
      );
    }

    ///Construye el Widget que maneja el campo para introducir el nombre del cuarto.
    ///@return Un Widget de Padding que contiene un campo de texto.

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
              hintText: '¿Como quieres llamar a este cuarto?',
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
              String mensaje;
              value.isEmpty ? mensaje = 'Dime ¿Que nombre quieres'
                  'para tu cuarto?' :
              mensaje = null;
              return mensaje;
            },
          ),
        ),
      );
    }

    ///Construye el Widget que maneja el campo para introducir la descripción del
    ///cuarto.
    ///@return Un Widget de Padding que contiene un campo de texto.

    Widget _descripcionWidget() {
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
            controller: _descripcion,
            style: TextStyle(
              color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
              fontFamily: "Lato",
            ),
            maxLength: 500,
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
              hintText: '¿Que distingue a este cuarto?',
              hintStyle: TextStyle(
                color: PaletaColores(_usuario).obtenerColorInactivo(),
                fontFamily: "Lato",
              ),
              labelText: 'Descripcion',
              labelStyle: TextStyle(
                color: PaletaColores(_usuario).obtenerColorInactivo(),
                fontFamily: "Lato",
              ),
            ),
            maxLines: 4,
            validator: (value) {
              String mensaje;
              value.isEmpty ? mensaje = 'Solo di algo cortito' :
                              mensaje = null;
              return mensaje;
              },
          ),
        ),
      );
    }

    ///Maneja el comportamiento al presionar el botón.
    ///@return un retorno vaico.

    void _alPresionarBoton() {
      if ( _usuario.persona_id.isEmpty || (_imagen == null && _imagenCamara == null) ||
           _nombre.text.isEmpty || _descripcion.text.isEmpty) {
        if ( _estadoBoton == ButtonState.fail ) {
          setState(() {
            _estadoBoton = ButtonState.idle;
          });
        }
        setState(() {
          if (_imagen == null && _imagenCamara == null) {
            _bordeImagen = PaletaColores(_usuario).obtenerColorRiesgo();
          } else {
            _bordeImagen = PaletaColores(_usuario).obtenerColorInactivo();
          }
        });
        return;
      }
      _imagenFinal = _imagen != null ? _imagen : _imagenCamara.path;
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
      if(mounted) {
        setState(() {
          _estadoBoton = _estadoBoton;
        });
      }
    }

    ///Construye el Widget que maneja el botón para suministrar los datos del formulario.
    ///@return Un Widget de Container que contiene un botón.

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

    ///Construye el Widget que contiene todos los elementos del formulario.
    ///@return Un Widget de Padding que contiene un formulario.

    Widget _pantallaFrontal() {
      return Padding(
        padding: EdgeInsets.only(
          top: _height/39.6,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _imagenWidget(),
              _nombreWidget(),
              _descripcionWidget(),
              _boton(),
            ],
          ),
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
              FondoCubo(_usuario),
              _pantallaFrontal(),
              _camara(),
            ],
          ),
        ),
      ],
    );
  }
}