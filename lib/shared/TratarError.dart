import 'package:flutter/material.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';

class TratarError {

  List textoAgregado(List estado, List<String> textos, bool conteo) {
    List respuestaError = [];
    switch (estado.first.toString()) {
      case "200":
        respuestaError.add(estado.last);
        respuestaError.add(
            estado.last.toString() != "[]" ?
            conteo ? '${textos[0]}${estado.last.length}'
                : '${textos[0]}'
                : '${textos[1]}');
        break;
      case "201":
        respuestaError.add(estado.last);
        respuestaError.add(
            estado.last.toString() != "[]" ?
            conteo ? '${textos[0]}${estado.last.length}'
                : '${textos[0]}'
                : '${textos[1]}');
        break;
      case "400":
        respuestaError.add(null);
        respuestaError.add('${textos[2]}');
        break;
      case "401":
        respuestaError.add(null);
        respuestaError.add('${textos[3]}');
        break;
      case "409":
        respuestaError.add(null);
        respuestaError.add('${textos[4]}');
        break;
      case "421":
        respuestaError.add(null);
        respuestaError.add('${textos[4]}');
        break;
      case "422":
        respuestaError.add(null);
        respuestaError.add('${textos[4]}');
        break;
      case "502":
        respuestaError.add(null);
        respuestaError.add('${textos[5]}');
        break;
      case "Failed host lookup: 'zmyanb1bc1.execute-api.sa-east-1.amazonaws.com'":
        respuestaError.add(null);
        respuestaError.add('${textos[6]}');
        break;
      default:
        respuestaError.add(null);
        respuestaError.add('${textos[7]}');
        break;
    }

    return respuestaError;
  }

  int estadoServicioLeer(List estado) {
    int numeroEstado = 0;
    switch (estado.first.toString()) {
      case "200":
        numeroEstado = estado.last.toString() != "[]" ? 0 : 1;
        break;
      case "201":
        numeroEstado = 0;
        break;
      case "400":
        numeroEstado = 2;
        break;
      case "401":
        numeroEstado = 3;
        break;
      case "409":
        numeroEstado = 4;
        break;
      case "421":
        numeroEstado = 4;
        break;
      case "422":
        numeroEstado = 4;
        break;
      case "502":
        numeroEstado = 5;
        break;
      case "Failed host lookup: 'zmyanb1bc1.execute-api.sa-east-1.amazonaws.com'":
        numeroEstado = 6;
        break;
      default:
        numeroEstado = 7;
        break;
    }
    return numeroEstado;
  }


  List tarjetaDeEstado (List estado, List<String> alRegresar, BuildContext context) {
    final PaletaColores colores = new PaletaColores(); //Colores predeterminados.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.
    Color color = colores.obtenerColorInactivo();
    IconData icono = Icons.star;
    String texto = "Estrella";
    switch (estado.first.toString()) {
      case "200":
        color = PaletaColores().obtenerTerciario();
        icono = Icons.check_circle;
        texto = "¡Exito!";
        Navigator.of(context).pop(alRegresar);
        break;
      case "201":
        color = PaletaColores().obtenerTerciario();
        icono = Icons.check_circle;
        texto = "¡Creado!";
        Navigator.of(context).pop(alRegresar);
        break;
      case "400":
        color = PaletaColores().obtenerColorRiesgo();
        icono = Icons.device_unknown_rounded;
        texto = "No se pudo conectar con el dispositivo";
        break;
      case "401":
        color = PaletaColores().obtenerColorRiesgo();
        icono = Icons.local_police_rounded;
        texto = "No te identificamos...\n¿Esto es tuyo?";
        break;
      case "409":
        color = colores.obtenerColorCuatro();
        icono = Icons.cloud_off_rounded;
        texto = "Un avión tumbo nuestra nube...\nEstamos trabajando en ello :)";
        break;
      case "421":
        color = colores.obtenerColorCuatro();
        icono = Icons.cloud_off_rounded;
        texto = "Un avión tumbo nuestra nube...\nEstamos trabajando en ello :)";
        break;
      case "422":
        color = colores.obtenerColorCuatro();
        icono = Icons.cloud_off_rounded;
        texto = "Un avión tumbo nuestra nube...\nEstamos trabajando en ello :)";
        break;
      case "502":
        color = colores.obtenerColorRiesgo();
        icono = Icons.precision_manufacturing_sharp;
        texto = "¡Rayos! Algo pasa con la app...";
        break;
      case "Failed host lookup: 'zmyanb1bc1.execute-api.sa-east-1.amazonaws.com'":
        color = colores.obtenerColorInactivo();
        icono = Icons.wifi_off_outlined;
        texto = "Si la vida te da internet, has limonada";
        break;
      default:
        color = colores.obtenerColorRiesgo();
        icono = Icons.error_rounded;
        texto = "Ups... Algo salio mal";
        break;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colores.obtenerColorUno(),
          content: Container(
            height: _height/4.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Icon(
                    icono,
                    size: _height/7.92,
                    color: color,
                  ),
                ),
                Text(
                  texto,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: _height/44,
                    color: color,
                    fontFamily: "Lato",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    return estado;
  }


  String estadoServicioActualizar (String estado,List<String> alRegresar, BuildContext context) {
    final PaletaColores colores = new PaletaColores(); //Colores predeterminados.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.
    Color color = colores.obtenerColorInactivo();
    IconData icono = Icons.star;
    String texto = "Estrella";
    switch (estado) {
      case "EXITO":
        color = colores.obtenerColorTres();
        icono = Icons.check_circle;
        texto = "¡Exito!";
        Navigator.of(context).pop(alRegresar);
        break;
      case "NEL PASTEL":
        color = colores.obtenerColorRiesgo();
        icono = Icons.warning_rounded;
        texto = "¡Alto ahi vaquero!\nEste rancho no es tuyo";
        break;
      case "LOCAL":
        color = colores.obtenerColorRiesgo();
        icono = Icons.precision_manufacturing_sharp;
        texto = "¡Rayos! Algo pasa con la app...";
        break;
      case "SERVIDOR":
        color = colores.obtenerColorCuatro();
        icono = Icons.cloud_off_rounded;
        texto = "Un avión tumbo nuestra nube...\nEstamos trabajando en ello :)";
        break;
      case "Failed host lookup: 'o6vrtl78zb.execute-api.us-east-2.amazonaws.com'":
        color = colores.obtenerColorInactivo();
        icono = Icons.wifi_off_outlined;
        texto = "Si la vida te da internet, has limonada";
        break;
      default:
        color = colores.obtenerColorRiesgo();
        icono = Icons.error_rounded;
        texto = "Ups... Algo salio mal";
        break;
    }
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colores.obtenerColorUno(),
          content: Container(
            height: _height/5.657142857142857,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Icon(
                    icono,
                    size: _height/7.92,
                    color: color,
                  ),
                ),
                Text(
                  texto,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color,
                    fontFamily: "Lato",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    return estado;
  }

  String estadoServicioActualizarSnackbar (String estado, BuildContext context) {
    final PaletaColores colores = new PaletaColores(); //Colores predeterminados.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.
    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    Color color = colores.obtenerColorInactivo();
    IconData icono = Icons.star;
    String texto = "Estrella";
    switch (estado) {
      case "EXITO":
        color = colores.obtenerColorTres();
        icono = Icons.check_circle;
        texto = "¡Exito!";
        break;
      case "NEL PASTEL":
        color = colores.obtenerColorRiesgo();
        icono = Icons.warning_rounded;
        texto = "¡Alto ahi vaquero!\nEste rancho no es tuyo";
        break;
      case "LOCAL":
        color = colores.obtenerColorRiesgo();
        icono = Icons.precision_manufacturing_sharp;
        texto = "¡Rayos!\nAlgo pasa con la app...";
        break;
      case "SERVIDOR":
        color = colores.obtenerColorCuatro();
        icono = Icons.cloud_off_rounded;
        texto = "¡Antena rota!\nBuscaremos la cinta :)";
        break;
      case "Failed host lookup: 'o6vrtl78zb.execute-api.us-east-2.amazonaws.com'":
        color = colores.obtenerColorInactivo();
        icono = Icons.wifi_off_outlined;
        texto = "Si la vida te da internet,\nhas limonada";
        break;
      default:
        color = colores.obtenerColorRiesgo();
        icono = Icons.error_rounded;
        texto = "Ups... Algo salio mal";
        break;
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: colores.obtenerColorUno(),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          behavior: SnackBarBehavior.floating,
          width: _width/1.8,
          duration: const Duration(milliseconds: 2500),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                texto,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontFamily: "Lato",
                ),
              ),
              Icon(
                icono,
                size: _height/39.6,
                color: color,
              ),
            ],
          ),
        ),
    );
    return estado;
  }
}