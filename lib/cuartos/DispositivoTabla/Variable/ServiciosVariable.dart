import 'dart:convert';
import 'Variable.dart';
import 'package:http/http.dart'as http;

///Esta clase se encarga de implementar una arquitectura REST para consumir la API
///que comunica con la tabla de rel_persona_variable base de datos.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param URL dirección principal de la API.
///@see owleddomo_app/cuartos/DispositivoTabla/InterfazInformacionDispositivo.dart#class().
///@see owleddomo_app/cuartos/DispositivoTabla/Variable/InterruptorLuz.dart#class().
///@see owleddomo_app/cuartos/DispositivoTabla/Variable/LuzRGB.dart#class().

class ServiciosVariable{

  static const URL = "https://o6vrtl78zb.execute-api.us-east-2.amazonaws.com/test/appusuario/variableapi"; //Url principal que provee las API.

  ///Metodo usado para castear la respuesta desde un String que contiene
  ///la informacion de las entidades requeridas a una lista de objetos para
  ///su uso como tal.
  ///@param respuesta respuesta de la consulta http.
  ///@return lista mapeada de todas las variables obtenidas.

  static List<Variable> parsearRespuesta(String respuesta) {
    final parsed = json.decode(respuesta).cast<Map<String, dynamic>>();
    return parsed.map<Variable>((json) => Variable.fromJson(json)).toList();
  }

  ///Obtiene las variables relacionadas a un dispositivo.
  ///@param resultado lista de los resultados y la flag del estado.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@param lista lista parseada de las variables.
  ///@param MAC identificador del dispositivo.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@return lista de variables y un flag de "EXITO" en la primera posición
  ///en caso de recibir datos, solo un flag de "VACIO" en caso de no tener
  ///datos o solo un mensaje de error ("LOCAL/SERVIDOR/OTRO") en caso de presentarse.

  static Future<List> variableByMAC(String MAC) async {
    var getConsult = Uri.parse(URL+"?"+"MAC="+MAC); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados y la flag del estado.
    try {
      final respuesta = await http.get(getConsult); //Datos sin parecear de la consulta http.
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300 && respuesta.body != "[]") {
        List<Variable> lista = parsearRespuesta(respuesta.body); //Lista lista parseada de las variables.
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

  ///Actualiza una variable tanto en la base de datos como en el hardware.
  ///@param relacionId identificador único la variable.
  ///@param valor nuevo valor a actualizar.
  ///@param MAC identificador del producto de la variable.
  ///@param relacion_dispositivo diferenciador de la variable en el hardware.
  ///@param map mapeo de las variables a enviar.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@return un flag de "EXITO" en caso que todo vaya bien o un mensaje de error
  ///("LOCAL/SERVIDOR/OTRO") en caso de presentarse.

  static Future<String> actualizarVariable( String relacionId, String valor, String MAC, String relacion_dispositivo) async {
    var getConsult = Uri.parse(URL); //Construye el cuerpo de la petición y lo parcea a URI.
    try {
      var map = Map<String, dynamic>();
      map['relacion_id'] = relacionId;
      map['valor'] = valor;
      map['MAC'] = MAC;
      map[relacion_dispositivo] = valor;
      final respuesta = await http.patch(getConsult, body: map); //Respuesta datos sin parecear de la consulta http.
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
        return "EXITO";
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
