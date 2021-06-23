import 'package:flutter/material.dart';
//import 'package:audioplayers/audio_cache.dart';

class PantallaCargaSinRed extends StatefulWidget {
  @override
  _PantallaCargaSinRed createState() => _PantallaCargaSinRed();
}

class _PantallaCargaSinRed extends State<PantallaCargaSinRed> {

  void _reproducirSonido(int _numeroSonido) {
    //final _reproductor = AudioCache();
    //_reproductor.play('notas/note$_numeroSonido.wav');
  }

  Expanded _constructorClave({Color color, int numeroSonido, String texto}) {
    return Expanded(
      child: FlatButton(
        color: color,
        onPressed: () {
          _reproducirSonido(numeroSonido);
          },
        child: Text(
          texto,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _constructorClave(color: Color(0xFF000106), numeroSonido: 1, texto: ""),
        _constructorClave(color: Color(0xFF050040), numeroSonido: 2, texto: ""),
        _constructorClave(color: Color(0xFF140153), numeroSonido: 3, texto: "Las hadas de tu modem se perdieron :("),
        _constructorClave(color: Color(0xFF4c1ca7), numeroSonido: 4, texto: "Toca una hermosa melodia para que regresen"),
        _constructorClave(color: Color(0xFF9438cb), numeroSonido: 5, texto: ".    .    ."),
        _constructorClave(color: Color(0xFFc53cb5), numeroSonido: 6, texto: ""),
        _constructorClave(color: Color(0xFFf36bb3), numeroSonido: 7, texto: ""),
      ],
    );
  }
}
