import 'package:flutter/material.dart';
import 'PaletaColores.dart';
import 'package:owleddomoapp/shared/SubPantallaUno.dart';
import 'package:owleddomoapp/login/ServiciosPersona.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'package:owleddomoapp/hamburguesa/solicitud/ServiciosSolicitud.dart';
import 'package:owleddomoapp/hamburguesa/configuracion/Configuracion.dart';
import 'package:owleddomoapp/hamburguesa/solicitud/SolicitudMain.dart';
import 'package:owleddomoapp/hamburguesa/solicitud/Solicitud.dart';
import 'package:owleddomoapp/hamburguesa/cuenta/CuentaMain.dart';
import 'package:owleddomoapp/hamburguesa/acercaDe/AcercaDe.dart';
import 'package:owleddomoapp/hamburguesa/ayuda/Ayuda.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      if(value.first != value.last && mounted) {
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

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    void logOut() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('persona_id', null);
      prefs.setString('territorio_id', null);
      prefs.setString('nombres', null);
      prefs.setString('apellidos', null);
      prefs.setString('telefono', null);
      prefs.setString('fecha_nacimiento', null);
      prefs.setString('correo_electronico', null);
      prefs.setString('url_foto', null);
      prefs.setString('url_icono', null);
      prefs.setString('rol', null);
      prefs.setString('apodo', null);
      prefs.setString('codigo_usuario', null);
      prefs.setString('configuracion_id', null);
      prefs.setString('tema', null);
    }

    return Theme(
      data: ThemeData(
        canvasColor: PaletaColores(_usuario).obtenerSecundario(),
      ),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: _height/5.28,
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
              title: Text(
                'Cuenta',
                style: TextStyle(
                  color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
                ),
              ),
              onTap: () {
                Route route = MaterialPageRoute (
                  builder: (context) => SubPantallaUno(CuentaMain(_usuario), 'Tu Cuenta', _usuario),
                );
                Navigator.push(context, route).then((value) =>{

                });
                },
            ),
            ListTile(
              title: Text(
                'Configuracion',
                style: TextStyle(
                  color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
                ),
              ),
              onTap: () {
                Route route = MaterialPageRoute (
                  builder: (context) => SubPantallaUno(Configuracion(_usuario), "Configuracion", _usuario),
                );
                Navigator.push(context, route).then((value) =>{

                });
                },
            ),
            ListTile(
              title: Text(
                'Ayuda',
                style: TextStyle(
                  color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
                ),
              ),
              onTap: () {
                Route route = MaterialPageRoute (
                  builder: (context) => SubPantallaUno(Ayuda(), "Ayuda", _usuario),
                );
                Navigator.push(context, route).then((value) =>{

                });
                },
            ),
            ListTile(
              title: Text(
                'Acerca de',
                style: TextStyle(
                  color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
                ),
              ),
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
                  Text(
                    'Solicitudes para compartir',
                    style: TextStyle(
                      color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
                    ),
                  ),
                  Text(
                    '+${_numeroPeticiones}',
                    style: TextStyle(
                      color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
                    ),
                  ),
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
              title: Text(
                'Cerrar Sesion',
                style: TextStyle(
                  color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
                ),
              ),
              onTap: () {
                logOut();
                ServiciosPersona.logout(_usuario.persona_id, _usuario.token);
                Navigator.pop(context);
                Navigator.pop(context);
                },
            ),
          ],
        ),
      ),
    );
  }
}