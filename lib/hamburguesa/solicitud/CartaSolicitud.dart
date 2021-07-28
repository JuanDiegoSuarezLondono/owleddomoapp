import 'package:flutter/material.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/shared/TratarError.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'package:owleddomoapp/hamburguesa/solicitud/Solicitud.dart';
import 'package:owleddomoapp/hamburguesa/solicitud/ServiciosSolicitud.dart';

///Esta clase se encarga de construir la vista dentro de la carta de una
///solicitud, dotándola de un título, una breve descripcion de quien lo envia y del
///dispositivo que se comparte y, un par debotones para aceptar o negar.
///@version 1.0, 06/04/21.
///@author Juan Diego Suárez Londoño.
///@param usuario propietario de las peticiones.
///@param peticion identificador unico de la peticion.
///@see owleddomo_app/cuartos/CuartosTabla/CuartosLista.dart#class().
///@return un Widget Container con la plantilla de la carta de un cuarto.

class CartaSolicitud extends StatefulWidget{

  final Persona usuario; //Propietario de las peticiones.
  final Solicitud peticion; //Identificador unico de la peticion.

  CartaSolicitud(this.usuario,this.peticion) :super(); //Constructor de la clase.

  @override
  _CartaSolicitud createState() => _CartaSolicitud(usuario,peticion); //Crea un estado mutable del Widget.

}

///Esta clase se encarga de formar un estado mutable de la clase “CartaSolicitud”.
///@param _usuario propietario de las peticiones.
///@param _peticion identificador unico de la peticion.
///@param _width obtiene el ancho de la pantalla del dispositivo.
///@param _height obtiene el alto de la pantalla del dispositivo.

class _CartaSolicitud extends State<CartaSolicitud> {

  final Persona _usuario; //Propietario de las peticiones.
  final Solicitud _peticion; //Identificador unico de la peticion.

  _CartaSolicitud(this._usuario,this._peticion); //Constructor de la clase.

  @override

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState();
  }

  ///Actualiza o elimina la petición de acuerdo con si el invitado ha aceptado o no.
  ///@param solicitud identificador de la solicitud.
  ///@param accion identificador para saber si ha aceptado o no.
  ///@see owleddomo_app/hamburguesa/solicitud/ServicioSolicitud.aceptarSolicitud.dart#class().
  ///@see owleddomo_app/hamburguesa/solicitud/ServicioSolicitud.negarSolicitud.dart#class().

  _alPresionar (Solicitud solicitud, String accion) {
    if(accion == "1") {
      ServiciosSolicitud.aceptarSolicitud(_usuario.persona_id, solicitud.permiso_id)
          .then((result) {
            String respuesta =  TratarError(_usuario).estadoSnackbar(result, context).first.toString();
            if ( respuesta[0] != "2") {
              if (mounted) {
                setState(() {
                  solicitud.estado ='pendiente';
                });
              }
            }
      });
      if (mounted) {
        setState(() {
          solicitud.estado ='aceptado';
        });
      }
    } else {
      ServiciosSolicitud.negarSolicitud(_usuario.persona_id,solicitud.permiso_id)
          .then((result) {
        Navigator.of(context).pop(null);
        Navigator.of(context).pop(null);
      });;
    }
  }

  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    ///Construye el Widget del botón negar petición.
    ///@param solicitud parametros de la solicitud.
    ///@return un Contianer que posee un botón.

    Widget _botonNegar (Solicitud solicitud) {
      return Container(
        child:ConstrainedBox(
          constraints: BoxConstraints.tightFor(height: _height/17.6),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: PaletaColores(_usuario).obtenerColorRiesgo(),
              shape: CircleBorder(),
            ),
            onPressed: () {
              _alPresionar (solicitud, "0");
            },
            child: Icon(
              Icons.clear,
              color: PaletaColores(_usuario).obtenerContrasteRiesgo(),
              size: _height/26.4,
            ),
          ),
        ),
      );
    }

    ///Construye el Widget del botón aceptar petición.
    ///@param solicitud parametros de la solicitud.
    ///@return un Contianer que posee un botón.

    Widget _botonAceptar (Solicitud solicitud) {
      return Container(
        child:ConstrainedBox(
          constraints: BoxConstraints.tightFor(height: _height/17.6),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: PaletaColores(_usuario).obtenerTerciario(),
              shape: CircleBorder(),
            ),
            onPressed: () {
              _alPresionar (solicitud, "1");
            },
            child: Icon(
              Icons.thumb_up,
              color: PaletaColores(_usuario).obtenerContrasteRiesgo(),
              size: _height/26.4,
            ),
          ),
        ),
      );
    }

    ///Construye el Widget de la carta de la petición.
    ///@param solicitud parametros de la solicitud.
    ///@return un Card que posee una columna contextos y botones.

    Widget _carta(Solicitud solicitud) {
      String remitente = "Fulano";
      if(solicitud.apodo != null) {
        remitente = solicitud.apodo;
      } else {
        remitente = '${solicitud.nombres} ${solicitud.apellidos}';
      }
      return Card(
        margin: EdgeInsets.only(top: _height/79.2),
        color: PaletaColores(_usuario).obtenerPrimario(),
        child: Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.all(_height/39.6),
          width: _width/1.285714285714286,
          child: Column (
            children: <Widget>[
              Text(
                '¡Alguien confía en ti!',
                style: TextStyle(
                  color: PaletaColores(_usuario).obtenerLetraContrastePrimario(),
                  fontSize: _height/31.68,
                  fontFamily: "Lato",
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  '\nPropietario: ${remitente}.\n\n Tipo de dispositivo: ${solicitud.tipo}.'
                      '\n\n Nombre dispositivo: ${solicitud.nombre}.',
                  style: TextStyle(
                    color: PaletaColores(_usuario).obtenerLetraContrastePrimario(),
                    fontSize: _height/52.8,
                    fontFamily: "Lato",
                    height: 1,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: _height/52.8),
                child: Row(
                  mainAxisAlignment: solicitud.estado == "pendiente" ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    solicitud.estado == "pendiente" ? _botonAceptar (solicitud)
                        : Container(
                      margin: EdgeInsets.only(right: _width/36),
                      child: Text(
                        "Has aceptado",
                        style: TextStyle(
                          color: PaletaColores(_usuario).obtenerLetraContrastePrimario(),
                          fontSize: _height/52.8,
                          fontFamily: "Lato",
                          height: 1,
                        ),
                      ),
                    ),
                    solicitud.estado == "pendiente" ? _botonNegar (solicitud)
                        : Icon(
                      Icons.favorite,
                      color: PaletaColores(_usuario).obtenerCuaternario(),
                      size: _height/33,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return _carta(_peticion);
  }
}