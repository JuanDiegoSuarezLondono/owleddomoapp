import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

///Esta clase se encarga de manejar la pantalla del despliegue de la lista de los
///dispositivos y su lógica.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param usuario identificador del usuario.
///@param width obtiene el ancho de la pantalla del dispositivo.
///@param height obtiene el alto de la pantalla del dispositivo.
///@see owleddomo_app/cuartos/CuartosMain.dart#class().
///@return un Widget Container con una lista de los dispositivos y su lógica en
///caso de un error.

class PantallaCargaSinRed extends StatefulWidget {
  @override
  _PantallaCargaSinRed createState() => _PantallaCargaSinRed();
}

class _PantallaCargaSinRed extends State<PantallaCargaSinRed> {

  void _reproducirSonido(int _numeroSonido) {
    final _reproductor = AudioCache();
    _reproductor.play('notas/note$_numeroSonido.wav');
  }

  Expanded _constructorClave({Color color, int numeroSonido, String texto}) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          _reproducirSonido(numeroSonido);
          },
        child: Text(
          texto,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Lato",
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    return Stack(
      children: <Widget> [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _constructorClave(color: Color(0xFF000106), numeroSonido: 1, texto: ""),
            _constructorClave(color: Color(0xFF050040), numeroSonido: 2, texto: ""),
            _constructorClave(color: Color(0xFF140153), numeroSonido: 3, texto: ""),
            _constructorClave(color: Color(0xFF4c1ca7), numeroSonido: 4, texto: ""),
            _constructorClave(color: Color(0xFF9438cb), numeroSonido: 5, texto: ""),
            _constructorClave(color: Color(0xFFc53cb5), numeroSonido: 6, texto: ""),
            _constructorClave(color: Color(0xFFf36bb3), numeroSonido: 7, texto: ""),
          ],
        ),
        Center(
          child: Card(
            color: Colors.white70,
            child: Container(
              alignment: Alignment.center,
              height: _height/5.28,
              width: _width/1.44,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  Icon(
                    Icons.nights_stay_rounded,
                    size: _height/19.8,
                    color: Colors.blueGrey,
                  ),
                  Text(
                    "Las hadas de tu modem se perdieron...\n¡Toca una hermosa melodia para que regresen!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontFamily: "Lato",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
