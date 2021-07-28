import 'package:flutter/material.dart';
import 'package:owleddomoapp/login/Persona.dart';

class PaletaColores {

  Color color_primario;
  Color color_secundario;
  Color color_terciario;
  Color color_cuaternario;
  Color color_letra_contraste_primario;
  Color color_letra_contraste_secundario;
  Color color_inactivo;
  Color color_contraste_inactivo;
  Color color_fondo;
  Color color_riesgo;
  Color color_contraste_riesgo;

  PaletaColores(Persona usuario) {
    switch(usuario.tema) {
      case 0:
        color_primario = Color(0xFF08192d);
        color_secundario = Colors.white;
        color_terciario = Color(0xFF9BBF63);
        color_cuaternario = Color(0xFFbf930d);
        color_letra_contraste_primario = Colors.white;
        color_letra_contraste_secundario = Colors.black;
        color_inactivo = Color(0xFF929292);
        color_contraste_inactivo = Colors.white;
        color_fondo = Color(0xFFECEFF1);
        color_riesgo = Colors.red; //FFF44336
        color_contraste_riesgo = Colors.white;
        break;

      case 1:
        color_primario = Colors.black;
        color_secundario = Color(0xFF08192d);
        color_terciario = Color(0xFF736F3D);
        color_cuaternario = Color(0xFF8C5C03);
        color_letra_contraste_primario = Colors.white.withOpacity(0.82);
        color_letra_contraste_secundario = Colors.white;//FFFFFFFF
        color_inactivo = Color(0xFF929292);
        color_contraste_inactivo = Colors.white;
        color_fondo = Color(0xFF1E3C40);
        color_riesgo = Colors.red; //FFF44336
        color_contraste_riesgo = Colors.white;
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

  Color obtenerLetraContrastePrimario () {
    return color_letra_contraste_primario;
  }

  Color obtenerLetraContrasteSecundario () {
    return color_letra_contraste_secundario;
  }

  Color obtenerContrasteInactivo () {
    return color_contraste_inactivo;
  }

  Color obtenerContrasteRiesgo () {
    return color_contraste_riesgo;
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