import 'dart:convert';
import 'Persona.dart';
import 'package:http/http.dart'as http;

///Esta clase se encarga de implementar una arquitectura REST para consumir la API
///que comunica con la tabla de personas en la base de datos.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param URL dirección principal de la API.
///@see owleddomo_app/login/LoginMain.dart.

class ServiciosPersona {

  static const URL = "https://zmyanb1bc1.execute-api.sa-east-1.amazonaws.com/test/appusuario/personaapi";

  ///Metodo usado para castear la respuesta desde un String que contiene
  ///la informacion de las entidades requeridas a una lista de objetos para
  ///su uso como tal.
  ///@param respuesta respuesta de la consulta http.
  ///@return lista mapeada de todas las personas obtenidas.

  static List<Persona> parsearRespuesta(String respuesta) {
    final parsed = json.decode(respuesta).cast<Map<String, dynamic>>();
    return parsed.map<Persona>((json) => Persona.fromJson(json)).toList();
  }

  ///Obtiene las personas relacionadas a un usuario y una clave.
  ///@param usuario identificador del usuario que quiere ingresar.
  ///@param clave contraseña del usuario que quiere ingresar.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@param resultado lista de los resultados y la flag del estado.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@param body cuerpo de la consulta decodificado a utf8.
  ///@param lista lista parseada de las rutinas.
  ///@return lista con los datos de la consulta o un error.

  static Future<List> login(String usuario, String clave) async {
    var getConsult = Uri.parse(URL+"?persona_id="+usuario+"&cl="+clave); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados y la flag del estado.
    try {
      final respuesta = await http.get(getConsult); //Datos sin parecear de la consulta http.
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
        String body = utf8.decode(respuesta.bodyBytes); //Body cuerpo de la consulta decodificado a utf8.
        List<Persona> lista = parsearRespuesta(body); //Lista parseada de las rutinas.
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

  ///Obtiene las personas relacionadas a un usuario y una clave.
  ///@param correo correo a comprobar.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@param resultado lista de los resultados y la flag del estado.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@param body cuerpo de la consulta decodificado a utf8.
  ///@param lista lista parseada de las rutinas.
  ///@return lista con los datos de la consulta o un error.

  static Future<List> comprobarCorreo(String correo) async {
    var getConsult = Uri.parse(URL+"/correo?correo="+correo); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados y la flag del estado.
    try {
      final respuesta = await http.get(getConsult); //Datos sin parecear de la consulta http.
      resultado.add(respuesta.statusCode);
      resultado.add(respuesta.body);
      return resultado;
    } catch (e) {
      resultado.add(e.message);
      return resultado;
    }
  }

  ///Agrega una persona nueva a la base de datos.
  ///@param territorio_id identificador único del producto.
  ///@param nombres identificador del dueño.
  ///@param apellidos nombre del producto.
  ///@param telefono path del producto en el dispositivo.
  ///@param clave path del producto en el dispositivo.
  ///@param correoElectronico path del producto en el dispositivo.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@param resultado lista de los resultados.
  ///@param map mapeo de las variables a enviar.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@return lista con los datos de la consulta o un error.

  static Future<List> agregarUsuario(int territorio_id, String nombres, String apellidos,
                                       String telefono, String clave, String correoElectronico) async {
    var getConsult = Uri.parse(URL); //Construye el cuerpo de las peticiones y las parcea a URI.
    List resultado = []; //Lista de los resultados.
    try {
      var map = Map<String, dynamic>(); //Mapeo de las variables a enviar.
      map['territorio_id'] = territorio_id.toString();
      map['nombres'] = nombres;
      map['apellidos'] = apellidos;
      map['telefono'] = telefono;
      map['clave'] = clave;
      map['correo_electronico'] = correoElectronico;
      final respuestaCrear = await http.post(getConsult, body: map); //Respuesta datos sin parecear del dispositivo consulta http.
      getConsult = Uri.parse(URL+"/correo/activar");
      final respuestaCorreo = await http.patch(getConsult, body: map); //Respuesta datos sin parecear del dispositivo consulta http.
      resultado.add(respuestaCrear.statusCode);
      resultado.add(respuestaCrear.body);
      return resultado;
    } catch (e) {
      resultado.add(e.message);
      return resultado;
    }
  }

}