import 'package:flutter/material.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final PaletaColores colores = new PaletaColores();

class PantallaEspera extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    spinkit() {
      return SpinKitPumpingHeart(
        color: colores.obtenerColorCuatro(),
        size: height/7.92,
      );
    };

    return AlertDialog(backgroundColor: colores.obtenerColorUno(),
      content: SizedBox(
        width: width/3.6,
        height: height/3.96,
        child: spinkit(),
      ),
    );
  }
}