
///Esta clase se encarga de construir la plantilla para la entidad de cuarto.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param cuarto_id id única del cuarto.
///@param nombre nombre del cuarto.
///@param pathImagen Path de la imagen en los assets.
///@param descripcion descripción del cuarto.
///@see owleddomo_app/cuartos/CuartoTabla/CuartosLista.dart#class().
///@see owleddomo_app/cuartos/CuartoTabla/ServiciosCuarto.dart#class().

class Cuarto {
  String cuarto_id = "0"; //Id única del cuarto.
  String nombre = "No hay nombre"; //Nombre del cuarto.
  String pathImagen = "No hay imagen"; //Path de la imagen en los assets.
  String descripcion = "No hay descripcion"; //Descripción del cuarto.

  Cuarto({this.cuarto_id, this.nombre, this.pathImagen, this.descripcion}); //Constructor de la clase.

  ///Recibe un cuarto en formato json y se encarga de transformarlo una
  ///instancia de esta clase.
  ///@param json cuarto en formato json.

  factory Cuarto.fromJson(Map<String, dynamic> json) {
    return Cuarto(
      cuarto_id: json['cuarto_id'] as String,
      nombre: json['nombre'] as String,
      pathImagen: json['path_imagen'] as String,
      descripcion: json['descripcion'] as String,
    );
  }
}
