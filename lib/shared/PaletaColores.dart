import 'package:flutter/material.dart';

class PaletaColores {

  Color color_primario;
  Color color_secundario; //FFFFFFFF
  Color color_terciario;
  Color color_cuaternario;
  Color color_letra_contraste_primario;
  Color color_letra_contraste_secundario;
  Color color_inactivo;
  Color color_fondo;
  Color color_riesgo;

  PaletaColores() {
    int a = 1;
    switch(a) {
      case 0:
        color_primario = Color(0xFF08192d);
        color_secundario = Colors.white;//FFFFFFFF
        color_terciario = Color(0xFF9BBF63);
        color_cuaternario = Color(0xFFbf930d);
        color_letra_contraste_primario = Colors.white;
        color_letra_contraste_secundario = Colors.black;
        color_inactivo = Color(0xFF929292);
        color_fondo = Color(0xFFECEFF1);
        color_riesgo = Colors.red; //FFF44336
        break;

      case 1:
        color_primario = Colors.white;
        color_secundario = Color(0xFF08192d);
        color_terciario = Color(0xFF9BBF63);
        color_cuaternario = Color(0xFFF2CF1D);
        color_letra_contraste_primario = Colors.black;
        color_letra_contraste_secundario = Colors.white;//FFFFFFFF
        color_inactivo = Color(0xFFECEFF1);
        color_fondo = Color(0xFF1E3C40);
        color_riesgo = Colors.red; //FFF44336
        break;
    }
  }


  Color obtenerPrimario () {
    return color_primario;
  }

  Color obtenerSecundario() {
    return color_secundario;
  }

  Color obtenerTerciario () {
    return color_terciario;
  }

  Color obtenerCuaternario () {
    return color_cuaternario;
  }

  Color obtenerLetraContrasetePrimario () {
    return color_letra_contraste_primario;
  }

  Color obtenerLetraContraseteSecundario () {
    return color_letra_contraste_secundario;
  }



  Color obtenerColorUno () {
    return color_primario;
  }

  Color obtenerColorDos() {
    return color_secundario;
  }

  Color obtenerColorTres () {
    return color_terciario;
  }

  Color obtenerColorCuatro () {
    return color_cuaternario;
  }

  Color obtenerColorInactivo () {
    return color_inactivo;
  }

  Color obtenerColorFondo () {
    return color_fondo;
  }

  Color obtenerColorRiesgo () {
    return color_riesgo;
  }
}