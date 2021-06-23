import 'package:flutter/material.dart';

final Color COLOR_UNO = Color(0xFF08192d);
final Color COLOR_DOS = Colors.white; //FFFFFFFF
final Color COLOR_TRES = Color(0xFF11DA53);
final Color COLOR_CUATRO = Color(0xFFbf930d);
final Color COLOR_GRIS_LETRA = Color(0xFF929292);
final Color COLOR_FONDO = Color(0xFFECEFF1);
final Color COLOR_RIESGO = Colors.red; //FFF44336

class PaletaColores {

  Color obtenerColorUno () {
    return COLOR_UNO;
  }

  Color obtenerColorDos() {
    return COLOR_DOS;
  }

  Color obtenerColorTres () {
    return COLOR_TRES;
  }

  Color obtenerColorCuatro () {
    return COLOR_CUATRO;
  }

  Color obtenerColorInactivo () {
    return COLOR_GRIS_LETRA;
  }

  Color obtenerColorFondo () {
    return COLOR_FONDO;
  }

  Color obtenerColorRiesgo () {
    return COLOR_RIESGO;
  }
}