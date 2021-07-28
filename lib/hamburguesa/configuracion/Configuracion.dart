import 'package:flutter/material.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/shared/MenuHamburguesa.dart';

class Configuracion extends StatefulWidget {

  final Persona usuario;

  Configuracion(this.usuario);

  @override
  State<StatefulWidget> createState () {
    return _Configuracion(usuario);
  }

}

class _Configuracion extends State<Configuracion> {

  Persona _usuario;

  _Configuracion(this._usuario);

  @override
  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    Widget tituloCarta(String titulo){
      return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(
          top: 20,
          left: 20,
        ),
        child: Text(
          titulo,
          style: TextStyle(
            color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
            fontSize: 35,
            fontFamily: 'Lato',
          ),
        ),
      );
    }

    Widget temaCarta(Color primario,Color fondo,Color secundario, Color terciario, Color cuaternario, int index){
      return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          setState(() {
            _usuario.tema = index;
          });
        },
        child: Card(
          margin: EdgeInsets.all(15),
          color: _usuario.tema == index ? Colors.green.withOpacity(0.8) : Color(0xFF929292).withOpacity(0.5),
          child: Container(
            height: 100,
            child: Row(
              children: <Widget> [
                Card(
                  color: primario,
                  child: Container(
                    width:  47,
                  ),
                ),
                Card(
                  color: fondo,
                  child: Container(
                    width:  47,
                  ),
                ),
                Card(
                  color: secundario,
                  child: Container(
                    width:  47,
                  ),
                ),
                Card(
                  color: terciario,
                  child: Container(
                    width:  47,
                  ),
                ),
                Card(
                  color: cuaternario,
                  child: Container(
                    width:  47,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget temasCarta(){
      return Card(
        color: PaletaColores(_usuario).obtenerSecundario(),
        margin: EdgeInsets.all(25),
        child: Column(
          children: <Widget> [
            tituloCarta("Temas"),
            temaCarta(Color(0xFF08192d),Color(0xFFECEFF1),Colors.white,Color(0xFF9BBF63),Color(0xFFbf930d), 0),
            temaCarta(Colors.black,Color(0xFF1E3C40),Color(0xFF08192d),Color(0xFF736F3D),Color(0xFF8C5C03), 1),
          ],
        ),
      );
    }

    return Container(
      child: ListView(
        physics: BouncingScrollPhysics(),
        primary: false,
        addAutomaticKeepAlives: false,
        shrinkWrap: true,
        children: <Widget>[
          temasCarta(),
        ],
      ),
    );
  }
}