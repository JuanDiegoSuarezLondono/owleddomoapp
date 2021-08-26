import 'dart:convert';
import 'Variable.dart';
import 'package:http/http.dart'as http;

///Esta clase se encarga de implementar una arquitectura REST para consumir la API
///que comunica con la tabla de rel_persona_variable base de datos.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param URL dirección principal de la API.
///@see owleddomo_app/cuartos/DispositivoTabla/InterfazInformacionDispositivo.dart#class().
///@see owleddomo_app/cuartos/DispositivoTabla/Variable/AbiertoCerrado.dart#class().
///@see owleddomo_app/cuartos/DispositivoTabla/Variable/Alerta.dart#class().
///@see owleddomo_app/cuartos/DispositivoTabla/Variable/Golpe.dart#class().
///@see owleddomo_app/cuartos/DispositivoTabla/Variable/InterruptorLuz.dart#class().
///@see owleddomo_app/cuartos/DispositivoTabla/Variable/LuzRGB.dart#class().

class ServiciosVariable{

  static const URL = "https://48qs4b5zlg.execute-api.sa-east-1.amazonaws.com/test/appusuario/variableapi"; //Url principal que provee las API.

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
  ///@param MAC identificador del dispositivo de las variables.
  ///@param usuario identificador del dueño.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@param resultado lista de los resultados.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@param body cuerpo de la consulta decodificado a utf8.
  ///@param lista lista parseada de las variables.
  ///@param MAC identificador del dispositivo.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@return lista con los datos de la consulta o un error.

  static Future<List> variableByMAC(String MAC, String usuario) async {
    var getConsult = Uri.parse(URL+"?"+"MAC="+MAC+"&persona_id="+usuario); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados y la flag del estado.
    try {
      final respuesta = await http.get(getConsult); //Datos sin parecear de la consulta http.
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
        String body = utf8.decode(respuesta.bodyBytes); //Body cuerpo de la consulta decodificado a utf8.
        List<Variable> lista = parsearRespuesta(body); //Lista lista parseada de las variables.
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

  ///Actualiza una variable tanto en la base de datos como en el hardware.
  ///@param relacionId identificador único la variable.
  ///@param valor nuevo valor a actualizar.
  ///@param MAC identificador del producto de la variable.
  ///@param relacion_dispositivo diferenciador de la variable en el hardware.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@param resultado lista de los resultados.
  ///@param map mapeo de las variables a enviar.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@return lista con los datos de la consulta o un error.

  static Future<List> actualizarVariable( String relacionId, String valor, String MAC,
                                          String relacion_dispositivo) async {
    var getConsult = Uri.parse(URL); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados.
    try {
      var map = Map<String, dynamic>(); //Mapeo de las variables a enviar.
      map['relacion_id'] = relacionId;
      map['valor'] = valor;
      map['MAC'] = MAC;
      map[relacion_dispositivo] = valor;
      final respuesta = await http.patch(getConsult, body: map); //Respuesta datos sin parecear de la consulta http.
      resultado.add(respuesta.statusCode);
      resultado.add(respuesta.body);
      return resultado;
    } catch (e) {
      resultado.add(e.message);
      return resultado;
    }
  }
}
