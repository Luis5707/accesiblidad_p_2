import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/pages/reserva_pop_up/reserva_pop_up_widget.dart';
import 'home_page_bien_widget.dart' show HomePageBienWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class HomePageBienModel extends FlutterFlowModel<HomePageBienWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Name-Form widget.
  FocusNode? nameFormFocusNode;
  TextEditingController? nameFormTextController;
  String? Function(BuildContext, String?)? nameFormTextControllerValidator;
  // State field(s) for Surname-form widget.
  FocusNode? surnameFormFocusNode;
  TextEditingController? surnameFormTextController;
  String? Function(BuildContext, String?)? surnameFormTextControllerValidator;
  // State field(s) for Email-Form widget.
  FocusNode? emailFormFocusNode;
  TextEditingController? emailFormTextController;
  String? Function(BuildContext, String?)? emailFormTextControllerValidator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController4;
  final textFieldMask = MaskTextInputFormatter(mask: '### ## ## ##');
  String? Function(BuildContext, String?)? textController4Validator;
  // State field(s) for Sala widget.
  String? salaValue;
  FormFieldController<String>? salaValueController;
  DateTime? datePicked;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nameFormFocusNode?.dispose();
    nameFormTextController?.dispose();

    surnameFormFocusNode?.dispose();
    surnameFormTextController?.dispose();

    emailFormFocusNode?.dispose();
    emailFormTextController?.dispose();

    textFieldFocusNode?.dispose();
    textController4?.dispose();
  }
}
