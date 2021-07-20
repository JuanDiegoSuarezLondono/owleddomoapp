import 'dart:convert';
import 'package:owleddomoapp/login/territorio/Territorio.dart';
import 'package:http/http.dart'as http;

///Esta clase se encarga de implementar una arquitectura REST para consumir la API
///que comunica con la tabla de territorios en la base de datos.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param URL dirección principal de la API.
///@see owleddomo_app/login/LoginMain.dart#class().

class ServiciosTerritorio {

  static const URL = "https://zmyanb1bc1.execute-api.sa-east-1.amazonaws.com/test/territorios";

  ///Metodo usado para castear la respuesta desde un String que contiene
  ///la informacion de las entidades requeridas a una lista de objetos para
  ///su uso como tal.
  ///@param respuesta respuesta de la consulta http.
  ///@return lista mapeada de todas los territorios obtenidos.

  static List<Territorio> parsearRespuesta(String respuesta) {
    final parsed = json.decode(respuesta).cast<Map<String, dynamic>>();
    return parsed.map<Territorio>((json) => Territorio.fromJson(json)).toList();
  }

  ///Obtiene las provincias relacionados a un pais.
  ///@param codigoPais identificador pais.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@param resultado lista de los resultados.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@param body cuerpo de la consulta decodificado a utf8.
  ///@param lista lista parseada de las provincias.
  ///@return lista con los datos de la consulta o un error.

  static Future<List> obtenerProvincias(String codigoPais) async {
    var getConsult = Uri.parse(URL+"/provincias?codigo_pais="+codigoPais); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados y la flag del estado.
    try {
      final respuesta = await http.get(getConsult); //Datos sin parecear de la consulta http.
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
        String body = utf8.decode(respuesta.bodyBytes); //Body cuerpo de la consulta decodificado a utf8.
        List<Territorio> lista = parsearRespuesta(body); //Lista parseada de las rutinas.
        resultado.add(respuesta.statusCode);
        resultado.add(lista);
        return resultado;
      } else {
        resultado.add(respuesta.statusCode);
        resultado.add(respuesta.body);
        return resultado;
      }
    } catch (e) {
      resultado.add(e.message);
      return resultado;
    }
  }

  ///Obtiene las ciudades relacionados a una provincia.
  ///@param codigoPais identificador del pais.
  ///@param codigoAdminUno identificador de la provincia.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@param resultado lista de los resultados.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@param body cuerpo de la consulta decodificado a utf8.
  ///@param lista lista parseada de las ciudades.
  ///@return lista con los datos de la consulta o un error.

  static Future<List> obtenerCiudades(String codigoPais, String codigoAdminUno) async {
    var getConsult = Uri.parse(URL+"/ciudades?codigo_pais="+codigoPais+'&codigo_admin_uno='+codigoAdminUno); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados y la flag del estado.
    try {
      final respuesta = await http.get(getConsult); //Datos sin parecear de la consulta http.
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
        String body = utf8.decode(respuesta.bodyBytes); //Body cuerpo de la consulta decodificado a utf8.
        List<Territorio> lista = parsearRespuesta(body); //Lista parseada de las rutinas.
        resultado.add(respuesta.statusCode);
        resultado.add(lista);
        return resultado;
      } else {
        resultado.add(respuesta.statusCode);
        resultado.add(respuesta.body);
        return resultado;
      }
    } catch (e) {
      resultado.add(e.message);
      return resultado;
    }
  }

}