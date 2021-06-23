import 'dart:convert';
import 'Persona.dart';
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

class ServiciosPersona {

  static const URL = "https://o6vrtl78zb.execute-api.us-east-2.amazonaws.com/test/appusuario/personaapi";

  ///Metodo usado para castear la respuesta desde un String que contiene
  ///la informacion de las entidades requeridas a una lista de objetos para
  ///su uso como tal.
  ///@param respuesta respuesta de la consulta http.
  ///@return lista mapeada de todas las rutinas obtenidas.

  static List<Persona> parsearRespuesta(String respuesta) {
    final parsed = json.decode(respuesta).cast<Map<String, dynamic>>();
    return parsed.map<Persona>((json) => Persona.fromJson(json)).toList();
  }

  ///Obtiene las rutinas relacionadas a una persona.
  ///@param resultado lista de los resultados y la flag del estado.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@param lista lista parseada de las rutinas.
  ///@return lista de variables y un flag de "EXITO" en la primera posición
  ///en caso de recibir datos, solo un flag de "VACIO" en caso de no tener
  ///datos o solo un mensaje de error ("LOCAL/SERVIDOR/OTRO") en caso de presentarse.

  static Future<List> login(String usuario, String clave) async {
    var getConsult = Uri.parse(URL+"?persona_id="+usuario+"&cl="+clave); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados y la flag del estado.
    try {
      final respuesta = await http.get(getConsult); //Datos sin parecear de la consulta http.
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300 && respuesta.body != "[]") {
        List<Persona> lista = parsearRespuesta(respuesta.body); //Lista parseada de las rutinas.
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

  static Future<String> agregarUsuario(int territorioId, String nombres, String apellidos,
                                       String telefono, String clave, String correoElectronico) async {

    var getConsult = Uri.parse(URL); //Construye el cuerpo de las peticiones y las parcea a URI.
    try {
      var map = Map<String, dynamic>(); //Mapeo de las variables a enviar.
      map['territorio_id'] = territorioId.toString();
      map['nombres'] = nombres;
      map['apellidos'] = apellidos;
      map['telefono'] = telefono;
      map['clave'] = clave;
      map['correo_electronico'] = correoElectronico;
      final respuesta = await http.post(getConsult, body: map); //Respuesta datos sin parecear del dispositivo consulta http.
      print(respuesta.body);
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