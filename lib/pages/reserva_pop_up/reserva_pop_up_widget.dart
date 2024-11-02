import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'reserva_pop_up_model.dart';
export 'reserva_pop_up_model.dart';

class ReservaPopUpWidget extends StatefulWidget {
  /// Pop up para aceptar finalmente la reserva. Esto aporta retroalimencación
  /// al usuario.
  const ReservaPopUpWidget({super.key});

  @override
  State<ReservaPopUpWidget> createState() => _ReservaPopUpWidgetState();
}

class _ReservaPopUpWidgetState extends State<ReservaPopUpWidget> {
  late ReservaPopUpModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReservaPopUpModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Container(
      width: 667.0,
      height: 357.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 563.0,
              height: 61.0,
              decoration: BoxDecoration(
                color: Color(0xFF869AEF),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Text(
                  'Reserva finalizada',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        fontSize: 25.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            Icon(
              Icons.check_circle_outline_sharp,
              color: Color(0xFF0A5F0A),
              size: 60.0,
            ),
            Text(
              '¡Su reserva se ha realizado con éxito! ¡No olvide anotar la fecha!',
              textAlign: TextAlign.justify,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    fontSize: 20.0,
                    letterSpacing: 0.0,
                  ),
            ),
            Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Text(
                dateTimeFormat("d/M/y", FFAppState().selectedDate),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      fontSize: 30.0,
                      letterSpacing: 0.0,
                    ),
              ),
            ),
            FFButtonWidget(
              onPressed: () async {
                Navigator.pop(context);
                await launchURL('https://www.uc3m.es/inicio');
              },
              text: 'Aceptar',
              options: FFButtonOptions(
                width: 200.0,
                height: 40.0,
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Inter Tight',
                      color: Colors.white,
                      letterSpacing: 0.0,
                    ),
                elevation: 0.0,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ].divide(SizedBox(height: 12.0)),
        ),
      ),
    );
  }
}
