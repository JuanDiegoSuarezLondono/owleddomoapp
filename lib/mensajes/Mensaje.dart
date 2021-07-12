///Esta clase se encarga de construir la plantilla para la entidad de cuarto.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param cuarto_id id única del cuarto.
///@param nombre nombre del cuarto.
///@param pathImagen Path de la imagen en los assets.
///@param descripcion descripción del cuarto.
///@see owleddomo_app/cuartos/CuartoTabla/CuartosLista.dart#class().
///@see owleddomo_app/cuartos/CuartoTabla/ServiciosCuarto.dart#class().

class Mensaje {
  String accion_id = "0"; //Id única del cuarto.
  String notificacion_id = "0"; //Nombre del cuarto.
  String evento = "0"; //Path de la imagen en los assets.
  int asociacion = 0; //Descripción del cuarto.
  String asociacion_id = "0"; //Descripción del cuarto.
  String fecha_creacion = "No hay descripcion"; //Descripción del cuarto.

  Mensaje({this.accion_id, this.notificacion_id, this.evento, this.asociacion, this.asociacion_id, this.fecha_creacion}); //Constructor de la clase.

  ///Recibe un cuarto en formato json y se encarga de transformarlo una
  ///instancia de esta clase.
  ///@param json cuarto en formato json.

  factory Mensaje.fromJson(Map<String, dynamic> json) {
    return Mensaje(
      accion_id: json['accion_id'] as String,
      notificacion_id: json['nombre'] as String,
      evento: json['evento'] as String,
      asociacion: json['asociacion'] as int,
      asociacion_id: json['asociacion_id'] as String,
      fecha_creacion: json['fecha_creacion'] as String,
    );
  }
}


