import 'dart:convert';
import 'package:owleddomoapp/hamburguesa/solicitud/Solicitud.dart';
import 'package:http/http.dart'as http;

///Esta clase se encarga de implementar una arquitectura REST para consumir la API
///que comunica con la tabla de permisos en base de datos.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param URL dirección principal de la API.
///@see owleddomo_app/shared/MenuHamburguesa#class().
///@see owleddomo_app/hamburguesa/solicitud/CartaSolicitud#class().
///@see owleddomo_app/hamburguesa/solicitud/SolicitudMain#class().

class ServiciosSolicitud {

  static const URL = "https://zmyanb1bc1.execute-api.sa-east-1.amazonaws.com/test/appusuario/hamburguesa/solicitud"; //Url principal que provee las API.

  ///Metodo usado para castear la respuesta desde un String que contiene
  ///la informacion de las entidades requeridas a una lista de objetos para
  ///su uso como tal.
  ///@param respuesta respuesta de la consulta http.
  ///@return lista mapeada de todos los dispositivos obtenidos.

  static List<Solicitud> parsearRespuesta(String respuesta) {
    final parsed = json.decode(respuesta).cast<Map<String, dynamic>>();
    return parsed.map<Solicitud>((json) => Solicitud.fromJson(json)).toList();
  }

  ///Obtiene las solicitudes relacionadas a una persona.
  ///@param usuario identificador del dueño.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@param resultado lista de los resultados.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@param body cuerpo de la consulta decodificado a utf8.
  ///@param lista lista parseada de las solicitudes.
  ///@return lista con los datos de la consulta o un error.

  static Future<List> todasSolicitud(String usuario) async {
    var getConsult = Uri.parse(URL+"?"+"persona_id="+usuario); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados y la flag del estado.
    try {
      final respuesta = await http.get(getConsult); //Datos sin parecear de la consulta http.
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
        String body = utf8.decode(respuesta.bodyBytes); //Body cuerpo de la consulta decodificado a utf8.
        List<Solicitud> lista = parsearRespuesta(body); //Lista parseada de los dispositivos.
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

  ///Obtiene las solicitudes aceptadas en un dispositivo.
  ///@param usuario identificador del dueño.
  ///@param producto_id identificador del producto de las solicitudes.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@param resultado lista de los resultados.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@param lista lista parseada de los dispositivos.
  ///@return lista con los datos de la consulta o un error.

  static Future<List> dispositivoSolicitud(String usuario, String producto_id) async {
    var getConsult = Uri.parse(URL+"/propietario?"+"persona_id="+usuario+"&MAC="+producto_id); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados y la flag del estado.
    try {
      final respuesta = await http.get(getConsult); //Datos sin parecear de la consulta http.
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
        String body = utf8.decode(respuesta.bodyBytes); //Body cuerpo de la consulta decodificado a utf8.
        List<Solicitud> lista = parsearRespuesta(body); //Lista parseada de los dispositivos.
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

  ///Envia una solicitud a un usuario de un producto.
  ///@param producto_id identificador único del producto.
  ///@param usuario identificador del dueño.
  ///@param nombre nombre del producto.
  ///@param path_foto path del producto en el dispositivo.
  ///@param map mapeo de las variables a enviar.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@return lista con los datos de la consulta o un error.

  static Future<List> agregarSolicitud(String usuario, String producto_id, String codigo_usuario) async {
    var getConsult = Uri.parse(URL); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados.
    try {
      var map = Map<String, dynamic>(); //Mapeo de las variables a enviar.
      map['usuario'] = usuario;
      map['MAC'] = producto_id;
      map['codigo_usuario'] = codigo_usuario;
      final respuesta = await http.post(getConsult, body: map); //Respuesta datos sin parecear de la consulta http.
      resultado.add(respuesta.statusCode);
      resultado.add(respuesta.body);
      return resultado;
    } catch (e) {
      resultado.add(e.message);
      return resultado;
    }
  }

  ///Acepta la solicitud.
  ///@param usuario identificador del dueño.
  ///@param permiso_id identificador del permiso.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@param resultado lista de los resultados.
  ///@param map mapeo de las variables a enviar.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@return lista con los datos de la consulta o un error.

  static Future<List> aceptarSolicitud(String usuario,String permiso_id) async {
    var getConsult = Uri.parse(URL); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados.
    try {
      var map = Map<String, dynamic>(); //Mapeo de las variables a enviar.
      map['usuario'] = usuario;
      map['permiso_id'] = permiso_id;
      final respuesta = await http.patch(getConsult, body: map); //Respuesta datos sin parecear de la consulta http.
      resultado.add(respuesta.statusCode);
      resultado.add(respuesta.body);
      return resultado;
    } catch (e) {
      resultado.add(e.message);
      return resultado;
    }
  }

  ///Negar la solicitud.
  ///@param usuario identificador del dueño.
  ///@param permiso_id identificador del permiso.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@param resultado lista de los resultados.
  ///@param map mapeo de las variables a enviar.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@return lista con los datos de la consulta o un error.

  static Future<List> negarSolicitud(String usuario, String permiso_id) async {
    var getConsult = Uri.parse(URL+"?usuario="+usuario+"&permiso_id="+permiso_id); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados.
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