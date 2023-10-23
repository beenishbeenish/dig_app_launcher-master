import 'package:auto_size_text/auto_size_text.dart';
import 'package:dig_app_launcher/Helper/DBModels/letter_size_model.dart';
import 'package:dig_app_launcher/Screens/ElderlyHome/ElderlyHomeBloc/elderly_home_bloc.dart';
import 'package:dig_app_launcher/Widgets/appbar.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRReaderScreen extends StatefulWidget {
  const QRReaderScreen({Key? key}) : super(key: key);

  @override
  State<QRReaderScreen> createState() => _QRReaderScreenState();
}

class _QRReaderScreenState extends State<QRReaderScreen> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String qrText = '';

  int titleFont = 22;
  int textFont = 16;

  late ElderlyHomeBloc _elderlyHomeBloc;
  RequestLetterSizeDetail? requestLetterSizeDetail;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData.code!;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _elderlyHomeBloc = BlocProvider.of<ElderlyHomeBloc>(context);
    _elderlyHomeBloc.add(GetLetterSizeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ElderlyHomeBloc, ElderlyHomeState>(
      listener: (context, state) {
        if (state is LoadingState) {}
        else if (state is ErrorState) {
          Fluttertoast.showToast(
            msg: state.error,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey.shade400,
            textColor: Colors.white,
            fontSize: 12.0
          );
        }
        else if (state is RefreshScreenState) {}
        else if (state is GetLetterSizeState) {
          requestLetterSizeDetail = state.letterSizeDetail;

          if (requestLetterSizeDetail != null && requestLetterSizeDetail!.letterSizeDetailList != null && requestLetterSizeDetail!.letterSizeDetailList!.isNotEmpty) {
            titleFont = requestLetterSizeDetail!.letterSizeDetailList!.first.titleSize;
            textFont = requestLetterSizeDetail!.letterSizeDetailList!.first.textSize;
          }
          else {
            titleFont = 22;
            textFont = 16;
          }
        }
      }, builder: (context, state) {
      return Scaffold(
        appBar: Appbar(onSOSPress: true, onInicioPress: true),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: MyButton(
          name: "Volver",
          whenPress: (){
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
        body: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.1, right: MediaQuery.of(context).size.width * 0.1,
            top: MediaQuery.of(context).size.height * 0.02
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AutoSizeText(
                'Leer prospecto',
                style: TextStyle(fontSize: titleFont.toDouble(), fontWeight: FontWeight.bold, color: Colors.black),
                maxLines: 1,
              ),
              Divider(
                height: 1,
                thickness: 1.5,
                color: const Color(0xffD0D0D0),
                endIndent: MediaQuery.of(context).size.width * 0.075,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.075),
              Expanded(
                flex: 3,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Expanded(
                flex: 2,
                child: Text(
                  qrText,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            ],
          ),
        ),
      );
    });
  }
}