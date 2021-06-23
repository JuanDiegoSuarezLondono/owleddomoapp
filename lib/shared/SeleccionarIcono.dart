import 'package:flutter/material.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/shared/nuevos_iconos_icons.dart';

final PaletaColores colores = new PaletaColores(); //Colores predeterminados.

///Esta clase se encarga de seleccionar un icono según el string suministrado.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param icono icono seleccionado.
///@param dimensión tamaño del icono.
///@param color color del icono.
///@see owleddomo_app/cuartos/Dispositivo/CuartoTabla/InterfazInformacionCuarto.dart#class().
///@see owleddomo_app/cuartos/Dispositivo/CuartoTabla/InterfazEditarCuarto.dart#class().
///@see owleddomo_app/cuartos/Dispositivo/CuartoTabla/PopUpImagenes.dart#class().
///@see owleddomo_app/cuartos/Dispositivo/CuartoTabla/CartaCuarto.dart#class().
///@return un Widget Icon con un icono acorde al string suministrado.

class SeleccionarIcono extends StatelessWidget{

  String path; //Icono icono seleccionado.
  double dimencion; //Dimensión tamaño del icono.
  Color color; //Color del icono.
  SeleccionarIcono(this.path, this.dimencion, this.color); //Constructor de la clase.

  @override

  Widget build(BuildContext context) {

    ///Selecciona el icono dentro de una lista de opciones preestablecidas.
    ///@return IconData con el icono según el string suministrado.

    buscarIcono() {
      switch(path) {
        case "Alerta":
          return NuevosIconos.alert;
          break;
        case "Astronauta":
          return NuevosIconos.user_astronaut;
          break;
        case "Atencion":
          return NuevosIconos.attention;
          break;
        case "AtencionCirculo":
          return NuevosIconos.attention_circled;
          break;
        case "Bombilla":
          return NuevosIconos.lightbulb;
          break;
        case "BombillaApagada":
          return NuevosIconos.lightbulb_1;
          break;
        case "Celular":
          return NuevosIconos.smartphone;
          break;
        case "Correo":
          return NuevosIconos.email;
          break;
        case "Escudo":
          return NuevosIconos.shield;
          break;
        case "Facebook":
          return NuevosIconos.facebook_squared;
          break;
        case "GMail":
          return NuevosIconos.gmail;
          break;
        case "Instagram":
          return NuevosIconos.instagram;
          break;
        case "Localizacion":
          return NuevosIconos.location;
          break;
        case "RecuperarContraseña":
          return NuevosIconos.lock_alt;
          break;
        case "Sign-in":
          return NuevosIconos.sign_in;
          break;
        case "Sign-out":
          return NuevosIconos.sign_out;
          break;
        case "Ventana":
          return NuevosIconos.microsoft;
          break;
        case "VentanaRota":
          return NuevosIconos.lightning;
          break;
        case "PuertaAbierta":
          return NuevosIconos.door_open;
          break;
        case "PuertaCerrada":
          return NuevosIconos.door_closed;
          break;
          default:
          return Icons.clear;
          break;
      }
    }
    return Icon(
      buscarIcono(),
      size: dimencion,
      color: color,
    );
  }
}