import 'package:auto_size_text/auto_size_text.dart';
import 'package:dig_app_launcher/Helper/DBModels/letter_size_model.dart';
import 'package:dig_app_launcher/Screens/ElderlyHome/ElderlyHomeBloc/elderly_home_bloc.dart';
import 'package:dig_app_launcher/Screens/ElderlyHome/QR/qr_reader.dart';
import 'package:dig_app_launcher/Widgets/appbar.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({Key? key}) : super(key: key);

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {

  int titleFont = 22;
  int textFont = 16;

  late ElderlyHomeBloc _elderlyHomeBloc;
  RequestLetterSizeDetail? requestLetterSizeDetail;

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
        body: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.1, right: MediaQuery.of(context).size.width * 0.1,
            top: MediaQuery.of(context).size.height * 0.02
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.08, right: MediaQuery.of(context).size.width * 0.08,
                  top: MediaQuery.of(context).size.height * 0.04, bottom: MediaQuery.of(context).size.height * 0.03
                ),
                child: AutoSizeText(
                  'Instrucciones:',
                  style: TextStyle(fontSize: titleFont.toDouble(), fontWeight: FontWeight.bold, color: Colors.black),
                  maxLines: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.03, right: MediaQuery.of(context).size.width * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      'Busque el código QR, es parecido a esta imagen:',
                      style: TextStyle(fontSize: textFont.toDouble(), fontWeight: FontWeight.bold, color: Colors.black),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                    Icon(Icons.qr_code_outlined, color: Colors.black, size: MediaQuery.of(context).size.height * 0.1),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                    AutoSizeText(
                      'Pulse el botón naranja “Leer”',
                      style: TextStyle(fontSize: textFont.toDouble(), fontWeight: FontWeight.bold, color: Colors.black),
                      maxLines: 1,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                    AutoSizeText(
                      'Sitúe la cámara en el centro del código y se leerá su prospecto',
                      style: TextStyle(fontSize: textFont.toDouble(), fontWeight: FontWeight.bold, color: Colors.black),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Center(
                child: MyButton(
                  name: "Leer",
                  whenPress: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => QRReaderScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}