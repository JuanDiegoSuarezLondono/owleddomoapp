
///Esta clase se encarga de construir la plantilla para la entidad de rutina.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param rutina_id id única de la rutina.
///@param persona_producto_id id del producto relacionado.
///@param nombre nombre de la rutina.
///@param nombre_dispositivo nombre del dispositivo asociado.
///@param activo indica si esta activa la rutina.
///@param tipo indica que hace la rutina.
///@param relacion_dispositivo diferenciador de la rutina en el hardware.
///@param dias días de la rutina indicando un binario por dia de la semana.
///@param tiempo hora con minutos en la que se activa la rutina.
///@param nuevo_valor indica la acción que realiza la rutina.
///@see owleddomo_app/rutinas/RutinasLista.dart#class().
///@see owleddomo_app/rutinas/ServiciosRutina.dart#class().

class Rutina {
  String rutina_id = "0"; //Id única de la rutina.
  String persona_producto_id = "0"; //Id del producto relacionado.
  String nombre = "No hay nombre"; //Nombre de la rutina.
  String nombre_dispositivo = "No hay nombre"; //Nombre del dispositivo asociado.
  int activo = 0; //Indica si esta activa la rutina.
  String tipo = "No hay tipo"; //Indica que hace la rutina.
  String relacion_dispositivo = "No hay rutina"; //Diferenciador de la rutina en el hardware.
  String dias = "0000000"; //Días de la rutina indicando un binario por día de la semana.
  String tiempo = "00:00"; //Hora con minutos en la que se activa la rutina.
  String nuevo_valor = "0"; //Indica la acción que realiza la rutina.

  Rutina({this.rutina_id, this.persona_producto_id, this.nombre, this.nombre_dispositivo,
          this.activo, this.tipo, this.relacion_dispositivo, this.dias, this.tiempo, this.nuevo_valor}); //Constructor de la clase.

  ///Recibe una rutina en formato json y se encarga de transformarla a una
  ///instancia de esta clase.
  ///@param json rutina en formato json.

  factory Rutina.fromJson(Map<String, dynamic> json) {
    return Rutina(
      rutina_id: json['rutina_id'] as String,
      persona_producto_id: json['persona_producto_id'] as String,
      nombre: json['nombre'] as String,
      nombre_dispositivo: json['nombre_dispositivo'] as String,
      activo: json['activo'] as int,
      tipo: json['tipo'] as String,
      relacion_dispositivo: json['relacion_dispositivo'] as String,
      dias: json['dias'] as String,
      tiempo: json['tiempo'] as String,
      nuevo_valor: json['nuevo_valor'] as String,
    );
  }
}
