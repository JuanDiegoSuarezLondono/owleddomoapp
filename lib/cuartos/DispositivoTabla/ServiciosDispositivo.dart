import 'dart:convert';
import 'Dispositivo.dart';
import 'package:http/http.dart'as http;

///Esta clase se encarga de implementar una arquitectura REST para consumir la API
///que comunica con la tabla de rel_persona_producto base de datos.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param URL dirección principal de la API.
///@see owleddomo_app/cuartos/DispositivoTabla/DispositivosLista#class().
///@see owleddomo_app/cuartos/DispositivoTabla/InterfazInformacionDispositivo#class().
///@see owleddomo_app/cuartos/DispositivoTabla/InterfazEditarDispositivo#class().
///@see owleddomo_app/cuartos/DispositivoTabla/InterfazAgregarDispositivo#class().

class ServiciosDispositivo {

  static const URL = "https://48qs4b5zlg.execute-api.sa-east-1.amazonaws.com/test/appusuario/dispositivoapi"; //Url principal que provee las API.

  ///Metodo usado para castear la respuesta desde un String que contiene
  ///la informacion de las entidades requeridas a una lista de objetos para
  ///su uso como tal.
  ///@param respuesta respuesta de la consulta http.
  ///@return lista mapeada de todos los dispositivos obtenidos.

  static List<Dispositivo> parsearRespuesta(String respuesta) {
    final parsed = json.decode(respuesta).cast<Map<String, dynamic>>();
    return parsed.map<Dispositivo>((json) => Dispositivo.fromJson(json)).toList();
  }

  ///Obtiene los dispositivos relacionados a una persona.
  ///@param usuario identificador del dueño.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@param resultado lista de los resultados.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@param body cuerpo de la consulta decodificado a utf8.
  ///@param lista lista parseada de los dispositivos.
  ///@return lista con los datos de la consulta o un error.

  static Future<List> todosDispositivo(String usuario) async {
    var getConsult = Uri.parse(URL+"?"+"persona_id="+usuario); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados y la flag del estado.
    try {
      final respuesta = await http.get(getConsult); //Datos sin parecear de la consulta http.
      print('Get dispositivos Status ${respuesta.statusCode}');
      print('Get dispositivos Body ${respuesta.body}');
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
        String body = utf8.decode(respuesta.bodyBytes); //Body cuerpo de la consulta decodificado a utf8.
        List<Dispositivo> lista = parsearRespuesta(body); //Lista parseada de los dispositivos.
        resultado.add(respuesta.statusCode);
        resultado.add(lista);
        return resultado;
      } else {
        resultado.add(respuesta.statusCode);
        resultado.add(respuesta.body);
        return resultado;
      }
    } catch (e) {
      print('Get dispositivos error ${e.message}');
      resultado.add(e.message);
      return resultado;
    }
  }

  ///Agrega un producto nuevo de un usuario a la base de datos.
  ///@param producto_id identificador único del producto.
  ///@param usuario identificador del dueño.
  ///@param nombre nombre del producto.
  ///@param path_foto path del producto en el dispositivo.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@param resultado lista de los resultados.
  ///@param map mapeo de las variables a enviar.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@return lista con los datos de la consulta o un error.

  static Future<List> agregarDispositivo(String producto_id, String usuario,
                                           String nombre, String path_foto) async {
    var getConsult = Uri.parse(URL+"/agregar"); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados.
    try {
      var map = Map<String, dynamic>(); //Mapeo de las variables a enviar.
      map['MAC'] = producto_id;
      map['persona_id'] = usuario;
      map['nombre'] = nombre;
      map['url_foto'] = path_foto;
      final respuesta = await http.patch(getConsult, body: map); //Respuesta datos sin parecear de la consulta http.
      resultado.add(respuesta.statusCode);
      resultado.add(respuesta.body);
      return resultado;
    } catch (e) {
      resultado.add(e.message);
      return resultado;
    }
  }

  ///Actualiza un producto de la base de datos.
  ///@param producto_id identificador único del producto.
  ///@param usuario identificador del dueño.
  ///@param nombre nombre del producto.
  ///@param path_foto path del producto en el dispositivo.
  ///@param resultado lista de los resultados.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@param map mapeo de las variables a enviar.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@return lista con los datos de la consulta o un error.

  static Future<List> actualizarDispositivo( String producto_id,
                                               String usuario,
                                               String nombre,
                                               String path_foto) async {
    var getConsult = Uri.parse(URL+"/actualizar"); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados.
    try {
      var map = Map<String, dynamic>(); //Mapeo de las variables a enviar.
      map['MAC'] = producto_id;
      map['persona_id'] = usuario;
      map['nombre'] = nombre;
      map['url_foto'] = path_foto;
      final respuesta = await http.patch(getConsult, body: map); //Respuesta datos sin parecear de la consulta http.
      resultado.add(respuesta.statusCode);
      resultado.add(respuesta.body);
      return resultado;
    } catch (e) {
      resultado.add(e.message);
      return resultado;
    }
  }

  ///Desvincula un producto del usuario de la base de datos.
  ///@param producto_id identificador único del producto.
  ///@param usuario identificador del dueño.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@param resultado lista de los resultados.
  ///@param map mapeo de las variables a enviar.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@return lista con los datos de la consulta o un error.

  static Future<List> borrarDispositivo(String producto_id, String usuario) async {
    var getConsult = Uri.parse(URL+"/desvincular"); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados.
    try {
      var map = Map<String, dynamic>(); //Mapeo de las variables a enviar.
      map['relacion_id'] = producto_id;
      map['persona_id'] = usuario;
      final respuesta = await http.patch(getConsult, body: map); //Respuesta datos sin parecear de la consulta http.
      resultado.add(respuesta.statusCode);
      resultado.add(respuesta.body);
      return resultado;
    } catch (e) {
      resultado.add(e.message);
      return resultado;
    }
  }

  ///Obtiene todos los dispositivos del cuarto suministrado.
  ///@param cuartoId cuarto de los dispositivos.
  ///@param usuario identificador del dueño.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@param resultado lista de los resultados y la flag del estado.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@param lista lista parseada de los dispositivos.
  ///@return lista con los datos de la consulta o un error.

  static Future<List> dispositivoCuarto(String cuartoId, String usuario) async {
    var getConsult = Uri.parse(URL+"/decuarto?cuarto_id="+cuartoId+"&usuario="+usuario); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados y la flag del estado.
    try {
      final respuesta = await http.get(getConsult); //Datos sin parecear de la consulta http.
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
        List<Dispositivo> lista = parsearRespuesta(respuesta.body); //Lista lista parseada de los dispositivos.
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




