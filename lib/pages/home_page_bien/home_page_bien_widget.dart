import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'home_page_bien_model.dart';
export 'home_page_bien_model.dart';

// Imports para la lectura de jsons
import 'package:path_provider/path_provider.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';


//Imports para firebase
//Firebase:
import 'package:cloud_firestore/cloud_firestore.dart';



class HomePageBienWidget extends StatefulWidget {
  const HomePageBienWidget({super.key});

  @override
  State<HomePageBienWidget> createState() => _HomePageBienWidgetState();
}

class _HomePageBienWidgetState extends State<HomePageBienWidget> {
  late HomePageBienModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<dynamic>> fetchRoomHours(String date, String room) async {
    try {
      // Restablecer las horas seleccionadas, solo se puede seleccionar para un dia en concreto
      _model.selectedHours!.clear();

      // Obtén el documento específico por fecha
      print(date);
      print(room);
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('aulas')
          .doc(date)
          .get();
      
      if (snapshot.exists) {
        // Accede al campo de la sala específica
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        if (data.containsKey(room)) {
          print(data[room]);
          return data[room] as List<dynamic>;
        } else {
          throw Exception('La sala no existe en este documento.');
        }
      } else {
        throw Exception('No existe un documento para esta fecha.');
      }
    } catch (e) {
      print('Error al leer los datos: $e');
      return [];
    }
  }
  
  Future<void> removeSelectedHours(String date, String room, List<dynamic>? selectedHours) async {
    try {
      DocumentReference docRef = FirebaseFirestore.instance.collection('aulas').doc(date);

      // Elimina las horas seleccionadas de la lista
      await docRef.update({
        room: FieldValue.arrayRemove(selectedHours!),
      });

      print("Horas eliminadas correctamente: $selectedHours");
      // Restablecer los valores por defecto
      restablecerValores();
      print("Aceptado y restablecido todo");
    } catch (e) {
      print("Error al eliminar las horas: $e");
    }
  }

  Future<void> crearOActualizarUsuario() async {
    // Definir las variables
    String email = _model.emailFormTextController!.text;
    String nombre = _model.nameFormTextController!.text;
    String apellidos = _model.surnameFormTextController!.text;
    String telefono = _model.phoneFormTextController!.text;
    String? salaSeleccionada = _model.salaFormValue;
    DateTime? fechaSeleccionada = FFAppState().selectedDate;
    List? horasSeleccionadas = _model.selectedHours;

    // Obtén una referencia a la colección 'usuarios'
    CollectionReference usuarios = FirebaseFirestore.instance.collection('usuarios');
    
    // Crea el documento con el ID del email (si no existe)
    DocumentReference usuarioDoc = usuarios.doc(email);

    // Usamos .set() para crear o sobrescribir el documento
    await usuarioDoc.set({
      'nombre': nombre,
      'apellidos': apellidos,
      'telefono': telefono,
      'salaSeleccionada': salaSeleccionada,
      'fechaSeleccionada': fechaSeleccionada,
      'horasSeleccionadas': horasSeleccionadas,
    }, SetOptions(merge: true)); // merge: true garantiza que se sobrescriban los datos

    print('Documento de usuario creado o actualizado');
  }


  void restablecerValores(){
    /*Funcion que restablece a por defecto los valores*/
    // Restablecer valores del modelo
    print("La lista antes ${_model.dbData}");
    _model.dbData!.clear();
    _model.selectedHours!.clear();
    print("La lista despues ${_model.dbData}");

    // Restablecer controladores de texto si existen
    _model.nameFormTextController?.clear();
    _model.surnameFormTextController?.clear();
    _model.emailFormTextController?.clear();
    _model.phoneFormTextController?.clear();

    // Restablecer fecha seleccionada
    _model.datePicked = null;
    print("SelectedDate antes ${FFAppState().selectedDate}");
    FFAppState().selectedDate = null;
    print("SelectedDate después ${FFAppState().selectedDate}");

    // Restablecer dropdown (asegúrate de manejar el estado correctamente)
    _model.salaFormValueController?.value = '0';
    _model.salaFormValue = "Sala";
    
    safeSetState(() {});
    
    // Verifica el estado después de restablecer
    print("Valores restablecidos");
    print("dbData: ${_model.dbData}");
  }
  
  bool isEmailValid(String? email) {
    // Funcion que comprueba que el email tiene el formato correcto
    if (email == null || email.isEmpty) return false;

    // Expresión regular para validar el formato de correo electrónico
    final regex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return regex.hasMatch(email);
  } 

  bool areAllFieldsFilled() {
    // Funcion que comprueba si uno de los campos a rellenar esta incompleto y por tanto, no debe hacer la reserva
    
    // Verificar si _model.dbData no está vacío
    if (_model.dbData == null || _model.dbData!.isEmpty) {
      return false;
    }
    
    // Verificar si las horas seleccionadas no esta vacio
    if (_model.selectedHours == null || _model.selectedHours!.isEmpty) {
      return false;
    }

    // Verificar si _model.nameFormTextController tiene texto
    if (_model.nameFormTextController?.text == null ||
        _model.nameFormTextController!.text.isEmpty) {
      return false;
    }

    // Verificar si _model.surnameFormTextController tiene texto
    if (_model.surnameFormTextController?.text == null ||
        _model.surnameFormTextController!.text.isEmpty) {
      return false;
    }

    // Verificar si _model.salaFormValue tiene un valor válido
    if (_model.salaFormValue == null || _model.salaFormValue == "Sala") {
      return false;
    }

    // Verificar si FFAppState().selectedDate no está vacío
    if (FFAppState().selectedDate == null) {
      return false;
    }

    // Verificar si _model.emailFormTextController tiene texto
    if (_model.emailFormTextController?.text == null ||
        _model.emailFormTextController!.text.isEmpty) {
      return false;
    }

    // Verificar si el email tiene un formato valido
    if (!isEmailValid(_model.emailFormTextController?.text)) {
      return false; // El correo no tiene un formato válido
    }

    // Verificar si _model.phoneFormTextController tiene texto
    if (_model.phoneFormTextController?.text == null ||
        _model.phoneFormTextController!.text.isEmpty) {
      return false;
    }

    // Verificar si _model.phoneFormTextController tiene los digitos exactos
    if (_model.phoneFormTextController?.text.length != 9){
      return false;
    }

    // Verificar si _model.salaFormValueController tiene un valor válido
    if (_model.salaFormValueController?.value == null ||
        _model.salaFormValueController!.value == '0') {
      return false;
    }

    // Si todas las condiciones pasan, devolver true
    return true;
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageBienModel());

    _model.nameFormTextController ??= TextEditingController();
    _model.nameFormFocusNode ??= FocusNode();

    _model.surnameFormTextController ??= TextEditingController();
    _model.surnameFormFocusNode ??= FocusNode();

    _model.emailFormTextController ??= TextEditingController();
    _model.emailFormFocusNode ??= FocusNode();

    _model.phoneFormTextController ??= TextEditingController();
    _model.phoneFormFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Shortcuts(
      shortcuts: {},
      child: Actions(
        actions: {
          VoidCallbackIntent: CallbackAction<VoidCallbackIntent>(
            onInvoke: (intent) => intent.callback(),
          ),
        },
        child: Focus(
            autofocus: isShortcutsSupported,
            focusNode: _model.shortcutsFocusNode,
            child: GestureDetector(
              onTap: () => isShortcutsSupported &&
                      _model.shortcutsFocusNode.canRequestFocus
                  ? FocusScope.of(context)
                      .requestFocus(_model.shortcutsFocusNode)
                  : FocusScope.of(context).unfocus(),
              child: Scaffold(
                key: scaffoldKey,
                backgroundColor: Color(0xFFD1D3D4),
                appBar: AppBar(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  automaticallyImplyLeading: false,
                  title: Text(
                    'App Reserva de Sala',
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Inter Tight',
                          color: Colors.white,
                          fontSize: 22.0,
                          letterSpacing: 0.0,
                        ),
                  ),
                  actions: [],
                  centerTitle: false,
                  elevation: 2.0,
                ),
                body: SafeArea(
                  top: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Text(
                          'Información personal',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Inter',
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 24.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w900,
                                lineHeight: 2.0,
                              ),
                        ),
                      ),
                      Form(
                        key: _model.formKey,
                        autovalidateMode: AutovalidateMode.always,
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          width: 200.0,
                                          child: TextFormField(
                                            controller:
                                                _model.nameFormTextController,
                                            focusNode: _model.nameFormFocusNode,
                                            autofocus: false,
                                            autofillHints: [AutofillHints.name],
                                            textCapitalization:
                                                TextCapitalization.words,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              labelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                      ),
                                              hintText: 'Nombre',
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                      ),
                                              errorStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        letterSpacing: 0.0,
                                                      ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 5.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 5.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 5.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 5.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              filled: true,
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              prefixIcon: Icon(
                                                Icons.person,
                                                color: FlutterFlowTheme.of(context).secondaryText
                                              ),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Inter',
                                                  letterSpacing: 0.0,
                                                ),
                                            cursorColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            validator: _model
                                                .nameFormTextControllerValidator
                                                .asValidator(context),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp('[a-zA-Z]'))
                                            ],
                                          ).blockShortcuts() // Prevents the shortcut(s) from triggering while typing in the text field
                                          ,
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width: 200.0,
                                          child: TextFormField(
                                            controller: _model
                                                .surnameFormTextController,
                                            focusNode:
                                                _model.surnameFormFocusNode,
                                            autofocus: false,
                                            autofillHints: [AutofillHints.name],
                                            textCapitalization:
                                                TextCapitalization.words,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              labelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                      ),
                                              hintText: 'Apellidos',
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                      ),
                                              errorStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        letterSpacing: 0.0,
                                                      ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 5.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 5.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 5.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 5.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              filled: true,
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Inter',
                                                  letterSpacing: 0.0,
                                                ),
                                            cursorColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            validator: _model
                                                .surnameFormTextControllerValidator
                                                .asValidator(context),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp('[a-zA-Z]'))
                                            ],
                                          ).blockShortcuts() // Prevents the shortcut(s) from triggering while typing in the text field
                                          ,
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 15.0)),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        width: 200.0,
                                        child: TextFormField(
                                          controller:
                                              _model.emailFormTextController,
                                          focusNode: _model.emailFormFocusNode,
                                          autofocus: false,
                                          autofillHints: [AutofillHints.email],
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Inter',
                                                      letterSpacing: 0.0,
                                                    ),
                                            hintText: 'Correo electrónico',
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                      fontFamily: 'Inter',
                                                      letterSpacing: 0.0,
                                                    ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 5.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                width: 5.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 5.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 5.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            filled: true,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            prefixIcon: Icon(
                                              Icons.email_outlined,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                            ),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                letterSpacing: 0.0,
                                              ),
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryText,
                                          validator: _model
                                              .emailFormTextControllerValidator
                                              .asValidator(context),
                                        ).blockShortcuts() // Prevents the shortcut(s) from triggering while typing in the text field
                                        ,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        width: 200.0,
                                        child: TextFormField(
                                          controller:
                                              _model.phoneFormTextController,
                                          focusNode: _model.phoneFormFocusNode,
                                          autofocus: false,
                                          autofillHints: [
                                            AutofillHints.telephoneNumber
                                          ],
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                      fontFamily: 'Inter',
                                                      letterSpacing: 0.0,
                                                    ),
                                            alignLabelWithHint: false,
                                            hintText: 'Teléfono',
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                      fontFamily: 'Inter',
                                                      letterSpacing: 0.0,
                                                    ),
                                            errorStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Inter',
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      letterSpacing: 0.0,
                                                    ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 5.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                width: 5.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 5.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 5.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            filled: true,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            hoverColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            prefixIcon: Icon(
                                              Icons.phone_sharp,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                            ),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                letterSpacing: 0.0,
                                              ),
                                          maxLength: 9,
                                          maxLengthEnforcement:
                                              MaxLengthEnforcement.enforced,
                                          keyboardType: TextInputType.phone,
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryText,
                                          validator: _model
                                              .phoneFormTextControllerValidator
                                              .asValidator(context),
                                          inputFormatters: [
                                            _model.phoneFormMask
                                          ],
                                        ).blockShortcuts() // Prevents the shortcut(s) from triggering while typing in the text field
                                        ,
                                      ),
                                    ),
                                  ],
                                ),
                              ]
                                  .divide(SizedBox(height: 7.0))
                                  .around(SizedBox(height: 7.0)),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Text(    
                          'Reserva',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    fontSize: 24.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w900,
                                    lineHeight: 2.0,
                                  ),
                        ),
                      ),
                      Container(
                        width: 373.0,
                        decoration: BoxDecoration(
                          color: Color(0xFCB7C7CB),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: FlutterFlowDropDown<String>(
                                      controller:
                                          _model.salaFormValueController ??=
                                              FormFieldController<String>(null),
                                      options: ['Sala 1', 'Sala 2', 'Sala 3'],
                                      onChanged: (val) async {
                                        safeSetState(() {
                                          _model.salaFormValue = val;
                                          print("SalaformValue: ${_model.salaFormValue}");
                                          print ("val:  $val");
                                        });
                                        // Verifica las condiciones y llama a cargarJson
                                        if ((_model.salaFormValue == "Sala 1" || 
                                            _model.salaFormValue == "Sala 2" || 
                                            _model.salaFormValue == "Sala 3") &&
                                            (_model.datePicked != null)) {
                                          _model.dbData = await fetchRoomHours(dateTimeFormat("d-M-y", _model.datePicked).toString(), _model.salaFormValue.toString());
                                          safeSetState(() {});
                                          print("Los horarios disponibles son ${_model.dbData}");
                                        }
                                      },
                                      width: 145.0,
                                      height: 40.0,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                            color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                          ),
                                      hintText: 'Sala',
                                      icon: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 24.0,
                                      ),
                                      fillColor: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      elevation: 2.0,
                                      borderColor: Colors.transparent,
                                      borderWidth: 0.0,
                                      borderRadius: 8.0,
                                      margin: EdgeInsetsDirectional.fromSTEB(
                                          12.0, 0.0, 12.0, 0.0),
                                      hidesUnderline: true,
                                      isOverButton: false,
                                      isSearchable: false,
                                      isMultiSelect: false,
                                    ),
                                  ),
                                  FFButtonWidget(
                                    onPressed: () async {
                                      final datePickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: getCurrentTimestamp,
                                        firstDate: getCurrentTimestamp,
                                        locale: const Locale('es'),
                                        lastDate: DateTime(2050),
                                        builder: (context, child) {
                                          return wrapInMaterialDatePickerTheme(
                                            context,
                                            child!,
                                            headerBackgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            headerForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .info,
                                            headerTextStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineLarge
                                                    .override(
                                                      fontFamily: 'Inter Tight',
                                                      fontSize: 32.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                            pickerBackgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            pickerForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            selectedDateTimeBackgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            selectedDateTimeForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .info,
                                            actionButtonForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            iconSize: 24.0,
                                          );
                                        },
                                      );

                                      if (datePickedDate != null) {
                                        safeSetState(() {
                                          _model.datePicked = DateTime(
                                            datePickedDate.year,
                                            datePickedDate.month,
                                            datePickedDate.day,
                                          );
                                        });
                                        // Verifica las condiciones y llama a cargarJson
                                        if ((_model.salaFormValue == "Sala 1" || 
                                            _model.salaFormValue == "Sala 2" || 
                                            _model.salaFormValue == "Sala 3") &&
                                            (_model.datePicked != null)) {
                                          _model.dbData = await fetchRoomHours(dateTimeFormat("d-M-y", _model.datePicked).toString(), _model.salaFormValue.toString());
                                        }
                                      }
                                      FFAppState().selectedDate =
                                          _model.datePicked;
                                      safeSetState(() {});
                                    },
                                    text: valueOrDefault<String>(
                                      dateTimeFormat(
                                          "d/M/y", FFAppState().selectedDate),
                                      'Seleccione fecha',
                                    ),
                                    icon: Icon(
                                      Icons.calendar_month,
                                      size: 15.0,
                                    ),
                                    options: FFButtonOptions(
                                      height: 40.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                          ),
                                      elevation: 0.0,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ].divide(SizedBox(width: 10.0)),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-1.0, 0.0),
                                      child: Text(
                                        'Seleccione el horario para la sala',
                                        textAlign: TextAlign.start,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              fontSize: 20.0,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Container(
                                          width: 1051.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF95ABB4),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Wrap(
                                                    spacing: 4.0,
                                                    runSpacing: 8.0,
                                                    alignment:
                                                        WrapAlignment.center,
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .center,
                                                    direction: Axis.horizontal,
                                                    runAlignment: WrapAlignment
                                                        .spaceEvenly,
                                                    verticalDirection:
                                                        VerticalDirection.down,
                                                    clipBehavior: Clip.none,
                                                    children: (_model.dbData == null ||_model.dbData!.isEmpty)
                                                          ? [
                                                            Container(
                                                              padding: EdgeInsets.all(16.0),
                                                              child: Text(
                                                                "No hay horarios disponibles",
                                                                style: TextStyle(
                                                                  fontSize: 16.0,
                                                                  color: Colors.black,
                                                                ),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                          ] // Si _model.jsonData o los datos relacionados son nulos, no hay hijos
                                                          : _model.dbData!
                                                            .map<Widget>((hour) {
                                                              bool isPressed = (_model.buttonPressed[hour] ?? false) && (_model.selectedHours?.contains(hour) ?? false);
                                                                return ElevatedButton(
                                                                  onPressed: () {
                                                                    setState(() {
                                                                      // Cambiar el estado de presionado
                                                                      _model.buttonPressed[hour] = !isPressed;
                                                                      print("Hora seleccionada $hour");
                                                                      
                                                                      if (!_model.selectedHours!.contains(hour) && _model.buttonPressed[hour] == true){
                                                                        //Guardar la hora
                                                                        print("Guardar la hora $hour");
                                                                        _model.selectedHours!.add(hour);
                                                                        }
                                                                      else if (_model.selectedHours!.contains(hour) && _model.buttonPressed[hour] == false) {
                                                                        print("Elimino la hora $hour");
                                                                        _model.selectedHours!.remove(hour);
                                                                      }
                                                                    });
                                                                    
                                                                  },
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: (/*isPressed && _model.selectedHours!.isNotEmpty ||*/ _model.selectedHours!.contains(hour))    
                                                                        ? Colors.grey // Color oscuro cuando se presiona
                                                                        : Colors.red, 
                                                                        //FlutterFlowTheme.of(context).primary, // Color de fondo normal
                                                                    foregroundColor: Colors.white, // Color del texto
                                                                    elevation: 5, // Agregar elevación para efecto de sombreado
                                                                    splashFactory: InkSplash.splashFactory, // Efecto de la pulsación
                                                                  ),
                                                                  child: Text(hour), // Mostrar la hora como texto del botón
                                                                );
                                                              }).toList(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]
                                      .divide(SizedBox(height: 15.0))
                                      .addToStart(SizedBox(height: 10.0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FFButtonWidget(
                            onPressed: () async {

                              safeSetState(() {
                                // Valores de texto
                                restablecerValores();
                              });
                            },
                            text: 'Borrar todo',
                            options: FFButtonOptions(
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Inter Tight',
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                  ),
                              elevation: 0.0,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          FFButtonWidget(
                            onPressed: () async {
                              // Comprobar si se han completado todos los campos
                              bool allFieldsFilled = areAllFieldsFilled();
                              if (allFieldsFilled == true) {  // Campos completos
                                showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Reserva de Sala'),
                                    content: Text('¿Quieres confirmar esta selección?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Cierra el pop-up
                                        },
                                        child: Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Acción que se ejecuta al confirmar
                                          print('Selección confirmada');
                                          removeSelectedHours(dateTimeFormat("d-M-y", _model.datePicked).toString(), _model.salaFormValue.toString(), _model.selectedHours);
                                          crearOActualizarUsuario();
                                          Navigator.of(context).pop(); // Cierra el pop-up
                                          
                                          // Mostrar un mensaje de retroalimentacion para informar al usuario que su reserva ha sido realizada
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Operación Completada"),
                                                  content: Text("La acción se realizó exitosamente."),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop(); // Cierra el segundo diálogo
                                                      },
                                                      child: Text("Aceptar"),
                                                    ),
                                                  ],
                                                );
                                              },                                              
                                          );
                                        },
                                        child: Text('Confirmar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              }
                              else{ // Campos vacios
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Fallo en la reserva'),
                                      content: Text('Debe completar todos los campos'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Cierra el pop-up
                                          },
                                          child: Text('Aceptar'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            
                            },
                            text: 'Aceptar',
                            options: FFButtonOptions(
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Inter Tight',
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                  ),
                              elevation: 0.0,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ],
                      ),
                    ].divide(SizedBox(height: 15.0)),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}