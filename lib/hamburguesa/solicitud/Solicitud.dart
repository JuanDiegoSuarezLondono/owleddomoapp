///Esta clase se encarga de construir la plantilla para la entidad de cuarto.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param permiso_id id única del permiso.
///@param apodo apodo del propietario.
///@param nombres nombres del propietario.
///@param apellidos apellidos del propietario.
///@param tipo tipo de dispositivo compartido.
///@param nombre nombre del dispositivo.
///@param estado estado de la peticion.
///@param editar indicación si se le permite editar.
///@see owleddomo_app/hamburguesa/solicitud/Solicitud.dart#class().
///@see owleddomo_app/hamburguesa/solicitud/SolicitudMain.dart#class().

class Solicitud {
  String permiso_id = "0"; //Id única del permiso.
  String apodo = "No hay apodo"; //Apodo del propietario.
  String nombres = "No hay nombres"; //Nombres del propietario.
  String apellidos = "No hay apellidos"; //Apellidos del propietario.
  String tipo = "No hay tipos"; //Tipo de dispositivo compartido.
  String nombre = "No hay nombre"; //Nombre del dispositivo.
  String estado = "No hay estado"; //Estado de la peticion.
  int editar = 0; //Indicación si se le permite editar.

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