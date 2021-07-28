import 'package:flutter/material.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/Variable/Variable.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/Variable/ServiciosVariable.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/shared/TratarError.dart';

///Esta clase se encarga del widget predeterminado para las variables de tipo
///luz RGB.
///@version 1.0, 06/04/21
///@author Juan Diego Suárez Londoño
///@param variables lista de los parámetros para las 3 variables de colores.
///@param usuario parametros del usuario.
///@see owleddomo_app/cuartos/Dispositivo/DispositivoTabla/InterfazInformacionDispositivo.dart#class().
///@return Un Widget Container con una tarjeta botón para controlar el color.

class LuzRGB extends StatefulWidget {

  final List<Variable> variables; //Lista de los parámetros para las 3 variables de colores.
  final Persona usuario; //Parametros del usuario.

  LuzRGB(this.variables, this.usuario); //Constructor de la clase.

  @override
  _LuzRGB createState() => _LuzRGB(variables, usuario); //Crea un estado mutable del Widget.

}

///Esta clase se encarga de formar un estado mutable de la clase “LuzRGB”.
///@param _variables lista de los parámetros para las 3 variables de colores.
///@param _usuario parametros del usuario.
///@param _R variable para rojo.
///@param _B variable para azul.
///@param _G variable para verde.
///@param _colorActual obtiene el dato del color seleccionado.
///@param _colorAnterior guarda el dato del color anterior.

class _LuzRGB extends State<LuzRGB> {

  List<Variable> _variables; //Lista de los parámetros para las 3 variables de colores.
  final Persona _usuario; //Parametros del usuario.

  _LuzRGB(this._variables, this._usuario); //Constructor de la clase.

  Variable _R; //Variable para rojo.
  Variable _B; //Variable para azul.
  Variable _G; //Variable para verde.
  Color _colorActual; //Obtiene el dato del color seleccionado.
  Color _colorAnterior; //Guarda el dato del color anterior.

  @override

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState();
    _asignarVariables();
    _colorActual = Color.fromRGBO( int.parse(_R.valor), int.parse(_G.valor), int.parse(_B.valor), 1);
  }

  ///Actualiza la variable que controla el color al nuevo que se seleccione.
  ///@param color nuevo color seleccionado.

  void changeColor(Color color) => setState(() => {
    _colorActual = color,
  });

  ///Divide la lista de variables ingresada en sus respectivas variables R, G o B.

  _asignarVariables() {
    for(var i=0; i<3; i++) {
      if(_variables[i].relacion_id.substring(4,5) == "R") {
        _R = _variables[i];
      } else if (_variables[i].relacion_id.substring(4,5) == "G") {
        _G = _variables[i];
      } else if (_variables[i].relacion_id.substring(4,5) == "B") {
        _B = _variables[i];
      }
    }
  }

  ///Actualiza todas las variables con el color seleccionado, actualiza la base de datos
  ///y actualiza el hardware.

  _cambiarValor () {
    if( _R.valor != _colorActual.red.toString()) {
      _R.valor = _colorActual.red.toString();
      ServiciosVariable.actualizarVariable(_R.relacion_id, _R.valor, _R.persona_producto_id, _R.relacion_dispositivo)
          .then((result) {
            String respuesta =  TratarError(_usuario).estadoSnackbar(result, context).first.toString();
            if ( respuesta != "200" && mounted) {
              setState(() {
                _colorActual = _colorAnterior;
                _R.valor = _colorAnterior.red.toString();
              });
            }
          });
    }
    if( _G.valor != _colorActual.green.toString()) {
      _G.valor = _colorActual.green.toString();
      ServiciosVariable.actualizarVariable(_G.relacion_id, _G.valor, _G.persona_producto_id, _G.relacion_dispositivo)
          .then((result) {
        String respuesta =  TratarError(_usuario).estadoSnackbar(result, context).first.toString();
        if ( respuesta != "200" && mounted) {
          setState(() {
            _colorActual = _colorAnterior;
            _G.valor = _colorAnterior.red.toString();
          });
        }
      });
    }
    if( _B.valor != _colorActual.blue.toString()) {
      _B.valor = _colorActual.blue.toString();
      ServiciosVariable.actualizarVariable(_B.relacion_id, _B.valor, _B.persona_producto_id, _B.relacion_dispositivo)
          .then((result) {
        String respuesta =  TratarError(_usuario).estadoSnackbar(result, context).first.toString();
        if ( respuesta != "200" && mounted) {
          setState(() {
            _colorActual = _colorAnterior;
            _G.valor = _colorAnterior.red.toString();
          });
        }
      });
    }
  }

  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    ///Construye el Widget del icono de la variable y cambia su color.
    ///@param primera variable para seleccionar de que tipo va a ser el icono.
    ///@return Un Widget de Icon.

    Widget _icono (Variable variable) {
      if(variable.relacion_id.substring(5,6) == "1") {
        return Icon(
          Icons.wb_sunny_rounded,
          color: useWhiteForeground(_colorActual)
              ? Colors.white
              : Colors.black,
        );
      } else if (variable.relacion_id.substring(5,6) == "0") {
        return Icon(
          Icons.nightlight_round,
          color: useWhiteForeground(_colorActual)
              ? Colors.white
              : Colors.black,
        );
      } else {
        return Icon(
          Icons.color_lens,
          color: useWhiteForeground(_colorActual)
              ? Colors.white
              : Colors.black,
        );
      }
    }

    ///Construye un menu desplegable que se abre por un botón, el menú contiene
    ///opciones de seleccionar color por RGB o mediante una paleta de colores.
    ///@return Un Widget con un Container que lleva toda la lógica a manera de carta
    ///para seleccionar un color.

    Widget _interruptorBoton () {
      return Container(
        width: _width/3.3962,
        height: _height/13.2,
        child: Card(
          color: useWhiteForeground(_colorActual)
              ? PaletaColores(_usuario).obtenerColorInactivo()
              : PaletaColores(_usuario).obtenerColorInactivo(),
          child: PopupMenuButton(
            icon: Container(
              decoration: BoxDecoration(
                color: _colorActual,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Container (
                height: _height/19.8,
                width: _width/9,
                child:  _icono(_variables[0]),
              ),
            ),
            initialValue: 1,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 1,
                  child: Text(
                    'Paleta de colores',
                    style: TextStyle(
                      color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
                      fontFamily: "lato",
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text(
                    'Barras RGB',
                    style: TextStyle(
                      color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
                      fontFamily: "lato",
                    ),
                  ),
                ),
              ];
            },
            onSelected: (int index) {
              _colorAnterior = _colorActual;
              if (index == 1) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      titlePadding: const EdgeInsets.all(0.0),
                      contentPadding: const EdgeInsets.all(0.0),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: _colorActual,
                          onColorChanged: changeColor,
                          colorPickerWidth: 300.0,
                          pickerAreaHeightPercent: 0.7,
                          enableAlpha: false,
                          displayThumbColor: true,
                          showLabel: false,
                          paletteType: PaletteType.hsv,
                          pickerAreaBorderRadius: const BorderRadius.only(
                            topLeft: const Radius.circular(2.0),
                            topRight: const Radius.circular(2.0),
                          ),
                        ),
                      ),
                    );
                  },
                ).then((val){
                  _cambiarValor();
                });
              } else if (index == 2) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      titlePadding: const EdgeInsets.all(0.0),
                      contentPadding: const EdgeInsets.all(0.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      content: SingleChildScrollView(
                        child: SlidePicker(
                          pickerColor: _colorActual,
                          onColorChanged: changeColor,
                          paletteType: PaletteType.rgb,
                          enableAlpha: false,
                          displayThumbColor: true,
                          showLabel: true,
                          showIndicator: true,
                          indicatorBorderRadius:
                          const BorderRadius.vertical(
                            top: const Radius.circular(25.0),
                          ),
                        ),
                      ),
                    );
                  },
                ).then((val){
                  _cambiarValor();
                });
              };
            },
          ),
        ),
      );
    }
    return _interruptorBoton();
  }
}