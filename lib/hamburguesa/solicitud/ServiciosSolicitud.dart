import 'dart:convert';
import 'package:owleddomoapp/hamburguesa/solicitud/Solicitud.dart';
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

  ///Obtiene los dispositivos relacionados a una persona.
  ///@param resultado lista de los resultados y la flag del estado.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@param lista lista parseada de los dispositivos.
  ///@param usuario identificador del dueño.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@return lista de dispositivos y un flag de "EXITO" en la primera posición
  ///en caso de recibir datos, solo un flag de "VACIO" en caso de no tener
  ///datos o solo un mensaje de error ("LOCAL/SERVIDOR/OTRO") en caso de presentarse.

  static Future<List> todasSolicitud(String usuario) async {
    var getConsult = Uri.parse(URL+"?"+"persona_id="+usuario); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados y la flag del estado.
    try {
      final respuesta = await http.get(getConsult); //Datos sin parecear de la consulta http.
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300 && respuesta.body != "[]") {
        List<Solicitud> lista = parsearRespuesta(respuesta.body); //Lista parseada de los dispositivos.
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

  ///Obtiene los dispositivos relacionados a una persona.
  ///@param resultado lista de los resultados y la flag del estado.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@param lista lista parseada de los dispositivos.
  ///@param usuario identificador del dueño.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@return lista de dispositivos y un flag de "EXITO" en la primera posición
  ///en caso de recibir datos, solo un flag de "VACIO" en caso de no tener
  ///datos o solo un mensaje de error ("LOCAL/SERVIDOR/OTRO") en caso de presentarse.

  static Future<List> dispositivoSolicitud(String usuario, String producto_id) async {
    var getConsult = Uri.parse(URL+"/propietario?"+"persona_id="+usuario+"&MAC="+producto_id); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados y la flag del estado.
    try {
      final respuesta = await http.get(getConsult); //Datos sin parecear de la consulta http.
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300 && respuesta.body != "[]") {
        String body = utf8.decode(respuesta.bodyBytes);
        List<Solicitud> lista = parsearRespuesta(body); //Lista parseada de los dispositivos.
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

  ///Agrega un producto nuevo de un usuario a la base de datos.
  ///@param producto_id identificador único del producto.
  ///@param usuario identificador del dueño.
  ///@param nombre nombre del producto.
  ///@param path_foto path del producto en el dispositivo.
  ///@param map mapeo de las variables a enviar.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@return un flag de "EXITO" en caso que todo vaya bien, un flag de "NEL PASTEL"
  ///en caso de que el dispositivo ya esté en uso o un mensaje de error
  ///("LOCAL/SERVIDOR/OTRO") en caso de presentarse.

  static Future<String> agregarSolicitud(String producto_id, String codigo_usuario) async {
    var getConsult = Uri.parse(URL); //Construye el cuerpo de la petición y lo parcea a URI.
    try {
      var map = Map<String, dynamic>(); //Mapeo de las variables a enviar.
      map['MAC'] = producto_id;
      map['codigo_usuario'] = codigo_usuario;
      final respuesta = await http.post(getConsult, body: map); //Respuesta datos sin parecear de la consulta http.
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300 && respuesta.body != "Ocupado") {
        return "EXITO";
      } else if (respuesta.statusCode >= 200 && respuesta.body == "Ocupado" ) {
        return "NEL PASTEL";
      } else if (respuesta.statusCode >= 400 && respuesta.statusCode < 500 ) {
        return "LOCAL";
      } else if (respuesta.statusCode >= 500 && respuesta.statusCode < 600 ) {
        return "SERVIDOR";
      } else {
        return "OTRO";
      }
    } catch (e) {
      return e.message;
    }
  }

  ///Agrega un producto nuevo de un usuario a la base de datos.
  ///@param producto_id identificador único del producto.
  ///@param usuario identificador del dueño.
  ///@param nombre nombre del producto.
  ///@param path_foto path del producto en el dispositivo.
  ///@param map mapeo de las variables a enviar.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@return un flag de "EXITO" en caso que todo vaya bien, un flag de "NEL PASTEL"
  ///en caso de que el dispositivo ya esté en uso o un mensaje de error
  ///("LOCAL/SERVIDOR/OTRO") en caso de presentarse.

  static Future<String> aceptarSolicitud(String usuario,String permiso_id) async {
    var getConsult = Uri.parse(URL); //Construye el cuerpo de la petición y lo parcea a URI.
    try {
      var map = Map<String, dynamic>(); //Mapeo de las variables a enviar.
      map['usuario'] = usuario;
      map['permiso_id'] = permiso_id;
      final respuesta = await http.patch(getConsult, body: map); //Respuesta datos sin parecear de la consulta http.
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300 && respuesta.body != "Ocupado") {
        return "EXITO";
      } else if (respuesta.statusCode >= 200 && respuesta.body == "Ocupado" ) {
        return "NEL PASTEL";
      } else if (respuesta.statusCode >= 400 && respuesta.statusCode < 500 ) {
        return "LOCAL";
      } else if (respuesta.statusCode >= 500 && respuesta.statusCode < 600 ) {
        return "SERVIDOR";
      } else {
        return "OTRO";
      }
    } catch (e) {
      return e.message;
    }
  }

  static Future<String> negarSolicitud(String usuario, String permiso_id) async {
    var getConsult = Uri.parse(URL+"?usuario="+usuario+"&permiso_id="+permiso_id); //Construye el cuerpo de la petición y lo parcea a URI.
    try {
      final respuesta = await http.delete(getConsult); //Respuesta datos sin parecear de la consulta http.
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300 && respuesta.body != "Ocupado") {
        return "EXITO";
      } else if (respuesta.statusCode >= 200 && respuesta.body == "Ocupado" ) {
        return "NEL PASTEL";
      } else if (respuesta.statusCode >= 400 && respuesta.statusCode < 500 ) {
        return "LOCAL";
      } else if (respuesta.statusCode >= 500 && respuesta.statusCode < 600 ) {
        return "SERVIDOR";
      } else {
        return "OTRO";
      }
    } catch (e) {
      return e.message;
    }
  }
}