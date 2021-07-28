import 'package:flutter/material.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';

///Esta clase se encarga de manejar la interfaz para el seleccionador de imagenes.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param imagenesListaCuarto lista de imágenes predeterminadas de los cuartos.
///@param imagenesListaDispositivos lista de imágenes predeterminadas de los dispositivos.
///@param lista indica cual lista se va a utilizar.
///@param imagenesLista lista de imágenes predeterminadas.
///@param _width obtiene el ancho de la pantalla del dispositivo.
///@param _height obtiene el alto de la pantalla del dispositivo.
///@see owleddomo_app/cuartos/Dispositivo/CuartoTabla/InterfazInformacionCuarto.dart#class().
///@see owleddomo_app/cuartos/Dispositivo/CuartoTabla/InterfazEditarCuarto.dart#class().
///@return un Widget AlertDialog que despliega una lista de iconos seleccionables.

class PopUpImagenes extends StatelessWidget {

  final Persona usuario;

  final List<String> imagenesListaCuarto= ["bano1.jpg", "bano2.jpg","bebe1.jpg","bebe2.jpg"
    ,"cocina1.jpg","cocina2.jpg","comedor1.jpg","comedor2.jpg","escaleras1.jpg"
    ,"escaleras2.jpg","habitacion1.jpg","habitacion2.jpg", "habitacion3.jpg"
    ,"oficina1.jpg","oficina2.jpg","salaEstar1.jpg","salaReunion1.jpg","salaReunion2.jpg"]; //Lista de imágenes predeterminadas de los cuartos.
  final List<String> imagenesListaDispositivos= ["camara1.jpg","cerradura1.jpg"
    ,"enchufe1.jpg","interruptor1.jpg","sensorPuerta1.jpg"]; //Lista de imágenes predeterminadas de los dispositivos.
  final String lista; //Indica cual lista se va a utilizar.

  PopUpImagenes(this.lista, this.usuario); //Constructor de la clase.

  List<String> imagenesLista; //Lista de imágenes predeterminadas.

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    switch (lista) {
      case "cuartos":
        imagenesLista = imagenesListaCuarto;
        break;
      case "dispositivos":
        imagenesLista = imagenesListaDispositivos;
        break;
    }

    ///Construye el Widget que maneja un icono seleccionable.
    ///@return un Widget Container con un botón con solo un icono.

    Widget botonIcono (index) {
      return Container(
        width: width/4.675324675324675,
        child: InkWell(
          onTap: () {
            Navigator.pop(context,'assets/img/${lista}/${imagenesLista[index]}');
          },
          child: Container(
            height: width/4.615384615384615,
            margin: EdgeInsets.symmetric(horizontal: width/180),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: PaletaColores(usuario).obtenerSecundario(),
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/img/${lista}/${imagenesLista[index]}'),
              ),
            ),
          ),
        ),
      );
    }

    ///Construye el Widget que agrupa los iconos y los arma a manera de fila.
    ///@param index posición actual en la lista de iconos.
    ///@param rows lista con una fila de iconos de la lista total de iconos.
    ///@param noLleno indica si la fila esta completa.
    ///@return un Widget Row con un grupo de iconos de la lista de iconos.

    Widget obtenerFila (index) {
      List<Widget> rows = []; // Lista con una fila de iconos de la lista total de iconos.
      bool  noLleno = false; //Indica si la fila esta completa.
      for (var _i = index; _i < index + 3; _i++) {
        if (imagenesLista.length > _i) {
          rows.add(botonIcono(_i));
        }
        else {
          noLleno = true;
          break;
        }
      }
      if (noLleno) {
        return new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: rows);
      }
      else {
        return new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: rows);
      }
    }

    ///Construye el Widget que agrupa las filas y las arma a manera de columna.
    ///@param columns lista con las columnas de la lista de rows suministrada.
    ///@return un Widget Container con una columna armada con las diferentes filas.

    Widget obtenerColumnas () {
      List<Widget> columns = []; //Lista con las columnas de la lista de rows suministrada.
      for (var _j = 0; _j < imagenesLista.length; _j += 3) {
        columns.add(obtenerFila(_j));
      }
      return new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: columns,
      );
    }

    return AlertDialog(
      backgroundColor: PaletaColores(usuario).obtenerSecundario(),
      content: Container(
        height: height/1.98,
        width: width,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            obtenerColumnas(),
          ],
        ),
      ),
    );
  }
}