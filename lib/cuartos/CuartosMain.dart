import 'package:flutter/material.dart';
import 'package:owleddomoapp/Cuartos/CuartoTabla/CuartosLista.dart';
import 'package:owleddomoapp/Cuartos/DispositivoTabla/DispositivosLista.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'package:owleddomoapp/shared/MenuHamburguesa.dart';

final PaletaColores colores = new PaletaColores();

///Esta clase se encarga de la pantalla donde se direcciona la barra cupertino al
///ir hacia los cuartos, contiene todo lo concerniente a los cuartos y los dispositivos.
///@version 1.0, 06/04/21
///@author Juan Diego Suárez Londoño
///@param usuario identificador del usuario.
///@see owleddomo_app/AppTrips.dart#class().
///return un Widget SafeArea con un Scaffold que contendrá toda la información
///de los cuartos y los dispositivos, además posee un menú en la barra del título.

class CuartosMain extends StatelessWidget {

  final Persona usuario;
  CuartosMain(this.usuario,{Key key,String pathImagen,String titulo});

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
        color: PaletaColores().obtenerPrimario(),
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(usuario.url_foto),
        ),
      ),
    );

    final tituloInfo = Container(
      margin: EdgeInsets.only(
        left: width/14.4,
      ),
      child : Text (
        "Cuartos",
        style: TextStyle(
          fontFamily: 'Lato',
          color: PaletaColores().obtenerLetraContrastePrimario(),
          fontSize: height/31.68,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    final tabs = [
      Text('CUARTOS',
        style: TextStyle(
          fontSize: height/44,
          fontFamily: 'Lato',
        ),
      ),
      Text('DISPOSITIVOS',
        style: TextStyle(
          fontSize: height/44,
          fontFamily: 'Lato',
        ),
      ),
    ];

    return  DefaultTabController(
      length: tabs.length,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: PaletaColores().obtenerColorFondo(),
          appBar: AppBar(
            actions: [Text("")],
            automaticallyImplyLeading: false,
            backgroundColor: PaletaColores().obtenerPrimario(),
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
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(height/16.16326530612245),
              child: TabBar(
                labelColor: PaletaColores().obtenerTerciario(),
                unselectedLabelColor: PaletaColores().obtenerColorInactivo(),
                indicatorColor: PaletaColores().obtenerTerciario(),
                indicatorWeight: height/264,
                tabs: [
                  for (final tab in tabs) Tab(child: tab),
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              CuartosLista(usuario),
              DispositivosLista(usuario),
            ],
          ),
          endDrawer: MenuHamburguesa(usuario),
        ),
      ),
    );
  }
}
