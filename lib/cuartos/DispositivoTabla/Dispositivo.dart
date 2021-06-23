
///Esta clase se encarga de construir la plantilla para la entidad de dispositivo.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param relacion_id id única del dispositivo.
///@param persona_id propietario del dispositivo.
///@param nombre nombre del dispositivo.
///@param url_foto path foto en el dispositivo.
///@see owleddomo_app/cuartos/DisporitivoTabla/DispositivosLista.dart#class().
///@see owleddomo_app/cuartos/DispositivoTabla/ServiciosDispositivo.dart#class().

class Dispositivo {
  String relacion_id = "0"; //Id única del dispositivo.
  String persona_id = "0"; //Propietario del dispositivo.
  String nombre = "No hay nombre"; //Nombre del dispositivo.
  String url_foto = "assets/img/Imagen_no_disponible.jpg"; //Path foto en el dispositivo.
  String fecha_modificacion = "No hay fecha"; //Última fecha de modificación del dispositivo.

  Dispositivo({this.relacion_id, this.persona_id, this.nombre, this.url_foto,
               this.fecha_modificacion}); //Constructor de la clase.

  ///Recibe un dispositivo en formato json y se encarga de transformarlo una
  ///instancia de esta clase.
  ///@param json dispositivo en formato json.

  factory Dispositivo.fromJson(Map<String, dynamic> json) {
    return Dispositivo(
      relacion_id: json['relacion_id'] as String,
      persona_id: json['persona_id'] as String,
      nombre: json['nombre'] as String,
      url_foto: json['url_foto'] as String,
      fecha_modificacion: json['fecha_modificacion'] as String,
    );
  }
}
