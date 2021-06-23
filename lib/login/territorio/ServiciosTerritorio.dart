import 'dart:convert';
import 'package:owleddomoapp/login/territorio/Territorio.dart';
import 'package:http/http.dart'as http;

///Esta clase se encarga de implementar una arquitectura REST para consumir la API
///que comunica con la tabla de rutina en la base de datos.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param URL dirección principal de la API.
///@see owleddomo_app/RutinasLista#class().
///@see owleddomo_app/InterfazInformacionRutina#class().
///@see owleddomo_app/InterfazEditarRutina#class().
///@see owleddomo_app/InterfazAgregarRutina#class().

class ServiciosTerritorio {

  static const URL = "https://o6vrtl78zb.execute-api.us-east-2.amazonaws.com/test/territorios";

  ///Metodo usado para castear la respuesta desde un String que contiene
  ///la informacion de las entidades requeridas a una lista de objetos para
  ///su uso como tal.
  ///@param respuesta respuesta de la consulta http.
  ///@return lista mapeada de todas las rutinas obtenidas.

  static List<Territorio> parsearRespuesta(String respuesta) {
    final parsed = json.decode(respuesta).cast<Map<String, dynamic>>();
    return parsed.map<Territorio>((json) => Territorio.fromJson(json)).toList();
  }

  ///Obtiene las rutinas relacionadas a una persona.
  ///@param resultado lista de los resultados y la flag del estado.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@param lista lista parseada de las rutinas.
  ///@return lista de variables y un flag de "EXITO" en la primera posición
  ///en caso de recibir datos, solo un flag de "VACIO" en caso de no tener
  ///datos o solo un mensaje de error ("LOCAL/SERVIDOR/OTRO") en caso de presentarse.

  static Future<List> obtenerPaises() async {
    var getConsult = Uri.parse(URL+"/paises"); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados y la flag del estado.
    try {
      final respuesta = await http.get(getConsult); //Datos sin parecear de la consulta http.
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300 && respuesta.body != "[]") {
        List<Territorio> lista = parsearRespuesta(respuesta.body); //Lista parseada de las rutinas.
        resultado.add("EXITO");
        resultado.add(lista);
        return resultado;
      } else if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
        resultado.add("VACIO");
        return resultado;
      } else if (respuesta.statusCode >= 400 && respuesta.statusCode < 500 ) {
        resultado.add("LOCAL");
        return resultado;
      } else if (respuesta.statusCode >= 500 && respuesta.statusCode < 600 ) {
        resultado.add("SERVIDOR");
        return resultado;
      } else {
        resultado.add("OTRO");
        return resultado;
      }
    } catch (e) {
      resultado.add(e.message);
      return resultado;
    }
  }

  static Future<List> obtenerProvincias(String codigoPais) async {
    var getConsult = Uri.parse(URL+"/provincias?codigo_pais="+codigoPais); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados y la flag del estado.
    try {
      final respuesta = await http.get(getConsult); //Datos sin parecear de la consulta http.
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300 && respuesta.body != "[]") {
        List<Territorio> lista = parsearRespuesta(respuesta.body); //Lista parseada de las rutinas.
        resultado.add("EXITO");
        resultado.add(lista);
        return resultado;
      } else if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
        resultado.add("VACIO");
        return resultado;
      } else if (respuesta.statusCode >= 400 && respuesta.statusCode < 500 ) {
        resultado.add("LOCAL");
        return resultado;
      } else if (respuesta.statusCode >= 500 && respuesta.statusCode < 600 ) {
        resultado.add("SERVIDOR");
        return resultado;
      } else {
        resultado.add("OTRO");
        return resultado;
      }
    } catch (e) {
      resultado.add(e.message);
      return resultado;
    }
  }

  static Future<List> obtenerCiudades(String codigoPais, String codigoAdminUno) async {
    var getConsult = Uri.parse(URL+"/ciudades?codigo_pais="+codigoPais+'&codigo_admin_uno='+codigoAdminUno); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados y la flag del estado.
    try {
      final respuesta = await http.get(getConsult); //Datos sin parecear de la consulta http.
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300 && respuesta.body != "[]") {
        List<Territorio> lista = parsearRespuesta(respuesta.body); //Lista parseada de las rutinas.
        resultado.add("EXITO");
        resultado.add(lista);
        return resultado;
      } else if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
        resultado.add("VACIO");
        return resultado;
      } else if (respuesta.statusCode >= 400 && respuesta.statusCode < 500 ) {
        resultado.add("LOCAL");
        return resultado;
      } else if (respuesta.statusCode >= 500 && respuesta.statusCode < 600 ) {
        resultado.add("SERVIDOR");
        return resultado;
      } else {
        resultado.add("OTRO");
        return resultado;
      }
    } catch (e) {
      resultado.add(e.message);
      return resultado;
    }
  }

}