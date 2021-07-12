///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param persona_id id única de la persona.
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
class Territorio {
  int territorio_id = 0;
  String nombre = "No hay nombre"; //Primer y segundo nombre de la persona.
  String codigo_caracteristica = "No hay codigo caracteristico"; //Primer y segundo apellido de la persona.
  String codigo_pais = "No hay nivel administrativo"; //Numero telefónico de la persona.
  String codigo_admin_uno = "No pertenece a nada"; //Fecha de nacimiento de la persona.
  String codigo_admin_dos = "No hay nivel administrativo"; //Numero telefónico de la persona.
  Territorio({this.territorio_id, this.nombre, this.codigo_caracteristica, this.codigo_pais,
              this.codigo_admin_uno, this.codigo_admin_dos}); //Constructor de la clase.

  ///Recibe un dispositivo en formato json y se encarga de transformarlo una
  ///instancia de esta clase.
  ///@param json dispositivo en formato json.

  factory Territorio.fromJson(Map<String, dynamic> json) {
    return Territorio(
      territorio_id: json['territorio_id'] as int,
      nombre: json['nombre'] as String,
      codigo_caracteristica: json['codigo_caracteristica'] as String,
      codigo_pais: json['codigo_pais'] as String,
      codigo_admin_uno: json['codigo_admin_uno'] as String,
      codigo_admin_dos: json['codigo_admin_dos'] as String,
    );
  }
}