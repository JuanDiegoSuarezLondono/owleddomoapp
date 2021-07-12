import 'dart:convert';
import 'package:owleddomoapp/mensajes/Mensaje.dart';
import 'package:owleddomoapp/login/Persona.dart';
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

class ServiciosMensaje {

  static const URLM = "https://zmyanb1bc1.execute-api.sa-east-1.amazonaws.com/test/appusuario/mensajeapi";
  static const URLN = "https://zmyanb1bc1.execute-api.sa-east-1.amazonaws.com/test/appusuario/notificacionapi";

  ///Metodo usado para castear la respuesta desde un String que contiene
  ///la informacion de las entidades requeridas a una lista de objetos para
  ///su uso como tal.
  ///@param respuesta respuesta de la consulta http.
  ///@return lista mapeada de todos los cuartos obtenidos.

  static List<Mensaje> parsearRespuesta(String respuesta) {
    final parsed = json.decode(respuesta).cast<Map<String, dynamic>>();
    return parsed.map<Mensaje>((json) => Mensaje.fromJson(json)).toList();
  }

  ///Obtiene los cuartos relacionados a una persona.
  ///@param resultado lista de los resultados y la flag del estado.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@param lista lista parseada de los cuartos.
  ///@param usuario identificador del dueño.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@return lista de cuartos y un flag de "EXITO" en la primera posición
  ///en caso de recibir datos, solo un flag de "VACIO" en caso de no tener
  ///datos o solo un mensaje de error ("LOCAL/SERVIDOR/OTRO") en caso de presentarse.

  static Future<List> todosMensajes(Persona usuario) async {
    var getConsult = Uri.parse(URLM+"?persona_id="+usuario.persona_id); //Construye el cuerpo de la petición y lo parcea a URI.
    List resultado = []; //Lista de los resultados y la flag del estado.
    try {
      final respuesta = await http.get(getConsult); //Datos sin parecear de la consulta http.
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300 && respuesta.body != "[]") {
        List<Mensaje> lista = parsearRespuesta(respuesta.body); //Lista parseada de los cuartos.
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
/*
  ///Agrega un cuarto nuevo de un usuario a la base de datos.
  ///@param usuario identificador del dueño.
  ///@param nombre nombre del cuarto.
  ///@param pathImagen imagen del cuarto.
  ///@param descripcion descripción del cuarto.
  ///@param map mapeo de las variables a enviar.
  ///@param respuesta datos sin parecear de la consulta http.
  ///@param getConsult construye el cuerpo de la petición y lo parcea a URI.
  ///@return un flag de "EXITO" en caso que todo vaya bien, un flag de "NEL PASTEL"
  ///en caso de que el cuarto ya esté en uso o un mensaje de error
  ///("LOCAL/SERVIDOR/OTRO") en caso de presentarse.

  static Future<String> agregarCuarto(String usuario, String nombre,
      String pathImagen, String descripcion) async {
    var getConsult = Uri.parse(URL); //Construye el cuerpo de la petición y lo parcea a URI.
    try {
      var map = Map<String, dynamic>(); //Map  eo de las variables a enviar.
      map['persona_id'] = usuario;
      map['nombre'] = nombre;
      map['path_imagen'] = pathImagen;
      map['descripcion'] = descripcion;
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
    }*/
  }