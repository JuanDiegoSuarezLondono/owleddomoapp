import 'dart:math';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';

final PaletaColores colores = new PaletaColores(); //Colores predeterminados.

///Esta clase se encarga de suministrar una animación de un cubo.
///@version 1.0, 06/04/21
///@author https://portfolio.creativemaybeno.dev/
///@param width obtiene el ancho de la pantalla del dispositivo.
///@see owleddomo_app/cuartos/CuartoTabla/InterfazInformacionCuarto.dart#class().
///@see owleddomo_app/cuartos/CuartoTabla/InterfazEditarCuarto.dart#class().
///@see owleddomo_app/cuartos/CuartoTabla/InterfazAgregarCuarto.dart#class().
///@return un Widget SizedBox con una animación de un cubo.

class FondoCubo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.

    return SizedBox(
      width: width,
      height: width,
      child: FunvasContainer(
        funvas: Sixteen(),
      ),
    );
  }
}

///Esta clase se encarga de formar un Funvas que anime un cubo girando.

class Sixteen extends Funvas {
  @override
  void u(double t) {
    c.drawPaint(Paint()..color = colores.obtenerColorFondo());
    final d = s2q(500).width;
    const double dimenciones = 0.5;

    const cube = [
      _Vertex3(-dimenciones, -dimenciones, -dimenciones),
      _Vertex3(-dimenciones, -dimenciones, dimenciones),
      _Vertex3(dimenciones, -dimenciones, dimenciones),
      _Vertex3(dimenciones, -dimenciones, -dimenciones),
      _Vertex3(dimenciones, dimenciones, -dimenciones),
      _Vertex3(dimenciones, dimenciones, dimenciones),
      _Vertex3(-dimenciones, dimenciones, dimenciones),
      _Vertex3(dimenciones, dimenciones, dimenciones),
      _Vertex3(dimenciones, -dimenciones, dimenciones),
      _Vertex3(-dimenciones, -dimenciones, dimenciones),
      _Vertex3(-dimenciones, dimenciones, dimenciones),
      _Vertex3(-dimenciones, dimenciones, -dimenciones),
      _Vertex3(dimenciones, dimenciones, -dimenciones),
      _Vertex3(dimenciones, -dimenciones, -dimenciones),
      _Vertex3(-dimenciones, -dimenciones, -dimenciones),
      _Vertex3(-dimenciones, dimenciones, -dimenciones),
    ];

    const camera = _Vertex3(0, 0, -3);
    final f = sqrt(pow(camera.x, 2) + pow(camera.y, 2) + pow(camera.z, 2));

    final slowedT = t / 10;
    final sectionedT = slowedT % 2 ~/ 1;

    Offset transform(_Vertex3 vertex) {
      final transformed = Offset(
        ((vertex.x - camera.x) * (f / (vertex.z - camera.z))) + camera.x,
        ((vertex.y - camera.y) * (f / (vertex.z - camera.z))) + camera.y,
      );
      return transformed * d / 2 + Offset(d / 2, d / 2);
    }

    _Vertex3 rotate(_Vertex3 vertex) {
      final radians = Curves.fastOutSlowIn.transform(slowedT % 1) * 2 * pi;
      _Vertex3 preRotated;
      switch (sectionedT) {
        case 0:
          preRotated = _Vertex3(
            vertex.x * cos(radians) + vertex.z * sin(radians),
            vertex.y,
            -vertex.x * sin(radians) + vertex.z * cos(radians),
          );
          break;
        case 1:
          preRotated = _Vertex3(
            vertex.x,
            vertex.y * cos(radians) - vertex.z * sin(radians),
            vertex.y * sin(radians) + vertex.z * cos(radians),
          );
          break;
        default:
          throw UnimplementedError();
      }
      return _Vertex3(
        preRotated.x * cos(radians) - preRotated.y * sin(radians),
        preRotated.x * sin(radians) + preRotated.y * cos(radians),
        preRotated.z,
      );
    }

    final transformedCube = cube.map(rotate).map(transform).toList();
    for (var i = 0; i < transformedCube.length - 1; i++) {
      final p1 = transformedCube[i];
      final p2 = transformedCube[i + 1];
      c.drawLine(
        p1,
        p2,
        Paint()
          ..color = colores.obtenerColorTres().withBlue(i * 222 ~/ transformedCube.length)
          ..strokeWidth = 11
          ..strokeCap = StrokeCap.round,
      );
    }
  }
}

class _Vertex3 {
  const _Vertex3(this.x, this.y, this.z);

  final double x, y, z;
}