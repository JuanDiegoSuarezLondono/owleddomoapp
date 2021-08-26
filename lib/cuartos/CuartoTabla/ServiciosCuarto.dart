import 'dart:convert';
import 'Cuarto.dart';
import 'package:http/http.dart'as http;

///Esta clase se encarga de implementar una arquitectura REST para consumir la API
///que comunica con la tabla de cuartos base de datos.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param URL dirección principal de la API.
///@see owleddomo_app/cuartos/CuartoTabla/CuartosLista#class().
///@see owleddomo_app/cuartos/CuartoTabla/InterfazInformacionCuarto#class().
///@see owleddomo_app/cuartos/CuartoTabla/InterfazEditarCuarto#class().
///@see owleddomo_app/cuartos/CuartoTabla/InterfazAgregarCuarto#class().

class ServiciosCuarto {

  static const URL = "https://48qs4b5zlg.execute-api.sa-east-1.amazonaws.com/test/appusuario/cuartoapi";

  ///Metodo usado para castear la respuesta desde un String que contiene
  ///la informacion de las entidades requeridas a una lista de objetos para
  ///su uso como tal.
  ///@param respuesta respuesta de la consulta http.
  ///@return lista mapeada de todos los cuartos obtenidos.

  static List<Cuarto> parsearRespuesta(String respuesta) {
    final parsed = json.decode(respuesta).cast<Map<String, dynamic>>();
    return parsed.map<Cuarto>((json) => Cuarto.fromJson(json)).toList();
  }

  ///Obtiene los cuartos relacionados a una persona.
  ///@param usuario identificador del dueño.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@param resultado lista de los resultados.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@param body cuerpo de la consulta decodificado a utf8.
  ///@param lista lista parseada de los cuartos.
  ///@return lista con los datos de la consulta o un error.

  static Future<List> todosCuartos(String usuario) async {
    var getConsult = Uri.parse(URL+"?persona_id="+usuario); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados.
    try {
      final respuesta = await http.get(getConsult); //Datos sin parecear de la consulta http.
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
        String body = utf8.decode(respuesta.bodyBytes); //Body cuerpo de la consulta decodificado a utf8.
        List<Cuarto> lista = parsearRespuesta(body); //Lista parseada de los cuartos.
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

  ///Agrega un cuarto nuevo de un usuario a la base de datos.
  ///@param usuario identificador del dueño.
  ///@param nombre nombre del cuarto.
  ///@param pathImagen imagen del cuarto.
  ///@param descripcion descripción del cuarto.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@param resultado lista de los resultados.
  ///@param map mapeo de las variables a enviar.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@return lista con los datos de la consulta o un error.

  static Future<List> agregarCuarto(String usuario, String nombre,
                                      String pathImagen, String descripcion) async {
    var getConsult = Uri.parse(URL); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados.
    try {
      var map = Map<String, dynamic>(); //Mapeo de las variables a enviar.
      map['persona_id'] = usuario;
      map['nombre'] = nombre;
      map['path_imagen'] = pathImagen;
      map['descripcion'] = descripcion;
      final respuesta = await http.post(getConsult, body: map); //Respuesta datos sin parecear de la consulta http.
      resultado.add(respuesta.statusCode);
      resultado.add(respuesta.body);
      return resultado;
    } catch (e) {
      resultado.add(e.message);
      return resultado;
    }
  }

  ///Actualiza un cuarto de la base de datos.
  ///@param cuarto_id identificador único del cuarto.
  ///@param usuario identificador del dueño.
  ///@param nombre nombre del cuarto.
  ///@param pathImagen imagen del cuarto.
  ///@param descripcion descripción del cuarto.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@param resultado lista de los resultados.
  ///@param map mapeo de las variables a enviar.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@return lista con los datos de la consulta o un error.

  static Future<List> actualizarCuarto( String cuarto_id, String usuario,
                                        String nombre, String pathImagen,
                                        String descripcion) async {
    var getConsult = Uri.parse(URL); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados.
    try {
      var map = Map<String, dynamic>(); //Mapeo de las variables a enviar.
      map['cuarto_id'] = cuarto_id;
      map['persona_id'] =usuario;
      map['nombre'] = nombre;
      map['path_imagen'] = pathImagen;
      map['descripcion'] = descripcion;
      final respuesta = await http.put(getConsult, body: map); //Respuesta datos sin parecear de la consulta http.
      resultado.add(respuesta.statusCode);
      resultado.add(respuesta.body);
      return resultado;
    } catch (e) {
      resultado.add(e.message);
      return resultado;
    }
  }

  ///Borra un cuarto del usuario de la base de datos.
  ///@param cuarto_id identificador único del cuarto.
  ///@param usuario identificador del dueño.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@param resultado lista de los resultados.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@return lista con los datos de la consulta o un error.

  static Future<List> borrarCuarto(String cuarto_id, String usuario) async {
    var getConsult = Uri.parse(URL+"?cuarto_id="+cuarto_id+"&persona_id="+usuario); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados y la flag del estado.
    try {
      final respuesta = await http.delete(getConsult); //Respuesta datos sin parecear de la consulta http.
      resultado.add(respuesta.statusCode);
      resultado.add(respuesta.body);
      return resultado;
    } catch (e) {
      resultado.add(e.message);
      return resultado;
    }
  }
}
