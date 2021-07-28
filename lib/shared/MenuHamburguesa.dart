import 'package:flutter/material.dart';
import 'PaletaColores.dart';
import 'package:owleddomoapp/shared/SubPantallaUno.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'package:owleddomoapp/hamburguesa/solicitud/ServiciosSolicitud.dart';
import 'package:owleddomoapp/hamburguesa/configuracion/Configuracion.dart';
import 'package:owleddomoapp/hamburguesa/solicitud/SolicitudMain.dart';
import 'package:owleddomoapp/hamburguesa/solicitud/Solicitud.dart';
import 'package:owleddomoapp/hamburguesa/cuenta/CuentaMain.dart';
import 'package:owleddomoapp/hamburguesa/acercaDe/AcercaDe.dart';
import 'package:owleddomoapp/hamburguesa/ayuda/Ayuda.dart';

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

  Future<List> _pemisossObtenidos; //Lista con el mapeo de los dispositivos.
  int _numeroPeticiones;

  void initState() {
    super.initState();
    _numeroPeticiones = 0;
    _pemisossObtenidos = _obtenerPermisos();
  }

  Future<List> _obtenerPermisos() async {
    _pemisossObtenidos =  ServiciosSolicitud.todasSolicitud(_usuario.persona_id);
    _pemisossObtenidos .then((value) => {
      if(value.first != value.last) {
        setState(() {
          for(Solicitud peticion in value.last){
            if (peticion.estado == "pendiente"){
              _numeroPeticiones++;
            }
          }
        }),
      }
    });
    return _pemisossObtenidos;
  }



  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 150,
            child: Container(
              decoration: BoxDecoration(
                color: PaletaColores(_usuario).obtenerPrimario(),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(_usuario.url_foto),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text('Cuenta'),
            onTap: () {
              Route route = MaterialPageRoute (
                builder: (context) => SubPantallaUno(CuentaMain(_usuario), 'Tu Cuenta', _usuario),
              );
              Navigator.push(context, route).then((value) =>{
              });
            },
          ),
          ListTile(
            title: Text('Configuracion'),
            onTap: () {
              Route route = MaterialPageRoute (
                builder: (context) => SubPantallaUno(Configuracion(_usuario), "Configuracion", _usuario),
              );
              Navigator.push(context, route).then((value) =>{
              });
            },
          ),
          ListTile(
            title: Text('Ayuda'),
            onTap: () {
              Route route = MaterialPageRoute (
                builder: (context) => SubPantallaUno(Ayuda(), "Ayuda", _usuario),
              );
              Navigator.push(context, route).then((value) =>{
              });
            },
          ),
          ListTile(
            title: Text('Acerca de'),
            onTap: () {
              Route route = MaterialPageRoute (
                builder: (context) => SubPantallaUno(AcercaDe(),"Acerca de", _usuario),
              );
              Navigator.push(context, route).then((value) =>{
              });
            },
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget> [
                Text('Solicitudes para compartir'),
                Text('+${_numeroPeticiones}'),
              ],
            ),
            onTap: () {
              Route route = MaterialPageRoute (
                builder: (context) => SubPantallaUno(SolicitudMain(_usuario), "Lista Solicitudes", _usuario),
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