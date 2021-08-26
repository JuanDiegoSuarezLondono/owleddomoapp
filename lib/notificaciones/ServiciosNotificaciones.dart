import 'dart:convert';
import 'package:http/http.dart'as http;

///Esta clase se encarga de implementar una arquitectura REST para consumir la API
///que comunica con la tabla de personas en la base de datos.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param URL dirección principal de la API.
///@see owleddomo_app/login/LoginMain.dart.

class ServiciosNotificaciones {

  static const URL = "https://48qs4b5zlg.execute-api.sa-east-1.amazonaws.com/test/appusuario/notificacionapi";

  ///Actualiza el tema en la configuracion de la persona en la base de datos.
  ///@param configuracion_id identificador de la configuración.
  ///@param usuario identificador unico del usuario.
  ///@param tema nuevo tema.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@param resultado lista de los resultados.
  ///@param map mapeo de las variables a enviar.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@return lista con los datos de la consulta o un error.

  static Future<List> notificacion(int notificacion,String datos, String tipo, String persona_id, String accion) async {
    var getConsult = Uri.parse(URL); //Construye el cuerpo de las peticiones y las parcea a URI.
    List resultado = []; //Lista de los resultados.
    try {
      var map = Map<String, dynamic>(); //Mapeo de las variables a enviar.
      map['notificacion'] = notificacion.toString();
      map['datos'] = datos;
      map['tipo'] = tipo;
      map['persona_id'] = persona_id;
      map['accion'] = accion;
      final respuesta = await http.patch(getConsult, body: map); //Respuesta datos sin parecear del dispositivo consulta http.
      resultado.add(respuesta.statusCode);
      resultado.add(respuesta.body);
      return resultado;
    } catch (e) {
      resultado.add(e.message);
      return resultado;
    }
  }

}