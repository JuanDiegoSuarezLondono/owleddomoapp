///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param territorio_id id única del territorio.
///@param nombre nombre del territorio.
///@param codigo_caracteristica codigo del tipo de territorio.
///@param codigo_pais codigo del pais.
///@param codigo_admin_uno codigo de la provincia.
///@param codigo_admin_dos codigo de la ciudad.
///@see owleddomo_app/login/LoginMain.dart#class().
///@see owleddomo_app/login/territorio/ServiciosTerritorio.dart#class().
class Territorio {
  int territorio_id = 0; //Id única del territorio.
  String nombre = "No hay nombre"; //Nombre del territorio.
  String codigo_caracteristica = "No hay codigo caracteristico"; //Codigo del tipo de territorio.
  String codigo_pais = "No hay nivel administrativo"; //Codigo del pais.
  String codigo_admin_uno = "No pertenece a nada"; //Codigo de la provincia.
  String codigo_admin_dos = "No hay nivel administrativo"; //Codigo de la ciudad.
  Territorio({this.territorio_id, this.nombre, this.codigo_caracteristica, this.codigo_pais,
              this.codigo_admin_uno, this.codigo_admin_dos}); //Constructor de la clase.

  ///Recibe un territorio en formato json y se encarga de transformarlo una
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