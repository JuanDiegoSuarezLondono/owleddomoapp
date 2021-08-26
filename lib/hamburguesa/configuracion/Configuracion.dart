import 'package:flutter/material.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/shared/TratarError.dart';
import 'package:owleddomoapp/login/ServiciosPersona.dart';

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

  int _temaActual;

  void initState() {
    super.initState();
    _temaActual = _usuario.tema;
  }

  _actualizarTema(int tema) async {
    int antiguoTema = _temaActual;
    setState(() {
      _temaActual = tema;
    });
    ServiciosPersona.actualizarTema(_usuario.configuracion_id, _usuario.persona_id, tema).then((result) {
      if (mounted) {
        setState(() {
          if ( result.first.toString()[0] != '2' ) {
            _temaActual = antiguoTema;
          }
          TratarError(_usuario).estadoSnackbar(result,context);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    Widget tituloCarta(String titulo){
      return Container(
        alignment: Alignment.bottomLeft,
        margin: EdgeInsets.only(
          top: _height/39.6,
          left: _width/18,
        ),
        child: Text(
          titulo,
          style: TextStyle(
            color: PaletaColores(_usuario).obtenerLetraContrasteSecundario(),
            fontSize: _height/22.62857142857143,
            fontFamily: 'Lato',
          ),
        ),
      );
    }

    Widget temaCarta(Color primario,Color fondo,Color secundario, Color terciario,
                     Color cuaternario,Color contrPrim,Color contrSeg, Color inactivo,
                     int index){
      return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          _actualizarTema(index);
        },
        child: Container(
          margin: EdgeInsets.only(
            left: _width/24,
            top: _height/52.8,
            bottom: _height/52.8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(_height/52.8),
            ),
            boxShadow: [
              BoxShadow(
                color: _temaActual == index ? Colors.green.withOpacity(0.6)
                                              : PaletaColores(_usuario).obtenerLetraContrasteSecundario().withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Card(
            color: fondo,
            child: Container(
              height: _height/5,
              width: _width/5,
              child: Column(
                children: <Widget> [
                  Container(
                    height: _height/36.25000000000001,
                    width: _width/5,
                    child: Column(
                      children: <Widget> [
                        Container(
                          height: _height/72.50000000000002,
                          width: _width/5,
                          child: Row(
                            children: <Widget> [
                              Container(
                                height: _height/72.50000000000002,
                                width: _width/10,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: _width/72),
                                child: Text(
                                  "█████",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: contrPrim,
                                    fontSize: _height/198,
                                  ),
                                ),
                              ),
                              Container(
                                height: _height/72.50000000000002,
                                width: _width/10,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: _width/72),
                                child: Container(
                                  height: _height/132,
                                  width: _height/132,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(_height/26.4),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget> [
                            Container(
                              height: _height/72.50000000000002,
                              width: _width/10,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: terciario,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                "█████",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: terciario,
                                  fontSize: 4,
                                ),
                              ),
                            ),
                            Container(
                              height: _height/72.50000000000002,
                              width: _width/10,
                              child: Text(
                                "███████",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: inactivo,
                                  fontSize: _height/198,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: primario,
                      borderRadius: BorderRadius.only(
                        topRight:  Radius.circular(_height/264),
                        topLeft:  Radius.circular(_height/264),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: fondo,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget> [
                          Row(
                            children: <Widget> [
                              Container(
                                height: _height/25.89285714285714,
                                width: _width/11.76948980727232,
                                margin: EdgeInsets.only(
                                  left: _width/90,
                                  bottom: _height/9.317647058823529,
                                ),
                                decoration: BoxDecoration(
                                  color: secundario,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(_height/264),
                                  ),
                                ),
                              ),
                              Container(
                                height: _height/25.89285714285714,
                                width: _width/11.76948980727232,
                                margin: EdgeInsets.only(
                                  left: _width/90,
                                  bottom: _height/9.317647058823529,
                                ),
                                decoration: BoxDecoration(
                                  color: secundario,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(_height/264),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: _height/15.42553191489361,
                            width: _width/7.011605415860734,
                            decoration: BoxDecoration(
                              color: primario,
                              borderRadius: BorderRadius.all(
                                Radius.circular(_height/264),
                              ),
                            ),
                            child: Icon(
                              Icons.account_circle,
                              color: cuaternario,
                              size: _height/29.33333333333333,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: _height/72.50000000000002,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget> [
                        Icon(
                          Icons.home,
                          color: cuaternario,
                          size: _height/99,
                        ),
                        Icon(
                          Icons.wb_sunny,
                          color: cuaternario,
                          size: _height/99,
                        ),
                        Icon(
                          Icons.message,
                          color: cuaternario,
                          size: _height/99,
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: secundario,
                      borderRadius: BorderRadius.only(
                        bottomRight:  Radius.circular(_height/264),
                        bottomLeft:  Radius.circular(_height/264),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget temasCarta(){
      return Card(
        color: PaletaColores(_usuario).obtenerSecundario(),
        margin: EdgeInsets.all(_height/31.68),
        child: Column(
          children: <Widget> [
            tituloCarta("Temas"),
            Divider(
              height: 10,
              endIndent: 10,
              indent: 10,
              thickness: 2,
              color: Color(0xFF929292),
            ),
            Row(
              children: <Widget> [
                temaCarta(Color(0xFF08192d),Color(0xFFECEFF1),Colors.white,Color(0xFF9BBF63),
                          Color(0xFFbf930d),Colors.white,Colors.black,Color(0xFF929292),0),
                temaCarta(Colors.black,Color(0xFF1E3C40),Color(0xFF08192d),Color(0xFF736F3D),
                          Color(0xFF8C5C03), Colors.white.withOpacity(0.82),Colors.white,Color(0xFF929292), 1),
                temaCarta(Color(0xFF8C4F5F),Color(0xFFA66F8D),Color(0xFFBF3B6C),Color(0xFFB5BF65),
                    Color(0xFFD0E5F2), Colors.white.withOpacity(0.82),Colors.white,Color(0xFF929292), 2),
              ],
            ),
            Row(
              children: <Widget> [
                temaCarta(Color(0xFFA6998F),Color(0xFFD9CCC5),Color(0xFFF2DCC9),Color(0xFF404040),
                    Color(0xFF262626),Colors.white,Colors.black,Colors.black26,3),
                temaCarta(Color(0xFF3C6AA6),Color(0xFF9CB6D9),Color(0xFF638BBF),Color(0xFF172540),
                    Color(0xFFe9c16a),Colors.white,Colors.white,Colors.black38,4),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      color: PaletaColores(_usuario).obtenerColorFondo(),
      child: ListView(
        physics: BouncingScrollPhysics(),
        primary: false,
        addAutomaticKeepAlives: false,
        shrinkWrap: true,
        children: <Widget> [
          temasCarta(),
        ],
      ),
    );
  }
}