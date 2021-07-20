
///Esta clase se encarga de construir la plantilla para la entidad de variable.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param relacion_id id única de la variable.
///@param persona_producto_id dispositivo de la variable.
///@param variable_id tipo de variable asociada.
///@param valor valor o dato de la variable.
///@param relacion_dispositivo diferenciador de la variable en el hardware.
///@see owleddomo_app/cuartos/DisporitivoTabla/DispositivosLista.dart#class().
///@see owleddomo_app/cuartos/DisporitivoTabla/Variable/ServiciosVariable.dart#class().

class Variable {
  String relacion_id  = "0"; //Id única de la variable.
  String persona_producto_id = "0"; //Dispositivo de la variable.
  String variable_id = "0"; //Tipo de variable asociada.
  String valor = "No hay icono"; //Valor o dato de la variable.
  String relacion_dispositivo = "No hay dato"; //Diferenciador de la variable en el hardware.

  Variable({this.relacion_id, this.persona_producto_id, this.variable_id, this.valor,
            this.relacion_dispositivo}); //Constructor de la clase.

  ///Recibe una variable en formato json y se encarga de transformarla a una
  ///instancia de esta clase.
  ///@param json variable en formato json.

  factory Variable.fromJson(Map<String, dynamic> json) {
    return Variable(
      relacion_id: json['relacion_id'] as String,
      persona_producto_id: json['persona_producto_id'] as String,
      variable_id: json['variable_id'] as String,
      valor: json['valor'] as String,
      relacion_dispositivo: json['relacion_dispositivo'] as String,
    );
  }
}