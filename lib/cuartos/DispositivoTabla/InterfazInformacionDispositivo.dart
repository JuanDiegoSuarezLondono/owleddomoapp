import 'package:flutter/material.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/Variable/ServiciosVariable.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/InterfazEditarDispositivo.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/Variable/InterruptorLuz.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/ServiciosDispositivo.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/Variable/AbiertoCerrado.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/Variable/Variable.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/Variable/LuzRGB.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/Variable/Alerta.dart';
import 'package:owleddomoapp/cuartos/DispositivoTabla/Variable/Golpe.dart';
import 'package:owleddomoapp/hamburguesa/solicitud/ServiciosSolicitud.dart';
import 'package:owleddomoapp/hamburguesa/solicitud/Solicitud.dart';
import 'package:owleddomoapp/shared/SubPantallaUno.dart';
import 'package:owleddomoapp/shared/PaletaColores.dart';
import 'package:owleddomoapp/shared/TratarError.dart';
import 'package:owleddomoapp/login/Persona.dart';
import 'package:flutter_particles/particles.dart';

///Esta clase se encarga de la pantalla donde se muestra la información del dispositivo
///y su lógica.
///@version 1.0, 06/04/21
///@author Juan Diego Suárez Londoño
///@param relacionId identificador del producto.
///@param nombre nombre del dispositivo.
///@param pathFoto path de la imagen del dispositivo.
///@param fecha_modificacion última fecha de modificación del dispositivo.
///@param usuario identificador del usuario.
///@see owleddomo_app/cuartos/DispositivoTabla/DispositivosLista.dart#class().
///@return un Widget Stack con la información básica del dispositivo como la imagen,
///el nombre y la fecha del último cambio, además, las variables de dicho dispositivo.

class InterfazInformacionDispositivo extends StatefulWidget{

  final String relacionId; //Identificador del producto.
  final String nombre; //Nombre del dispositivo.
  final String pathFoto; //PathFoto path de la imagen del dispositivo.
  final String fechaModificacion; //Fecha_modificacion última fecha de modificación del dispositivo.
  final Persona usuario; //Usuario identificador del usuario.
  InterfazInformacionDispositivo(this.relacionId, this.nombre, this.pathFoto,
                                 this.fechaModificacion, this.usuario); //Constructor de la clase.

  @override
  State<StatefulWidget> createState() {
    return _InterfazInformacionDispositivo(relacionId, nombre, pathFoto,
                                           fechaModificacion, usuario); //Crea un estado mutable del Widget.
  }

}

///Esta clase se encarga de formar un estado mutable de la clase “InterfazInformacionDispositivo”.
///@param _relacionId identificador del producto.
///@param _nombre nombre del dispositivo.
///@param _pathFoto path de la imagen del dispositivo.
///@param _usuario identificador del usuario.
///@param _variablesObtenidas lista con el mapeo de las variables.
///@param _estado estado del servicio de obtener dispositivos.
///@param _width obtiene el ancho de la pantalla del dispositivo.
///@param _height obtiene el alto de la pantalla del dispositivo.

class _InterfazInformacionDispositivo extends State<InterfazInformacionDispositivo> {

  final String _relacionId; //Identificador del producto.
  String _nombre; //Nombre del dispositivo.
  String _pathFoto; //PathFoto path de la imagen del dispositivo.
  final String _fechaModificacion; //Fecha_modificacion última fecha de modificación del dispositivo.
  final Persona _usuario; //Usuario identificador del usuario.
  _InterfazInformacionDispositivo(this._relacionId, this._nombre, this._pathFoto,
                                  this._fechaModificacion, this._usuario); //Constructor de la clase.

  Future<List> _variablesObtenidas; //Lista con el mapeo de las variables.
  int _estado; //Estado del servicio de obtener dispositivos.

  Future<List> _solicidtudesObtenidas; //Lista con el mapeo de las variables.
  List<Solicitud> _solicitudesLista;

  TextEditingController _codigoUsuario; //Controlador del campo para el nombre en el formulario.

  @override

  ///Inicializador de las variables de la clase.

  void initState() {
    super.initState();
    _codigoUsuario = TextEditingController();//Asigna el actual nombre al campo de texto.
    _estado = 0;
    _solicitudesLista = [];
    _solicidtudesObtenidas = _obtenerPermisos();
    _variablesObtenidas = _obtenerVariables();
  }

  ///Hace una petición para conseguir un mapeo con la lista de los parámetros de los permisos.
  ///@see owleddomo_app/hamburguesa/solicitud/ServiciosSolicitud.dispositivoSolicitud#method().
  ///@see owleddomo_app/shared/TratarError.estadoServicioLeer#method().
  ///@return un mapeo con las variables.

  Future<List> _obtenerPermisos() async {
    _solicidtudesObtenidas =  ServiciosSolicitud.dispositivoSolicitud(_usuario.persona_id,_relacionId);
    _solicidtudesObtenidas.then((result) {
      if(mounted) {
        setState(() {
          _solicitudesLista = result.last;
        });
      }
    });
    return _solicidtudesObtenidas;
  }

  ///Hace una petición para conseguir un mapeo con la lista de los parámetros de los dispositivos,
  ///además actualiza el estado para saber la condición de la petición.
  ///@see owleddomo_app/cuartos/DisporitivoTabla/Variable/ServiciosVariable.variableByMAC#method().
  ///@see owleddomo_app/shared/TratarError.estadoServicioLeer#method().
  ///@return un mapeo con las variables.

  Future<List> _obtenerVariables() async {
    _variablesObtenidas =  ServiciosVariable.variableByMAC(_relacionId, _usuario.persona_id);
    _variablesObtenidas.then((result) {
      if(mounted) {
        setState(() {
          _estado = TratarError().estadoServicioLeer(result);
        });
      }
    });
    return _variablesObtenidas;
  }

  ///Agrega el cuarto o genera un error en caso de cualquier eventualidad.
  ///@see owleddomo_app/cuartos/CuartoTabla/ServiciosCuarto.agregarCuarto#method().
  ///@see owleddomo_app/shared/TratarError.estadoServicioActualizar#method().
  ///@return No retorna nada en caso de no obtener una validación positiva de los campos.

  _enviarSolicitud() {
    Navigator.of(context).pop(null);
    ServiciosSolicitud.agregarSolicitud(_usuario.persona_id,_relacionId,_codigoUsuario.text)
        .then((result) {
          TratarError().estadoSnackbar(result, context).first.toString();
    });
  }

  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width; //Obtiene el ancho de la pantalla del dispositivo.
    double _height = MediaQuery.of(context).size.height; //Obtiene el alto de la pantalla del dispositivo.

    ///Construye el Widget que maneja las animaciones de partículas del fondo.
    ///@return un Widget de Particles que contiene la animación del fondo.

    Widget _particulas() {
      return Particles(
        20,
        PaletaColores().obtenerCuaternario(),
      );
    }

    ///Construye el Widget de la imagen del dispositivo a manera de un botón.
    ///@return un Widget de Padding que contiene una imagen.

    Widget _botonImagen () {
      return Padding(
        padding: EdgeInsets.only(
          top: _height/27.31,
          left: _width/39.27,
        ),
        child: Container(
          height: _height/9.9,
          width: _height/9.9,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: PaletaColores().obtenerPrimario(),
              width: _height/300,
            ),
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(_pathFoto),
            ),
          ),
        ),
      );
    }

    ///Construye el Widget que maneja el título.
    ///@return un Widget de Padding que contiene el titulo con el nombre.

    Widget _nombreTitulo () {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _height/26.4,
          vertical: _width/24,
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Text(
            _nombre,
            textAlign: TextAlign.left,
            maxLines: 1,
            style: TextStyle(
              fontFamily: "lato",
              fontWeight: FontWeight.bold,
              fontSize: _height/19.8,
              color: PaletaColores().obtenerLetraContrasteSecundario(),
            ),
          ),
        ),
      );
    }

    ///Construye el Widget que maneja la fecha de la ultima modificacion del dispositivo.
    ///@param fecha fecha de la última modificación de algún dato del dispositivo.
    ///@return un Widget de Padding que contiene un subtítulo.

    Widget _fechaModificacionSubtitulo () {
      String fecha = _fechaModificacion.substring(0,10); //Fecha de la última modificación de algún dato del dispositivo.
      return Padding(
        padding: EdgeInsets.only(
          right: _width/12,
          left: _width/12,
          bottom: _height/158.4,
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Text(
            "Ultimo Cambio: $fecha",
            textAlign: TextAlign.left,
            maxLines: 1,
            style: TextStyle(
              fontFamily: "lato",
              color: PaletaColores().obtenerColorInactivo(),
              fontSize: _height/50,
            ),
          ),
        ),
      );
    }

    ///Construye el Widget que contiene el título y el subtítulo en una carta.
    ///@return un Widget de Padding que contiene un Card con información del dispositivo.

    Widget _pantallaPrincipal () {
      return Padding(
        padding: EdgeInsets.only(
          top: _height/10.535,
          left: _width/9.818,
        ),
        child: Card(
          color: PaletaColores().obtenerSecundario(),
          child: Container(
            height: _height/5.267,
            width: _width/1.2834,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _nombreTitulo(),
                _fechaModificacionSubtitulo(),
              ],
            ),
          ),
        ),
      );
    }

    ///Construye el Widget que maneja el botón para editar el dispositivo.
    ///@return un Widget de Container que contiene un ConstrainedBox que actúa como
    ///botón.

    Widget _botonPermiteEditar () {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: () {
        },
        child: Icon(
          Icons.edit_rounded,
          color: PaletaColores().obtenerTerciario(),
          size: _height/39.6,
        ),
      );
    }

    ///Organiza los permisos obtenidos en filas manera de una lista vertical.
    ///@param permisosObtenidos lista los permios.
    ///@param permisos columna con todos los widget de los permisos.
    ///@param nombre o apodo de el usuario al que se le ha dado el permiso.
    ///@return una lista con varias listas verticales que contienen interfaces
    ///con todas las personas a las que se les ha dado un permiso sobre el dispositivo.

    List<Widget> _armarWidgetPermisos (List permisosObtenidos) {
      List<Widget> permisos = []; //Columna con todos los widget de los permisos.
      String nombre = ""; // Nombre o apodo de el usuario al que se le ha dado el permiso.
      permisos.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: _width/24),
              child: Text(
                "Nombre",
                style: TextStyle(
                  color: PaletaColores().obtenerLetraContrastePrimario(),
                  fontFamily: "lato",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: _width/24),
              child: Text(
                "Puede editar",
                style: TextStyle(
                  color: PaletaColores().obtenerLetraContrastePrimario(),
                  fontFamily: "lato",
                ),
              ),
            ),
          ],
        ),
      );
      for(Solicitud solicitud in permisosObtenidos) {
        nombre = solicitud.apodo == null ? '${solicitud.nombres} ${solicitud.apellidos}'
                                         : solicitud.apodo;
        permisos.add(
          Card(
            margin: EdgeInsets.only(top: _height/52.8),
            color: PaletaColores().obtenerLetraContrastePrimario(),
            child: Container(
              height: _height/19.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: _width/3.272727272727273,
                    height: _height/39.6,
                    padding: EdgeInsets.only(left: _width/24),
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      primary: false,
                      shrinkWrap: true,
                      children: <Widget> [
                        Text(
                          nombre,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: "Lato",
                            color: PaletaColores().obtenerPrimario(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: _width/3.428571428571429,
                    height: _height/39.6,
                    padding: EdgeInsets.only(right: _height/24),
                    child: _botonPermiteEditar(),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return permisos;
    }

    ///Construye el Widget que maneja el botón para editar el dispositivo.
    ///@return un Widget de Container que contiene un ConstrainedBox que actúa como
    ///botón.

    Widget _botonEnviar () {
      return Container(
        margin: EdgeInsets.only(left: _width/1.636363636363636),
        child:ConstrainedBox(
          constraints: BoxConstraints.tightFor(height: _height/26.4),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              shape: CircleBorder(),
              shadowColor: Colors.transparent,
            ),
            onPressed: () {
              _enviarSolicitud();
            },
            child: Icon(
              Icons.send,
              color: PaletaColores().obtenerPrimario(),
              size: _height/39.6,
            ),
          ),
        ),
      );
    }

    ///Construye el Widget que despliega una ventana emergente que lista a las personas
    ///con las que se ha compartido el dispositivo y para enviar una solicitud a
    ///otro usuario.

    Widget _compartidos () {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (buildcontext) {
            return AlertDialog(
              backgroundColor: PaletaColores().obtenerPrimario(),
              title: Text(
                "Compartido con:",
                style: TextStyle(
                  color: PaletaColores().obtenerLetraContrastePrimario(),
                  fontFamily: "Lato",
                ),
              ),
              content: Container(
                height: _height/3.046153846153846,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  primary: false,
                  shrinkWrap: true,
                  children: _armarWidgetPermisos(_solicitudesLista),
                ),
              ),
              actions: <Widget>[
                Divider(
                  height: 20,
                  thickness: 3,
                  indent: 20,
                  endIndent: 20,
                  color: PaletaColores().obtenerColorInactivo(),
                ),
                Stack(
                  children: <Widget>[
                    Container(
                      height: _height/26.4,
                      child: TextFormField(
                        controller: _codigoUsuario,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: "lato",
                          color: PaletaColores().obtenerPrimario(),
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 0, left:_width/36, right: _width/12),
                          filled: true,
                          fillColor: PaletaColores().obtenerLetraContrastePrimario(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(180),
                          ),
                          hintText: 'Codigo de usuario',
                          hintStyle: TextStyle(
                            fontFamily: "lato",
                            color: PaletaColores().obtenerColorInactivo(),
                          ),
                        ),
                        validator: (value) {
                          //_validar();
                          String mensaje;
                          value.isEmpty ? mensaje='¡Espera!... Debes ponerle un nombre.'
                              : mensaje=null;
                          return mensaje;
                        },
                      ),
                    ),
                    _botonEnviar(),
                  ],
                ),
              ],
            );
          }
      );
    }

    ///Construye el Widget que despliega una ventana emergente para confirmar la
    ///desvinculacion del dispositivo.

    Widget _confirmarBorrar () {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (buildcontext) {
            return AlertDialog(
              backgroundColor: PaletaColores().obtenerPrimario(),
              title: Text(
                "¿Está seguro?",
                style: TextStyle(
                  color: PaletaColores().obtenerLetraContrastePrimario(),
                  fontFamily: "Lato",
                ),
              ),
              content: Text(
                "Al eliminar este dispositivo se perderá la configuración guardada, "
                    "ademas, habilitara que otro pueda escanear el código QR.",
                style: TextStyle(
                  color: PaletaColores().obtenerLetraContrastePrimario(),
                  fontFamily: "Lato",
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: PaletaColores().obtenerTerciario(),
                  ),
                  child:Container (
                    width: _width/6.428571428571429,
                    child: Row (
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        Icon(
                          Icons.warning_rounded,
                          color: PaletaColores().obtenerLetraContrastePrimario(),
                          size: _height/26.4,
                        ),
                        Text(
                          "OK",
                          style: TextStyle(
                            color: PaletaColores().obtenerLetraContrastePrimario(),
                            fontFamily: "Lato",
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    ServiciosDispositivo.borrarDispositivo(_relacionId, _usuario.persona_id)
                        .then((result) {
                          TratarError().tarjetaDeEstado( result, [_nombre, _pathFoto], context);
                        });
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: PaletaColores().obtenerColorRiesgo(),
                  ),
                  child:Container (
                    width: _width/6.428571428571429,
                    child: Row (
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        Text(
                          "Cancelar",
                          style: TextStyle(
                            color: PaletaColores().obtenerLetraContrastePrimario(),
                            fontFamily: "Lato",
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: (){
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          }
      );
    }

    ///Construye el Widget que maneja el botón para editar el dispositivo.
    ///@return un Widget de Container que contiene un ConstrainedBox que actúa como
    ///botón.

    Widget _botonEditar () {
      return Container(
        child:ConstrainedBox(
          constraints: BoxConstraints.tightFor(height: _height/14.4),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: PaletaColores().obtenerTerciario(),
              shape: CircleBorder(),
            ),
            onPressed: () {
              Route route = MaterialPageRoute (
                builder: (context) => SubPantallaUno(InterfazEditarDispositivo(_relacionId, _nombre, _pathFoto,_usuario.persona_id),"Editando"),
              );
              Navigator.push(context, route).then((value) =>{
                if ( value != false ) {
                  setState(() {
                    _nombre = value[0];
                    _pathFoto= value[1];
                  }),
                }
              });
            },
            child: Icon(
              Icons.edit_rounded,
              color: PaletaColores().obtenerContrasteRiesgo(),
              size: _height/26.4,
            ),
          ),
        ),
      );
    }

    ///Construye el Widget que maneja el botón para desvincular el dispositivo.
    ///@return un Widget de Container que contiene un ConstrainedBox que actúa como
    ///botón.

    Widget _botonCompartir () {
      return Padding(
        padding:EdgeInsets.only(
          bottom: _height/3.96,
        ),
        child: Center(
          child:ConstrainedBox(
            constraints: BoxConstraints.tightFor(height: _height/19.8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: PaletaColores().obtenerPrimario(),
              ),
              onPressed: () {
                _compartidos();
              },
              child: Icon(
                Icons.group_add,
                color: PaletaColores().obtenerLetraContrastePrimario(),
                size: _height/39.6,
              ),
            ),
          ),
        ),
      );
    }

    ///Construye el Widget que maneja el botón para desvincular el dispositivo.
    ///@return un Widget de Container que contiene un ConstrainedBox que actúa como
    ///botón.

    Widget _botonBorrar () {
      return Container(
        child:ConstrainedBox(
          constraints: BoxConstraints.tightFor(height: _height/14.4),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: PaletaColores().obtenerColorRiesgo(),
              shape: CircleBorder(),
            ),
            onPressed: () {
              _confirmarBorrar();
            },
            child: Icon(
              Icons.delete_rounded,
              color: PaletaColores().obtenerContrasteRiesgo(),
              size: _height/26.4,
            ),
          ),
        ),
      );
    }

    ///Construye el Widget que contiene los botones de editar y borrar en una misma fila.
    ///@return un Widget de Column que contiene en un Row los botones de editar y borrar.

    Widget _barraInferior () {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: _height/3.881,
            ),
            child: Stack (
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _botonEditar(),
                    _botonBorrar(),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }

    ///Construye el Widget que contiene una fila de un tipo de variable que tenga
    ///el dispositivo a manera de lista horizontal.
    ///@param fecha fecha de la última modificación de algún dato del dispositivo.
    ///@return un Widget de Container con una lista horizontal de una fila con las variables.

    Widget _filaVariable (List<Widget> lista) {
      return Container(
        width: _width,
        height: _height/6.6,
        alignment: Alignment.center,
        child: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: <Widget> [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: lista,
            )
          ],
        ),
      );
    }

    ///Selecciona las variables de un mismo grupo y las organiza en un List.
    ///@param variables lista con las variables.
    ///@param numeroGrupo numero del grupo en común al que pertenecen las variables a extraer.
    ///@param grupo variables extraídas de variables pertenecientes al grupo suministrado en numeroGrupo.
    ///@return una lista con las variables de un mismo grupo.

    List<Variable> _armarGrupo (List<Variable> variables, int numeroGrupo) {
      List<Variable> grupo = []; //Variables extraídas de variables pertenecientes al grupo suministrado en numeroGrupo.
      for(final variable in variables) {
        if(int.parse(variable.relacion_id.substring(0,2)) == numeroGrupo){
          grupo.add(variable);
        }
      }
      return grupo;
    }

    ///Organiza las variables obtenidas en filas y columnas a manera de lista vertical.
    ///@param variablesObtenidas lista con las variables obtenidas.
    ///@param variables columna con todas las filas de variables obtenidas.
    ///@param filaLuz fila con todas las interfaces para cada variable de tipo luz.
    ///@param filaGrabar fila con todas las interfaces para cada variable de tipo grabar.
    ///@param filaAbiertoCerrado fila con todas las interfaces para cada variable de tipo Open/Close.
    ///@param filaAlerta fila con todas las interfaces para cada variable de tipo Alerta.
    ///@param filaAbiertoCerrado fila con todas las interfaces para cada variable de tipo Open/Close.
    ///@param filaGolpe fila con todas las interfaces para cada variable de tipo Golpe.
    ///@param contadorLuz enumerador de las variables de tipo luz.
    ///@param contadorGrabar enumerador de las variables de tipo grabar.
    ///@param contadorAbiertoCerrado enumerador de las variables de tipo AbiertoCerrado.
    ///@param contadorAlerta enumerador de las variables de tipo Alerta.
    ///@param contadorGolpe enumerador de las variables de tipo Golpe.
    ///@param cantidadGrupos enumerador de la cantidad de grupos de variables que tiene el dispositivo.
    ///@param variablesRGB lista para pre-agrupar las variables de tipo RGB.
    ///@return una lista con varias listas horizontales que contienen las interfaces
    ///todas las variables organizadas según su tipo.

    List<Widget> _armarWidgetVariables (List variablesObtenidas) {

      List<Widget> variables = []; //Columna con todas las filas de variables obtenidas.
      List<Widget> filaLuz = []; //Fila con todas las interfaces para cada variable de tipo luz.
      List<Widget> filaGrabar = []; //Fila con todas las interfaces para cada variable de tipo grabar.
      List<Widget> filaAbiertoCerrado = []; //Fila con todas las interfaces para cada variable de tipo AbiertoCerrado.
      List<Widget> filaAlerta = []; //Fila con todas las interfaces para cada variable de tipo Alerta.
      List<Widget> filaGolpe = []; //Fila con todas las interfaces para cada variable de tipo Golpe.
      List<Widget> filaRGB = []; //Fila con todas las interfaces para cada variable de tipo RGB.

      int contadorLuz = 0; //Enumerador de las variables de tipo luz.
      int contadorGrabar = 0; //Enumerador de las variables de tipo grabar.
      int contadorAbiertoCerrado = 0; //Enumerador de las variables de tipo AbiertoCerrado.
      int contadorAlerta = 0; //Enumerador de las variables de tipo Alerta.
      int contadorGolpe = 0; //Enumerador de las variables de tipo Golpe.
      int cantidadGrupos = 0; //Enumerador de la cantidad de grupos de variables que tiene el dispositivo.
      List<Variable> variablesRGB = []; //Lista para pre-agrupar las variables de tipo RGB.

      if( variablesObtenidas.last != null) {
        for (final variable in variablesObtenidas.last) {
          switch (variable.variable_id) {
            case "9HZA7L57GRSYG":
              contadorLuz++;
              filaLuz.add(InterruptorLuz(variable));
              break;
            case "4TBPNLLAQPZAR":
              contadorGrabar++;
              filaGrabar.add(Text("contadorGrabar"));
              break;
            case "QRNSS74XFQMED":
              contadorAbiertoCerrado++;
              filaAbiertoCerrado.add(AbiertoCerrado(variable));
              break;
            case "4J7PARLF4QT8B":
              contadorAlerta++;
              filaAlerta.add(Alerta(variable));
              break;
            case "MZK8J3PJXFCZC":
              contadorGolpe++;
              filaGolpe.add(Golpe(variable));
              break;
            case "54XKJ9NGEC8XH":
              variablesRGB.add(variable);
              break;
          }
          cantidadGrupos = int.parse(variable.relacion_id.substring(0,2)) > cantidadGrupos ?
                           int.parse(variable.relacion_id.substring(0,2))
                           : cantidadGrupos;
        }

        if (contadorLuz > 0) {
          variables.add( _filaVariable(filaLuz));
        }
        if (contadorGrabar > 0) {
          variables.add( _filaVariable(filaGrabar));
        }
        if (contadorAbiertoCerrado > 0) {
          variables.add( _filaVariable(filaAbiertoCerrado));
        }
        if (contadorGolpe > 0) {
          variables.add( _filaVariable(filaGolpe));
        }
        if (contadorAlerta > 0) {
          variables.add( _filaVariable(filaAlerta));
        }
        if( cantidadGrupos > 0) {
          if(variablesRGB.length > 0)  {
            for(var i=1; i<=(variablesRGB.length/3);i++) {
              filaRGB.add(LuzRGB(_armarGrupo(variablesRGB,i)));
            }
            variables.add( _filaVariable(filaRGB));
          }
        }
      }
      return variables;
    }

    ///Se encarga de desplegar todas las posibles interfaces de la sección de las
    ///variables dependiendo de si hay datos o si hay un error de algún tipo.
    ///@return un Widget Padding que posee un constructor futuro de una lista
    ///para las variables del dispositivo y los errores que se presenten.

    Widget _interfazVariables() {
      return Padding(
        padding: EdgeInsets.only(
          top: _height/2.88,
        ),
        child: Container(
          child: Center(
            child: ListView(
              physics: BouncingScrollPhysics(),
              primary: false,
              shrinkWrap: true,
              children: <Widget> [
                FutureBuilder<List>(
                  future: _variablesObtenidas,
                  builder: (context, AsyncSnapshot<List> snapshot) {
                    List<Widget> children;
                    if (snapshot.hasData) {
                      if( _estado == 0 ) {
                        children = _armarWidgetVariables(snapshot.data);
                      } else if( _estado == 1){
                        children = <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.build,
                                  size: _height/7.92,
                                  color: PaletaColores().obtenerColorInactivo(),
                                ),
                              ),

                              Container(
                                child: Text(
                                  '"Internet facilita la información adecuada, en el momento adecuado, para el propósito adecuado..."\n¿Cual es el mio?',
                                  maxLines: 5,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: _width/16.36363636363636,
                                    color: PaletaColores().obtenerColorInactivo(),
                                    fontFamily: "Lato",
                                  ),
                                ),
                                width: _width/1.2,
                              ),
                            ],
                          ),
                        ];
                      } else if ( _estado == 2) {
                        children = <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.precision_manufacturing_sharp,
                                  size: _height/7.92,
                                  color: PaletaColores().obtenerColorRiesgo(),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "No se pudo conectar con el dispositivo",
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: _width/16.36363636363636,
                                    color: PaletaColores().obtenerColorRiesgo(),
                                    fontFamily: "Lato",
                                  ),
                                ),
                                width: _width/1.2,
                              ),
                            ],
                          ),
                        ];
                      }
                      else if ( _estado == 3) {
                        children = <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.local_police_rounded,
                                  size: _height/7.92,
                                  color: PaletaColores().obtenerColorRiesgo(),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "No te identificamos...\n¿Esto es tuyo?",
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: _width/16.36363636363636,
                                    color: PaletaColores().obtenerColorRiesgo(),
                                    fontFamily: "Lato",
                                  ),
                                ),
                                width: _width/1.2,
                              ),
                            ],
                          ),
                        ];
                      }
                      else if ( _estado == 4) {
                        children = <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.cloud_off_rounded,
                                  size: _height/7.92,
                                  color: PaletaColores().obtenerCuaternario(),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Un avión tumbo nuestra nube...\nEstamos trabajando en ello :)",
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: _width/16.36363636363636,
                                    color: PaletaColores().obtenerCuaternario(),
                                    fontFamily: "Lato",
                                  ),
                                ),
                                width: _width/1.2,
                              ),
                            ],
                          ),
                        ];
                      } else if ( _estado == 5 ) {
                        children = <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.device_unknown_rounded,
                                  size: _height/7.92,
                                  color: PaletaColores().obtenerColorRiesgo(),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "¡Rayos! Algo pasa con la app...",
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: _width/16.36363636363636,
                                    color: PaletaColores().obtenerColorRiesgo(),
                                    fontFamily: "Lato",
                                  ),
                                ),
                                width: _width/1.2,
                              ),
                            ],
                          ),
                        ];
                      } else if ( _estado == 6) {
                        children = <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.wifi_off_outlined,
                                  size: _height/7.92,
                                  color: PaletaColores().obtenerColorInactivo(),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Si la vida te da internet, has limonada",
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: _width/16.36363636363636,
                                    color: PaletaColores().obtenerColorInactivo(),
                                    fontFamily: "Lato",
                                  ),
                                ),
                                width: _width/1.2,
                              ),
                            ],
                          ),
                        ];
                      } else if ( _estado == 8) {
                        children = <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(PaletaColores().obtenerPrimario()),
                              ),
                            ],
                          ),
                        ];
                      } else {
                        children = <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.error_rounded,
                                  size: _height/7.92,
                                  color: PaletaColores().obtenerColorRiesgo(),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Ups... Algo salio mal",
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: _width/16.36363636363636,
                                    color: PaletaColores().obtenerColorRiesgo(),
                                    fontFamily: "Lato",
                                  ),
                                ),
                                width: _width/1.2,
                              ),
                            ],
                          ),
                        ];
                      }
                    } else if (snapshot.hasError) {
                      children = <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.error_rounded,
                                size: _height/7.92,
                                color: PaletaColores().obtenerColorRiesgo(),
                              ),
                            ),
                            Container(
                              child: Text(
                                "Ups... Algo salio mal",
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: _width/16.36363636363636,
                                  color: PaletaColores().obtenerColorRiesgo(),
                                  fontFamily: "Lato",
                                ),
                              ),
                              width: _width/1.2,
                            ),
                          ],
                        ),
                      ];
                    } else {
                      children = <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(PaletaColores().obtenerPrimario()),
                            ),
                          ],
                        ),
                      ];
                    }
                    return Column(
                      children: children,
                    );
                    },
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Stack(
      children: <Widget>[
        _particulas(),
        _botonCompartir(),
        _pantallaPrincipal(),
        _botonImagen(),
        _barraInferior(),
        _interfazVariables(),
      ],
    );
  }
}