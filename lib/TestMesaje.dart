import 'package:flutter/material.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/shared/TratarError.dart';


final PaletaColores colores = new PaletaColores(); //Colores predeterminados.
final TratarError tratarError = new TratarError(); //Respuestas predeterminadas a las API.

///Esta clase se encarga de manejar la pantalla del despliegue de la lista de las
///rutinas y su lógica.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param usuario identificador del usuario.
///@see owleddomo_app/rutinas/RutinasMain.dart#class().
///@return Un Widget Container con una lista de las rutinas y su lógica en
///caso de un error.

class Test extends StatefulWidget {

  final String usuario; //Identificador del usuario.
  Test(this.usuario) :super(); //Constructor de la clase.

  @override
  _RutinasLista createState() => _RutinasLista(usuario); //Crea un estado mutable del Widget.

}

class _RutinasLista extends State<Test> {

  final String _usuario; //Identificador del usuario.
  _RutinasLista(this._usuario); //Constructor de la clase.

  @override

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState();

  }

  Widget build(BuildContext context) {

    return Text("a");
  }
}
