import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/pages/reserva_pop_up/reserva_pop_up_widget.dart';
import 'home_page_bien_widget.dart' show HomePageBienWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class HomePageBienModel extends FlutterFlowModel<HomePageBienWidget> {
  ///  State fields for stateful widgets in this page.

  final shortcutsFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  // State field(s) for Name-Form widget.
  FocusNode? nameFormFocusNode;
  TextEditingController? nameFormTextController;
  String? Function(BuildContext, String?)? nameFormTextControllerValidator;
  String? _nameFormTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'El nombre debe ser texto';
    }

    if (!RegExp(kTextValidatorUsernameRegex).hasMatch(val)) {
      return 'El nombre debe ser texto';
    }
    return null;
  }

  // State field(s) for Surname-form widget.
  FocusNode? surnameFormFocusNode;
  TextEditingController? surnameFormTextController;
  String? Function(BuildContext, String?)? surnameFormTextControllerValidator;
  String? _surnameFormTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Los apellidos deben ser texto';
    }

    if (!RegExp(kTextValidatorUsernameRegex).hasMatch(val)) {
      return 'Los apellidos deben ser texto';
    }
    return null;
  }

  // State field(s) for Email-Form widget.
  FocusNode? emailFormFocusNode;
  TextEditingController? emailFormTextController;
  String? Function(BuildContext, String?)? emailFormTextControllerValidator;
  String? _emailFormTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Debe tener formato de email';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Debe tener formato de email';
    }
    return null;
  }

  // State field(s) for Phone-Form widget.
  FocusNode? phoneFormFocusNode;
  TextEditingController? phoneFormTextController;
  final phoneFormMask = MaskTextInputFormatter(mask: '#########');
  String? Function(BuildContext, String?)? phoneFormTextControllerValidator;
  String? _phoneFormTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'El teléfono debe ser un número de 9 dígitos';
    }

    if (!RegExp('^\\d{9}\$').hasMatch(val)) {
      return 'El teléfono debe ser un número de 9 dígitos';
    }
    return null;
  }

  // State field(s) for SalaForm widget.
  String? salaFormValue;
  FormFieldController<String>? salaFormValueController;
  DateTime? datePicked;
  List<dynamic>? dbData;
  String? salaSelected;
  List<dynamic>? selectedHours = [];
  String? horaSeleccionada;
  Map<String, bool> buttonPressed = {};


  @override
  void initState(BuildContext context) {
    shortcutsFocusNode.requestFocus();
    nameFormTextControllerValidator = _nameFormTextControllerValidator;
    surnameFormTextControllerValidator = _surnameFormTextControllerValidator;
    emailFormTextControllerValidator = _emailFormTextControllerValidator;
    phoneFormTextControllerValidator = _phoneFormTextControllerValidator;
  }

  @override
  void dispose() {
    nameFormFocusNode?.dispose();
    nameFormTextController?.dispose();

    surnameFormFocusNode?.dispose();
    surnameFormTextController?.dispose();

    emailFormFocusNode?.dispose();
    emailFormTextController?.dispose();

    phoneFormFocusNode?.dispose();
    phoneFormTextController?.dispose();
  }
}
