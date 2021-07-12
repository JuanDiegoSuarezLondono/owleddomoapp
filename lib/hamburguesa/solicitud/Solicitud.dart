///Esta clase se encarga de construir la plantilla para la entidad de cuarto.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param cuarto_id id única del cuarto.
///@param nombre nombre del cuarto.
///@param pathImagen Path de la imagen en los assets.
///@param descripcion descripción del cuarto.
///@see owleddomo_app/cuartos/CuartoTabla/CuartosLista.dart#class().
///@see owleddomo_app/cuartos/CuartoTabla/ServiciosCuarto.dart#class().

class Solicitud {
  String permiso_id = "0"; //Id única del cuarto.
  String apodo = "No hay apodo"; //Nombre del cuarto.
  String nombres = "No hay nombres"; //Path de la imagen en los assets.
  String apellidos = "No hay apellidos"; //Descripción del cuarto.
  String tipo = "No hay tipos"; //Descripción del cuarto.
  String nombre = "No hay nombre"; //Descripción del cuarto.
  String estado = "No hay estado"; //Descripción del cuarto.
  int editar = 0; //Descripción del cuarto.

  Solicitud({this.permiso_id, this.apodo, this.nombres, this.apellidos, this.tipo,
             this.nombre, this.estado, this.editar}); //Constructor de la clase.

  ///Recibe un cuarto en formato json y se encarga de transformarlo una
  ///instancia de esta clase.
  ///@param json cuarto en formato json.

  factory Solicitud.fromJson(Map<String, dynamic> json) {
    return Solicitud(
      permiso_id: json['permiso_id'] as String,
      apodo: json['apodo'] as String,
      nombres: json['nombres'] as String,
      apellidos: json['apellidos'] as String,
      tipo: json['tipo'] as String,
      nombre: json['nombre'] as String,
      estado: json['estado'] as String,
      editar: json['editar'] as int,
    );
  }
}