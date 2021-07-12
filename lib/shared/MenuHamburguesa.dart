import 'package:flutter/material.dart';
import 'PaletaColores.dart';
import 'package:owleddomoapp/shared/SubPantallaUno.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'package:owleddomoapp/hamburguesa/cuenta/CuentaMain.dart';
import 'package:owleddomoapp/hamburguesa/configuracion/Configuracion.dart';
import 'package:owleddomoapp/hamburguesa/ayuda/Ayuda.dart';
import 'package:owleddomoapp/hamburguesa/acercaDe/AcercaDe.dart';
import 'package:owleddomoapp/hamburguesa/solicitud/SolicitudMain.dart';
import 'package:owleddomoapp/hamburguesa/solicitud/ServiciosSolicitud.dart';
import 'package:owleddomoapp/hamburguesa/solicitud/Solicitud.dart';

final PaletaColores colores = new PaletaColores();

class MenuHamburguesa extends StatefulWidget {

  final Persona usuario;
  MenuHamburguesa(this.usuario);

  @override
  State<StatefulWidget> createState () {
    return _MenuHamburguesa(usuario);
  }

}

class _MenuHamburguesa extends State<MenuHamburguesa> {

  final Persona _usuario;
  _MenuHamburguesa(this._usuario);

  List<Solicitud> _permisosLista; //Lista de las cartas de los dispositivos.
  Future<List> _pemisossObtenidos; //Lista con el mapeo de los dispositivos.
  int _numeroPeticiones;

  void initState() {
    super.initState();
    _numeroPeticiones = 0;
    _obtenerPermisos();
  }

  Future<List> _obtenerPermisos() async {
    setState(() {
      _pemisossObtenidos =  ServiciosSolicitud.todasSolicitud(_usuario.persona_id);
    });
    _pemisossObtenidos .then((value) => {
      if(value.first != value.last) {
        setState(() {
          for(Solicitud peticion in value.last){
            if (peticion.estado == "pendiente"){
              _numeroPeticiones++;
            }
          }
        }),
        _permisosLista = value.last,
      }
    });
    return _pemisossObtenidos;
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 150,
            color: colores.obtenerColorUno(),
          ),
          ListTile(
            title: Text('Cuenta'),
            onTap: () {
              Route route = MaterialPageRoute (
                builder: (context) => SubPantallaUno(CuentaMain(_usuario), 'Tu Cuenta'),
              );
              Navigator.push(context, route).then((value) =>{
              });
            },
          ),
          ListTile(
            title: Text('Configuracion'),
            onTap: () {
              Route route = MaterialPageRoute (
                builder: (context) => SubPantallaUno(Configuracion(), "Configuracion"),
              );
              Navigator.push(context, route).then((value) =>{
              });
            },
          ),
          ListTile(
            title: Text('Ayuda'),
            onTap: () {
              Route route = MaterialPageRoute (
                builder: (context) => SubPantallaUno(Ayuda(), "Ayuda"),
              );
              Navigator.push(context, route).then((value) =>{
              });
            },
          ),
          ListTile(
            title: Text('Acerca de'),
            onTap: () {
              Route route = MaterialPageRoute (
                builder: (context) => SubPantallaUno(AcercaDe(),"Acerca de"),
              );
              Navigator.push(context, route).then((value) =>{
              });
            },
          ),
          ListTile(
            title: Text('Solicitudes para compartir                 +${_numeroPeticiones}'),
            onTap: () {
              Route route = MaterialPageRoute (
                builder: (context) => SubPantallaUno(SolicitudMain(_usuario), "Lista Solicitudes"),
              );
              Navigator.push(context, route).then((value) =>{
              });
            },
          ),
          ListTile(
            title: Text('Cerrar Sesion'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}