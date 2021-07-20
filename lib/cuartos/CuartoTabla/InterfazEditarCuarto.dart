import 'dart:io';
import 'package:flutter/material.dart';
import 'package:owleddomoapp/cuartos/CuartoTabla/ServiciosCuarto.dart';
import 'package:owleddomoapp/shared/PopUpImagenes.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/shared/TratarError.dart';
import 'package:owleddomoapp/shared/FondoCubo.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:image_picker/image_picker.dart';

///Esta clase se encarga de manejar la interfaz con el formulario para editar el
///cuarto suministrado.
///@version 1.0, 06/04/21
///@author Juan Diego Suárez Londoño.
///@param cuartoId identificador del cuarto.
///@param nombre nombre del cuarto.
///@param imagen valor para seleccionar la imagen.
///@param descripcion descripción del cuarto.
///@param usuario identificador del usuario.
///@see owleddomo_app/cuartos/CuartoTabla/InterfazInformacionCuarto.dart#class().
///@return un Widget ListView con un formulario para cambiar la imagen, el nombre o
///la descripció de un cuarto.

class InterfazEditarCuarto extends StatefulWidget {

  final String cuarto_id; //Identificador del cuarto.
  final String nombre; //Nombre del cuarto.
  final String imagen; //Valor para seleccionar la imagen.
  final String descripcion; //Descripción del cuarto.
  final String usuario; //Identificador del usuario.
  InterfazEditarCuarto(this.cuarto_id, this.nombre, this.imagen, this.descripcion,
                       this.usuario); //Constructor de la clase.

  @override
  State<StatefulWidget> createState() {
    return _InterfazEditarCuarto(this.cuarto_id, this.nombre, this.imagen,
                                 this.descripcion, this.usuario); //Crea un estado mutable del Widget.
  }
}

///Esta clase se encarga de formar un estado mutable de la clase “InterfazEditarCuarto”.
///@param _formKey identificador del formulario.
///@param _cuartoId identificador del producto.
///@param _nombre nombre del cuarto.
///@param _imagen imagen seleccionada de la lista.
///@param _imagenCamara imagen seleccionada con la camara.
///@param _imagenFinal imagen final del cuarto.
///@param _bordeImagen color del borde del botón para seleccionar imagen.
///@param _descripcion descripción del cuarto.
///@param _usuario identificador del usuario.
///@param _existe si una imagen existe es true, de no serlo es false.
///@param _nombreCampo controlador del campo para el nombre en el formulario.
///@param _descripcionCampo controlador del campo para la descripción en el formulario.
///@param _estadoBoton estado entre las transiciones del botón.
///@param _width obtiene el ancho de la pantalla del dispositivo.
///@param _height obtiene el alto de la pantalla del dispositivo.

class _InterfazEditarCuarto extends State<InterfazEditarCuarto> {

  final _formKey = GlobalKey<FormState>(); //Identificador del formulario.
  final String _cuartoId; //Identificador del cuarto.
  String _nombre; //Nombre del cuarto.
  String _imagen; //Imagen seleccionada de la lista.
  File _imagenCamara; //Imagen seleccionada con la camara.
  String _imagenFinal; //Imagen final del cuarto.
  String _descripcion; //Descripción del cuarto.
  final String _usuario; //Identificador del usuario.
  _InterfazEditarCuarto(this._cuartoId, this._nombre, this._imagenFinal, this._descripcion, this._usuario); //Constructor de la clase.

  bool _existe; //Indica la existencia de la imagen.
  Color _bordeImagen; //Color del borde del botón para seleccionar imagen.
  TextEditingController _nombreCampo; //Controlador del campo para el nombre en el formulario.
  TextEditingController _descripcionCampo; //Controlador del campo para la descripción en el formulario.
  ButtonState _estadoBoton; //Estado entre las transiciones del botón.

  @override

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState();
    if(_imagenFinal.substring(0,6) == "assets") {
      _imagen = _imagenFinal;
      _imagenCamara = null;
    } else {
      _imagen = null;
      _imagenCamara = File(_imagenFinal);
    }
    _existe = false; //Se asume que la imagen en la galeria no existe.
    _comprobarImagen(); //Se comprueba la existencia de la imagen en la galeria.
    _bordeImagen = PaletaColores().obtenerCuaternario();
    _nombreCampo = TextEditingController(text: _nombre); //Asigna el actual nombre al campo de texto.
    _descripcionCampo = TextEditingController(text: _descripcion); //Asigna la actual descripción al campo de texto.
    _estadoBoton = ButtonState.idle;
  }

  ///Busca que la imagen suministrada exista en la galeria, de ser verdad cambia
  ///el estado de_existe a "true".

  _comprobarImagen() {
    if(_imagenCamara != null) {
      _imagenCamara.exists().then((value) =>
          setState(() {
            _existe = value;
          })
      );
    }
  }

  ///Controla la selección de la imagen para el cuarto.

  _seleccionarImagen(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return PopUpImagenes("cuartos");
      },
    ).then((value) => {
      if (mounted) {
        setState(() {
          _imagenCamara = null;
          value == null ? _imagen = null
                        : _imagen = value;
          value == null ? _bordeImagen = PaletaColores().obtenerColorRiesgo()
                        : _bordeImagen = PaletaColores().obtenerCuaternario();
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
        _bordeImagen = PaletaColores().obtenerCuaternario();
      } else {
        _imagenCamara = null;
        _bordeImagen = PaletaColores().obtenerColorRiesgo();
      }
      _comprobarImagen();
      _imagen = null;
    });
  }

  ///Actualiza el cuarto o genera un error en caso de cualquier eventualidad.
  ///@see owleddomo_app/cuartos/CuartoTabla/ServiciosDispositivo.actualizarCuarto#method().
  ///@see owleddomo_app/shared/TratarError.estadoServicioActualizar#method().
  ///@return No retorna nada en caso de no obtener una validación positiva de los campos.

  _actualizarCuarto() {
    ServiciosCuarto.actualizarCuarto(_cuartoId, _usuario, _nombreCampo.text,
                                     _imagenFinal, _descripcionCampo.text).then((result) {

      String respuesta = TratarError().tarjetaDeEstado( result, [_nombreCampo.text,
                        _imagenFinal, _descripcionCampo.text], context).first.toString();
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
                color: PaletaColores().obtenerColorInactivo(),
                width: _height/300,
              ),
              color: PaletaColores().obtenerContrasteInactivo(),
              borderRadius: BorderRadius.circular(150),
            ),
            height: _height/11.31428571428571,
            width: _height/11.31428571428571,
            child: Icon(
              Icons.camera_alt_rounded,
              size: _height/22.62857142857143,
              color: PaletaColores().obtenerColorInactivo(),
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
              color: PaletaColores().obtenerSecundario(),
              borderRadius: BorderRadius.circular(150),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: _imagenCamara == null  ?
                  AssetImage(_imagen) :
                  _existe ? FileImage(_imagenCamara) :
                  AssetImage("assets/img/Imagen_no_disponible.jpg"),
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
              color: PaletaColores().obtenerContrasteInactivo(),
              borderRadius: BorderRadius.circular(150),
            ),
            child: Icon(
              Icons.image,
              size: _height/6.6,
              color: PaletaColores().obtenerColorInactivo(),
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
            primaryColor: PaletaColores().obtenerCuaternario(),
          ),
          child: TextFormField(
            controller: _nombreCampo,
            style: TextStyle(
              color: PaletaColores().obtenerLetraContrasteSecundario(),
              fontFamily: "Lato",
            ),
            maxLength: 50,
            decoration: InputDecoration(
              filled: true,
              fillColor: PaletaColores().obtenerSecundario(),
              border: const OutlineInputBorder(),
              counterStyle: TextStyle(
                color: PaletaColores().obtenerLetraContrasteSecundario(),
                fontFamily: "Lato",
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: PaletaColores().obtenerCuaternario(),
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: PaletaColores().obtenerColorInactivo(),
                  width: 2.0,
                ),
              ),
              hintText: '¿Como quieres llamar a este cuarto?',
              hintStyle: TextStyle(
                color: PaletaColores().obtenerColorInactivo(),
                fontFamily: "Lato",
              ),
              labelText: 'Nombre',
              labelStyle: TextStyle(
                color: PaletaColores().obtenerColorInactivo(),
                fontFamily: "Lato",
              ),
            ),
            autofocus: true,
            validator: (value) {
              String mensaje;
              value.isEmpty ? mensaje = 'Dime ¿Que nombre quieres'
                'para tu cuarto?' : mensaje = null;
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
            primaryColor: PaletaColores().obtenerCuaternario(),
          ),
          child: TextFormField(
            controller: _descripcionCampo,
            style: TextStyle(
              color: PaletaColores().obtenerLetraContrasteSecundario(),
              fontFamily: "Lato",
            ),
            maxLength: 500,
            decoration: InputDecoration(
              filled: true,
              fillColor: PaletaColores().obtenerSecundario(),
              border: const OutlineInputBorder(),
              counterStyle: TextStyle(
                color: PaletaColores().obtenerLetraContrasteSecundario(),
                fontFamily: "Lato",
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: PaletaColores().obtenerCuaternario(),
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: PaletaColores().obtenerColorInactivo(),
                  width: 2.0,
                ),
              ),
              hintText: '¿Que distingue a este cuarto?',
              hintStyle: TextStyle(
                color: PaletaColores().obtenerColorInactivo(),
                fontFamily: "Lato",
              ),
              labelText: 'Descripcion',
              labelStyle: TextStyle(
                color: PaletaColores().obtenerColorInactivo(),
                fontFamily: "Lato",
              ),
            ),
            maxLines: 4,
            validator: (value) {
              String mensaje;
              value.isEmpty ? mensaje='Solo di algo cortito' : mensaje=null;
              return mensaje;
              },
          ),
        ),
      );
    }

    ///Maneja el comportamiento al presionar el botón.
    ///@return un retorno vaico.

    void _alPresionarBoton() {
      if ( (_usuario.isEmpty || (_imagen == null && _imagenCamara == null) ||
          _nombreCampo.text.isEmpty || _descripcionCampo.text.isEmpty) && mounted) {
        if (_estadoBoton == ButtonState.fail) {
          setState(() {
            _estadoBoton = ButtonState.idle;
          });
        }
        setState(() {
          if (_imagen == null && _imagenCamara == null) {
            _bordeImagen = PaletaColores().obtenerColorRiesgo();
          } else {
            _bordeImagen = PaletaColores().obtenerColorInactivo();
          }
        });
        return;
      }
      _imagenFinal = _imagen != null ? _imagen : _imagenCamara.path;
      switch (_estadoBoton) {
        case ButtonState.idle:
          _estadoBoton = ButtonState.loading;
          _actualizarCuarto();
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
              color: PaletaColores().obtenerLetraContrastePrimario(),
            ),
            iconedButtons: {
              ButtonState.idle: IconedButton(
                  text: "Enviar",
                  icon: Icon(
                    Icons.send,
                    color: PaletaColores().obtenerLetraContrastePrimario(),
                  ),
                  color: PaletaColores().obtenerColorInactivo(),
              ),
              ButtonState.loading:
              IconedButton(
                text: "Cargando",
                color: PaletaColores().obtenerPrimario(),
              ),
              ButtonState.fail: IconedButton(
                icon: Icon(
                  Icons.cancel,
                  color: PaletaColores().obtenerLetraContrastePrimario(),
                ),
                color: PaletaColores().obtenerColorRiesgo(),
              ),
              ButtonState.success: IconedButton(
                  text: "Exito",
                  icon: Icon(
                    Icons.check_circle,
                    color: PaletaColores().obtenerLetraContrastePrimario(),
                  ),
                  color: PaletaColores().obtenerTerciario(),
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
          color: PaletaColores().obtenerColorFondo(),
          height: _height/1.161290322580645,
          child: Stack(
              children: <Widget>[
                FondoCubo(),
                _pantallaFrontal(),
                _camara(),
              ]
          ),
        ),
      ],
    );
  }
}