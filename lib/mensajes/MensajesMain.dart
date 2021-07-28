import 'package:flutter/material.dart';
import 'package:owleddomoapp/mensajes/MensajesLista.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'package:owleddomoapp/shared/MenuHamburguesa.dart';

class MensajesMain extends StatelessWidget {

  final Persona usuario;
  MensajesMain(this.usuario,{Key key,String pathImagen,String titulo});

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    final foto = Container(
      margin: EdgeInsets.only(
        right: width/18,
      ),
      width: height/19.8,
      height: height/19.8,
      decoration: BoxDecoration(
        color: PaletaColores(usuario).obtenerSecundario(),
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(usuario.url_icono),
        ),
      ),
    );

    final tituloInfo = Container(
      margin: EdgeInsets.only(
        left: width/14.4,
      ),
      child : Text (
        "Mensajes",
        style: TextStyle(
          fontFamily: 'Lato',
          color: PaletaColores(usuario).obtenerSecundario(),
          fontSize: height/31.68,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return  SafeArea(
      child: Scaffold(
        backgroundColor: PaletaColores(usuario).obtenerColorFondo(),
        appBar: AppBar(
          actions: [Text("")],
          automaticallyImplyLeading: false,
          backgroundColor: PaletaColores(usuario).obtenerSecundario(),
          flexibleSpace: Container(
            height: height/14.14285714285714,
            child: Row (
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                tituloInfo,
                Builder(
                    builder: (context) {
                      return InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: foto,
                        onTap: () => Scaffold.of(context).openEndDrawer(),
                      );
                    }
                ),
              ],
            ),
          ),
        ),
        body: MensajesLista(usuario),
        endDrawer: MenuHamburguesa(usuario),
      ),
    );

  }
}