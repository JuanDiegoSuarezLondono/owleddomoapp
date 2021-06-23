///Esta clase se encarga de construir la plantilla para la entidad de persona.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param persona_id id única de la persona.
///@param territorio_id ciudad de residencia de la persona.
///@param nombres primer y segundo nombre de la persona.
///@param apellidos primer y segundo apellido de la persona.
///@param telefono numero telefónico de la persona.
///@param fecha_nacimiento fecha de nacimiento de la persona.
///@param correo_electronico correo electrónico asociado a la cuenta.
///@param url_foto direccion de almacenamiento de la foto de perfil de la cuenta.
///@param rol papel que desempeña esa cuenta.
///@param apodo mute con el que desea ser reconocida la persona en la cuenta.
///@see owleddomo_app/cuartos/DisporitivoTabla/DispositivosLista.dart#class().
///@see owleddomo_app/cuartos/DispositivoTabla/ServiciosDispositivo.dart#class().

class Persona {
  String persona_id = "0"; //Id única de la persona.
  int territorio_id = 0; //Ciudad de residencia de la persona.
  String nombres = "No hay nombre"; //Primer y segundo nombre de la persona.
  String apellidos = "No hay apellido"; //Primer y segundo apellido de la persona.
  String telefono = "No hay telefono"; //Numero telefónico de la persona.
  String fecha_nacimiento = "No hay fecha"; //Fecha de nacimiento de la persona.
  String correo_electronico = "No hay correo"; //Correo electrónico asociado a la cuenta.
  String url_foto = "assets/img/Imagen_no_disponible.jpg"; //Direccion de almacenamiento de la foto de perfil de la cuenta.
  String rol = "No hay roll"; //Papel que desempeña esa cuenta.
  String apodo = "No hay apodo"; //Mute con el que desea ser reconocida la persona en la cuenta.

  Persona({this.persona_id, this.territorio_id, this.nombres, this.apellidos,
    this.telefono, this.fecha_nacimiento, this.correo_electronico,
    this.url_foto, this.rol, this.apodo}); //Constructor de la clase.

  ///Recibe un dispositivo en formato json y se encarga de transformarlo una
  ///instancia de esta clase.
  ///@param json dispositivo en formato json.

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      persona_id: json['persona_id'] as String,
      territorio_id: json['territorio_id'] as int,
      nombres: json['nombres'] as String,
      apellidos: json['apellidos'] as String,
      telefono: json['telefono'] as String,
      fecha_nacimiento: json['fecha_nacimiento'] as String,
      correo_electronico: json['correo_electronico'] as String,
      url_foto: json['url_foto'] as String,
      rol: json['rol'] as String,
      apodo: json['apodo'] as String,
    );
  }
}