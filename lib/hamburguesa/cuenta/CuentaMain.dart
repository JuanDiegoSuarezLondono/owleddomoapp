import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CuentaMain extends StatefulWidget {

  final Persona usuario;
  CuentaMain(this.usuario);

  @override
  State<StatefulWidget> createState () {
    return _CuentaMain(usuario);
  }

}

class _CuentaMain extends State<CuentaMain> {

  final Persona _usuario;
  _CuentaMain(this._usuario);

  @override
  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    Widget foto() {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: PaletaColores(_usuario).obtenerPrimario(),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(_usuario.url_foto),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
      );
    }

    Widget icono() {
      return Container(
        margin: EdgeInsets.only(
          left: 220,
          top: 150,
        ),
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: PaletaColores(_usuario).obtenerPrimario(),
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(_usuario.url_icono),
          ),
        ),
      );
    }

    Widget texto() {
      return Container(
        alignment: Alignment.topLeft,
        height: 100,
        width: 205,
        margin: EdgeInsets.only(
          top: 85,
          left: 10,
        ),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: PaletaColores(_usuario).obtenerSecundario().withAlpha(200),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            Text(
              "Bienvenido",
              style: TextStyle(
                color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
                fontSize: 30,
                fontFamily: 'Lato',
              ),
            ),
            Text(
              "${_usuario.nombres} ${_usuario.apellidos}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
                //fontSize: 30,
                fontFamily: 'Lato',
              ),
            ),
            Text(
              _usuario.apodo == null ? "No hay apodo" : "${_usuario.apodo}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: PaletaColores(_usuario).obtenerLetraContrasteSecundario().withOpacity(0.5),
                fontSize: 12,
                fontFamily: 'Lato',
              ),
            ),
          ],
        ),
      );
    }

    Widget portada() {
      return Container(
        height: 250,
        margin: EdgeInsets.only(
          top: 15,
          left: 10,
          right: 10,
        ),
        child: Stack(
          children: <Widget> [
            foto(),
            texto(),
            icono(),
          ],
        ),
      );
    }

    spinkit() {
      return SpinKitPumpingHeart(
        color: PaletaColores(_usuario).obtenerCuaternario(),
        size: 32,
      );
    };

    Widget codigo() {
      return Container(
        height: 80,
        width: 180,
        //color: Colors.red,
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Text(
              "Tú Codigo",
              style: TextStyle(
                color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
                fontSize: 12,
                fontFamily: 'Lato',
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: PaletaColores(_usuario).obtenerSecundario(),//PaletaColores().obtenerLetraContrasteSecundario(),
                border: Border.all(
                  color: PaletaColores(_usuario).obtenerColorInactivo(),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                height: 40,
                width: 180,
                child: Text(
                  _usuario.codigo_usuario,
                  style: TextStyle(
                    color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),//PaletaColores().obtenerSecundario(),
                    fontSize: 20,
                    fontFamily: 'Lato',
                    letterSpacing: 3.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget codigoUsuario() {
      return Container(
        height: 70,
        margin: EdgeInsets.only(
          left: 25,
          right: 25,
        ),
        decoration: BoxDecoration(
          color: PaletaColores(_usuario).obtenerSecundario(),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: PaletaColores(_usuario).obtenerLetraContrasteSecundario().withOpacity(0.3),
              spreadRadius: 4,
              blurRadius: 7,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget> [
            spinkit(),
            codigo(),
            spinkit(),
          ],
        ),
      );
    }

    Widget departamento() {
      return Container(
        height: 70,
        width: 150,
        decoration: BoxDecoration(
          color: PaletaColores(_usuario).obtenerSecundario(),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: PaletaColores(_usuario).obtenerLetraContrasteSecundario().withOpacity(0.3),
              spreadRadius: 4,
              blurRadius: 7,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ],
        ),
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Text(
              "Tú Departamento",
              style: TextStyle(
                color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
                fontSize: 12,
                fontFamily: 'Lato',
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: PaletaColores(_usuario).obtenerSecundario(),//PaletaColores().obtenerLetraContrasteSecundario(),
                border: Border.all(
                  color: PaletaColores(_usuario).obtenerColorInactivo(),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                height: 40,
                width: 120,
                child: Text(
                  "Boyacá",
                  style: TextStyle(
                    color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),//PaletaColores().obtenerSecundario(),
                    fontSize: 18,
                    fontFamily: 'Lato',
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget ciudad() {
      return Container(
        height: 70,
        width: 150,
        decoration: BoxDecoration(
          color: PaletaColores(_usuario).obtenerSecundario(),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: PaletaColores(_usuario).obtenerLetraContrasteSecundario().withOpacity(0.3),
              spreadRadius: 4,
              blurRadius: 7,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ],
        ),
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Text(
              "Tú Ciudad",
              style: TextStyle(
                color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
                fontSize: 12,
                fontFamily: 'Lato',
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: PaletaColores(_usuario).obtenerSecundario(),//PaletaColores().obtenerLetraContrasteSecundario(),
                border: Border.all(
                  color: PaletaColores(_usuario).obtenerColorInactivo(),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                height: 40,
                width: 120,
                child: Text(
                  "Tunja",
                  style: TextStyle(
                    color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),//PaletaColores().obtenerSecundario(),
                    fontSize: 18,
                    fontFamily: 'Lato',
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget filaTerritorio() {
      return Container(
        height: 80,
        margin: EdgeInsets.only(
          top: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget> [
            departamento(),
            ciudad(),
          ],
        ),
      );
    }

    Widget telefono() {
      return Container(
        height: 70,
        width: 150,
        decoration: BoxDecoration(
          color: PaletaColores(_usuario).obtenerSecundario(),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: PaletaColores(_usuario).obtenerLetraContrasteSecundario().withOpacity(0.3),
              spreadRadius: 4,
              blurRadius: 7,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget> [
            Icon(
              Icons.phone,
              color: PaletaColores(_usuario).obtenerCuaternario(),
              size: 30,
            ),
            Column (
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                Text(
                  "Tú Telefono",
                  style: TextStyle(
                    color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
                    fontSize: 12,
                    fontFamily: 'Lato',
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: PaletaColores(_usuario).obtenerSecundario(),//PaletaColores().obtenerLetraContrasteSecundario(),
                    border: Border.all(
                      color: PaletaColores(_usuario).obtenerColorInactivo(),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 100,
                    child: Text(
                      _usuario.telefono,
                      style: TextStyle(
                        color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
                        fontSize: 15,
                        fontFamily: 'Lato',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget correo() {
      return Container(
        height: 70,
        width: 150,
        decoration: BoxDecoration(
          color: PaletaColores(_usuario).obtenerSecundario(),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: PaletaColores(_usuario).obtenerLetraContrasteSecundario().withOpacity(0.3),
              spreadRadius: 4,
              blurRadius: 7,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget> [
            Column (
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                Text(
                  "Tú Correo",
                  style: TextStyle(
                    color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
                    fontSize: 12,
                    fontFamily: 'Lato',
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: PaletaColores(_usuario).obtenerSecundario(),//PaletaColores().obtenerLetraContrasteSecundario(),
                    border: Border.all(
                      color: PaletaColores(_usuario).obtenerColorInactivo(),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 100,
                    child: Text(
                      _usuario.correo_electronico,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
                        fontSize: 13,
                        fontFamily: 'Lato',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Icon(
              Icons.email_outlined,
              color: PaletaColores(_usuario).obtenerCuaternario(),
              size: 30,
            ),
          ],
        ),
      );
    }

    Widget filaContactos() {
      return Container(
        height: 80,
        margin: EdgeInsets.only(
          top: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget> [
            telefono(),
            correo(),
          ],
        ),
      );
    }

    Widget fecha() {
      return Container(
        height: 120,
        margin: EdgeInsets.only(
          top: 20,
          left: 60,
          right: 60,
        ),
        decoration: BoxDecoration(
          color: PaletaColores(_usuario).obtenerSecundario(),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: PaletaColores(_usuario).obtenerLetraContrasteSecundario().withOpacity(0.3),
              spreadRadius: 4,
              blurRadius: 7,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget> [
            Icon(
              Icons.calendar_today_rounded,
              color: PaletaColores(_usuario).obtenerCuaternario(),
              size: 35,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                Column (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    Text(
                      "Año",
                      style: TextStyle(
                        color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
                        fontSize: 12,
                        fontFamily: 'Lato',
                      ),
                    ),
                    Card(
                      color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 60,
                        child: Text(
                          "1994",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: PaletaColores(_usuario).obtenerSecundario(),
                            fontSize: 13,
                            fontFamily: 'Lato',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    Text(
                      "Mes",
                      style: TextStyle(
                        color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
                        fontSize: 12,
                        fontFamily: 'Lato',
                      ),
                    ),
                    Card(
                      color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 60,
                        child: Text(
                          "01",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: PaletaColores(_usuario).obtenerSecundario(),
                            fontSize: 13,
                            fontFamily: 'Lato',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    Text(
                      "Dia",
                      style: TextStyle(
                        color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
                        fontSize: 12,
                        fontFamily: 'Lato',
                      ),
                    ),
                    Card(
                      color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 60,
                        child: Text(
                          "27",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: PaletaColores(_usuario).obtenerSecundario(),
                            fontSize: 13,
                            fontFamily: 'Lato',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
          portada(),
          codigoUsuario(),
          filaTerritorio(),
          filaContactos(),
          fecha(),
        ],
      ),
    );
  }
}