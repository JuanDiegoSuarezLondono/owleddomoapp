import 'dart:convert';
import 'Rutina.dart';
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

class ServiciosRutina {

  static const URL = "https://zmyanb1bc1.execute-api.sa-east-1.amazonaws.com/test/appusuario/rutinaapi";

  ///Metodo usado para castear la respuesta desde un String que contiene
  ///la informacion de las entidades requeridas a una lista de objetos para
  ///su uso como tal.
  ///@param respuesta respuesta de la consulta http.
  ///@return lista mapeada de todas las rutinas obtenidas.

  static List<Rutina> parsearRespuesta(String respuesta) {
    final parsed = json.decode(respuesta).cast<Map<String, dynamic>>();
    return parsed.map<Rutina>((json) => Rutina.fromJson(json)).toList();
  }

  ///Obtiene las rutinas relacionadas a una persona.
  ///@param resultado lista de los resultados y la flag del estado.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@param lista lista parseada de las rutinas.
  ///@return lista de variables y un flag de "EXITO" en la primera posición
  ///en caso de recibir datos, solo un flag de "VACIO" en caso de no tener
  ///datos o solo un mensaje de error ("LOCAL/SERVIDOR/OTRO") en caso de presentarse.

  static Future<List> todasRutinas(String usuario) async {
    var getConsult = Uri.parse(URL+"?persona_id="+usuario); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados y la flag del estado.
    try {
      final respuesta = await http.get(getConsult); //Datos sin parecear de la consulta http.
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300 && respuesta.body != "[]") {
        List<Rutina> lista = parsearRespuesta(respuesta.body); //Lista parseada de las rutinas.
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

  ///Agrega una rutina nueva de un usuario a la base de datos.
  ///@param usuario identificador del dueño.
  ///@param producto el id del producto relacionado a la rutina.
  ///@param nombre nombre de la rutina.
  ///@param activo si la rutina esta activada o no.
  ///@param relacionDispositivo identificador unico de la rutina en el hardware.
  ///@param dias código de siete binarios que representan los días de la semana,
  ///indicando cuales está activa la rutina.
  ///@param tiempo hora y minutos en los que la rutina ejecuta la acción.
  ///@param acciones acciónes a ejecutarse en cada variable cuando el tiempo se cumpla.
  ///@param map mapeo de las variables a enviar.
  ///@param getConsult construye el cuerpo de las peticiones y las parcea a URI.
  ///@param respuesta respuesta datos sin parecear del dispositivo consulta http.
  ///@param respuestaDB respuesta datos sin parecear de la base de datos consulta http.
  ///@return un flag de "EXITO" en caso que todo vaya bien, un flag de "NEL PASTEL"
  ///en caso de que el dispositivo ya esté en uso o un mensaje de error
  ///("LOCAL/SERVIDOR/OTRO") en caso de presentarse.

  static Future<String> agregarRutina(String usuario, String producto, String nombre,
                                      String activo, String relacionDispositivo,
                                      String dias, String tiempo, String acciones) async {
    var getConsult = Uri.parse(URL+"/hardware"); //Construye el cuerpo de las peticiones y las parcea a URI.
    try {
      var map = Map<String, dynamic>(); //Mapeo de las variables a enviar.
      map['persona_id'] = usuario;
      map['MAC'] = producto;
      map['nombre'] = nombre;
      map['Dato12'] = activo;
      map['Dato10'] = relacionDispositivo;
      map['Dato11'] = "1";
      map['Dato14'] = dias;
      map['Dato13'] = tiempo  ;
      map['Dato15'] = acciones;
      final respuesta = await http.post(getConsult, body: map); //Respuesta datos sin parecear del dispositivo consulta http.
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300 && respuesta.body != "Ocupado") {
        getConsult = Uri.parse(URL+"/db");
        try {
          final respuestaDB = await http.post(getConsult, body: map); //Respuesta datos sin parecear de la base de datos consulta http.
          if (respuestaDB.statusCode >= 200 && respuestaDB.statusCode < 300 && respuestaDB.body != "Ocupado") {
            return "EXITO";
          } else if (respuestaDB.statusCode >= 200 && respuestaDB.body == "Ocupado" ) {
            return "NEL PASTEL";
          } else if (respuestaDB.statusCode >= 400 && respuestaDB.statusCode < 500 ) {
            return "LOCAL";
          } else if (respuestaDB.statusCode >= 500 && respuestaDB.statusCode < 600 ) {
            return "SERVIDOR";
          } else {
            return "OTRO";
          }
        } catch (e) {
          return e.message;
        }
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

  ///Actualiza una rutina de la base de datos.
  ///@param usuario identificador del dueño.
  ///@param rutina_id id de la rutina a actualizar.
  ///@param producto el id del producto relacionado a la rutina.
  ///@param relacionDispositivo identificador unico de la rutina en el hardware.
  ///@param dias código de siete binarios que representan los días de la semana,
  ///indicando cuales está activa la rutina.
  ///@param tiempo hora y minutos en los que la rutina ejecuta la acción.
  ///@param acciones acciónes a ejecutarse en cada variable cuando el tiempo se cumpla.
  ///@param map mapeo de las variables a enviar.
  ///@param getConsult construye el cuerpo de las peticiones y las parcea a URI.
  ///@param respuesta respuesta datos sin parecear del dispositivo consulta http.
  ///@param respuestaDB respuesta datos sin parecear de la base de datos consulta http.
  ///@return un flag de "EXITO" en caso que todo vaya bien, un flag de "NEL PASTEL"
  ///en caso de que el dispositivo sea de otro usuario o un mensaje de error
  ///("LOCAL/SERVIDOR/OTRO") en caso de presentarse.

  static Future<String> actualizarRutina( String usuario, String rutina_id,
                                          String producto, String relacionDispositivo,
                                          String dias, String tiempo, String acciones) async {
    var getConsult = Uri.parse(URL+"/hardware"); //Construye el cuerpo de las peticiones y las parcea a URI.
    try {
      var map = Map<String, dynamic>(); //Mapeo de las variables a enviar.
      map['rutina_id'] = rutina_id;
      map['MAC'] = producto;
      map['persona_id'] = usuario;
      map['Dato10'] = relacionDispositivo;
      map['Dato14'] = dias;
      map['Dato13'] = tiempo  ;
      map['Dato15'] = acciones;
      final respuesta = await http.patch(getConsult, body: map); //Respuesta datos sin parecear del dispositivo consulta http.
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300 && respuesta.body != "Ocupado") {
        getConsult = Uri.parse(URL+"/db");
        try {
          final respuestaDB = await http.patch(getConsult, body: map); //Respuesta datos sin parecear de la base de datos consulta http.
          if (respuestaDB.statusCode >= 200 && respuestaDB.statusCode < 300 && respuestaDB.body != "Ocupado") {
            return "EXITO";
          } else if (respuestaDB.statusCode >= 200 && respuestaDB.body == "Ocupado" ) {
            return "NEL PASTEL";
          } else if (respuestaDB.statusCode >= 400 && respuestaDB.statusCode < 500 ) {
            return "LOCAL";
          } else if (respuestaDB.statusCode >= 500 && respuestaDB.statusCode < 600 ) {
            return "SERVIDOR";
          } else {
            return "OTRO";
          }
        } catch (e) {
          return e.message;
        }
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

  ///Actualiza una rutina para activarla o desactivarla.
  ///@param usuario identificador del dueño.
  ///@param rutina_id id de la rutina a actualizar.
  ///@param producto el id del producto relacionado a la rutina.
  ///@param relacionDispositivo identificador unico de la rutina en el hardware.
  ///@param activo si la rutina esta activada o no.
  ///@param map mapeo de las variables a enviar.
  ///@param getConsult construye el cuerpo de las peticiones y las parcea a URI.
  ///@param respuesta respuesta datos sin parecear del dispositivo consulta http.
  ///@param respuestaDB respuesta datos sin parecear de la base de datos consulta http.
  ///@return un flag de "EXITO" en caso que todo vaya bien, un flag de "NEL PASTEL"
  ///en caso de que el dispositivo sea de otro usuario o un mensaje de error
  ///("LOCAL/SERVIDOR/OTRO") en caso de presentarse.

  static Future<String> activarRutina( String usuario, String rutina_id,
                                       String producto, String activo, String relacionDispositivo) async {
    var getConsult = Uri.parse(URL+"/hardware/activar"); //Construye el cuerpo de las peticiones y las parcea a URI.
    try {
      var map = Map<String, dynamic>(); //Mapeo de las variables a enviar.
      map['rutina_id'] = rutina_id;
      map['MAC'] = producto;
      map['persona_id'] = usuario;
      map['Dato10'] = relacionDispositivo;
      map['Dato12'] = activo;
      final respuesta = await http.patch(getConsult, body: map); //Respuesta datos sin parecear del dispositivo consulta http.
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300 && respuesta.body != "Ocupado") {
        getConsult = Uri.parse(URL+"/db/activar");
        try {
          final respuestaDB = await http.patch(getConsult, body: map); //Respuesta datos sin parecear de la base de datos consulta http.
          if (respuestaDB.statusCode >= 200 && respuestaDB.statusCode < 300 && respuestaDB.body != "Ocupado") {
            return "EXITO";
          } else if (respuestaDB.statusCode >= 200 && respuestaDB.body == "Ocupado" ) {
            return "NEL PASTEL";
          } else if (respuestaDB.statusCode >= 400 && respuestaDB.statusCode < 500 ) {
            return "LOCAL";
          } else if (respuestaDB.statusCode >= 500 && respuestaDB.statusCode < 600 ) {
            return "SERVIDOR";
          } else {
            return "OTRO";
          }
        } catch (e) {
          return e.message;
        }
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

  ///Borra una rutina del usuario de la base de datos.
  ///@param usuario identificador del dueño.
  ///@param rutina_id id de la rutina a actualizar.
  ///@param producto el id del producto relacionado a la rutina.
  ///@param relacionDispositivo identificador de la rutina en el dispositivo.
  ///@param map mapeo de las variables a enviar.
  ///@param getConsult construye el cuerpo de las peticiones y las parcea a URI.
  ///@param respuesta respuesta datos sin parecear del dispositivo consulta http.
  ///@param respuestaDB respuesta datos sin parecear de la base de datos consulta http
  ///@return un flag de "EXITO" en caso que todo vaya bien, un flag de "NEL PASTEL"
  ///en caso de que el dispositivo sea de otro usuario o un mensaje de error
  ///("LOCAL/SERVIDOR/OTRO") en caso de presentarse.

  static Future<String> borrarRutina(String usuario, String rutina_id, String producto,
                                     String relacionDispositivo) async {
    var getConsult = Uri.parse(URL+"/hardware?rutina_id="+rutina_id+"&persona_id="+usuario
                               +"&MAC="+producto+"&Dato10="+relacionDispositivo+"&Dato11=0"); //Construye el cuerpo de las peticiones y las parcea a URI.
    try {
      final respuesta = await http.delete(getConsult); //Respuesta datos sin parecear del dispositivo consulta http.
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300 && respuesta.body != "Ocupado") {
        getConsult = Uri.parse(URL+"/db?rutina_id="+rutina_id+"&persona_id="+usuario
                               +"&MAC="+producto+"&Dato10="+relacionDispositivo+"&Dato11=0");
        try {
          final respuestaDB = await http.delete(getConsult); //Respuesta datos sin parecear de la base de datos consulta http.
          if (respuestaDB.statusCode >= 200 && respuestaDB.statusCode < 300 && respuestaDB.body != "Ocupado") {
            return "EXITO";
          } else if (respuestaDB.statusCode >= 200 && respuestaDB.body == "Ocupado" ) {
            return "NEL PASTEL";
          } else if (respuestaDB.statusCode >= 400 && respuestaDB.statusCode < 500 ) {
            return "LOCAL";
          } else if (respuestaDB.statusCode >= 500 && respuestaDB.statusCode < 600 ) {
            return "SERVIDOR";
          } else {
            return "OTRO";
          }
        } catch (e) {
          return e.message;
        }
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
