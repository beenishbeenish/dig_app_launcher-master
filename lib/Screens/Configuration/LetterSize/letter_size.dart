import 'package:dig_app_launcher/Helper/DBModels/letter_size_model.dart';
import 'package:dig_app_launcher/Popup/alert_dialog_popup.dart';
import 'package:dig_app_launcher/Screens/Configuration/LetterSize/LetterSizeBloc/letter_size_bloc.dart';
import 'package:dig_app_launcher/Utils/api_services.dart';
import 'package:dig_app_launcher/Utils/app_global.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/loader.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:input_slider/input_slider.dart';

class LetterSizeScreen extends StatefulWidget {

  String? elderlyId;
  int? titleSize, textSize;
  LetterSizeScreen({Key? key, this.elderlyId, this.titleSize, this.textSize}) : super(key: key);

  @override
  State<LetterSizeScreen> createState() => _LetterSizeScreenState();
}

class _LetterSizeScreenState extends State<LetterSizeScreen> {

  int? titleFont;
  int? textFont;
  bool saveVisible = false;
  bool isLoading = true;
  bool isGetData = true;
  String storedId = '';

  late LetterSizeBloc _letterSizeBloc;
  RequestLetterSizeDetail? requestLetterSizeDetail;
  late AppGlobal appGlobal;

  Future<void> retrieveStoredId() async {
    String id = await appGlobal.retrieveId();
    setState(() {
      storedId = id;
    });
  }

  void _checkUserRole() async {
    String? userRole = await appGlobal.getUserRole();

    if(userRole == 'elderly') {
      if (requestLetterSizeDetail != null && requestLetterSizeDetail!.letterSizeDetailList != null && requestLetterSizeDetail!.letterSizeDetailList!.isNotEmpty) {
        titleFont = requestLetterSizeDetail!.letterSizeDetailList!.first.titleSize;
        textFont = requestLetterSizeDetail!.letterSizeDetailList!.first.textSize;

        setState(() {
          isLoading = false;
          isGetData = false;
        });
      }
      else {
        titleFont = 22;
        textFont = 16;

        setState(() {
          isLoading = false;
          isGetData = false;
        });
      }
    }
    else if (userRole == 'administrator' && widget.elderlyId != null) {
      titleFont = widget.titleSize;
      textFont = widget.textSize;
      setState(() {
        isLoading = false;
        isGetData = false;
      });
    }
  }

  @override
  void initState() {
    appGlobal = AppGlobal();
    _letterSizeBloc = BlocProvider.of<LetterSizeBloc>(context);
    _letterSizeBloc.add(GetLetterSizeEvent());
    retrieveStoredId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LetterSizeBloc, LetterSizeState>(
      listener: (context, state) async {
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
        else if (state is DataStoredState) {
          saveVisible = true;
        }
        else if (state is GetLetterSizeState) {
          requestLetterSizeDetail = state.letterSizeDetail;
          _checkUserRole();
        }
      }, builder: (context, state) {
      return Scaffold(
        appBar: const AppbarLogo(),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageContainer(imageHeight: MediaQuery.of(context).size.height * 0.1),
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.09, right: MediaQuery.of(context).size.width * 0.08,
                    top: MediaQuery.of(context).size.height * 0.05, bottom: MediaQuery.of(context).size.height * 0.05
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Inicio > Letra',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1.5,
                        color: const Color(0xffD0D0D0),
                        endIndent: MediaQuery.of(context).size.width * 0.2,
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: !isGetData && titleFont != null,
                  child: Padding(
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.25),
                    child: const Text(
                      'Este es el título',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
                Visibility(
                  visible: !isGetData && titleFont != null,
                  child: Transform(
                    transform: Matrix4.translationValues(-40, -10, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: InputSlider(
                            onChange: (value) {
                              setState(() {
                                titleFont = value.toInt();
                              });
                            },
                            min: 12,
                            max: 40,
                            decimalPlaces: 0,
                            defaultValue: titleFont != null? titleFont!.toDouble() : 22,
                          ),
                        ),
                        Text(
                          titleFont != null? '${titleFont}px' : '22px',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: !isGetData && textFont != null,
                  child: Padding(
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.25),
                    child: const Text(
                      'Este es el texto',
                      style: TextStyle(fontSize: 19, color: Colors.black),
                    ),
                  ),
                ),
                Visibility(
                  visible: !isGetData && textFont != null,
                  child: Transform(
                    transform: Matrix4.translationValues(-40, -10, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: InputSlider(
                            onChange: (value) {
                              setState(() {
                                textFont = value.toInt();
                              });
                            },
                            min: 12,
                            max: 24,
                            decimalPlaces: 0,
                            defaultValue: textFont != null? textFont!.toDouble() : 16
                          ),
                        ),
                        Text(
                          textFont != null? '${textFont}px' : '16px',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: saveVisible,
                  child: Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.035,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff6ECB42),
                          shape: RoundedRectangleBorder( //to set border radius to button
                              borderRadius: BorderRadius.circular(8)
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Cambios Guardados',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                saveVisible? SizedBox(height: MediaQuery.of(context).size.height * 0.025): SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                Visibility(
                  visible: !isGetData,
                  child: Center(
                    child: MyButton(
                      name: "Cambiar",
                      whenPress: () async {
                        setState(() {
                          isLoading = true;
                        });

                        String? userRole = await appGlobal.getUserRole();

                        if(userRole == 'elderly'){
                          requestLetterSize(titleFont!, textFont!, storedId).then((value) {
                            if(value != null && value.status == true){
                              _letterSizeBloc.add(SaveLetterSizeEvent(titleFont ?? 22, textFont ?? 16));
                            }
                            else{
                              showDialog(
                                  context: context,
                                  builder: (_) => Dialog(
                                    insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
                                    child: SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.5,
                                      child: AlertDialogPopup(
                                        text: "El tamaño de letra no se guarda. Comprueba tu conexión a Internet e inténtalo de nuevo.",
                                        isVisible: true,
                                      ),
                                    ),
                                  )
                              );
                            }
                          }).whenComplete(() {
                            setState(() {
                              isLoading = false;
                            });
                          });
                        }
                        else if(userRole == 'administrator') {
                          requestLetterSize(titleFont!, textFont!, widget.elderlyId!).then((value) {
                            if(value != null && value.status == true){
                              setState(() {
                                saveVisible = true;
                              });
                            }
                            else{
                              showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                  insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    child: AlertDialogPopup(
                                      text: "El tamaño de letra no se guarda. Comprueba tu conexión a Internet e inténtalo de nuevo.",
                                      isVisible: true,
                                    ),
                                  ),
                                )
                              );
                            }
                          }).whenComplete(() {
                            setState(() {
                              isLoading = false;
                            });
                          });
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Visibility(
                  visible: !isGetData,
                  child: Center(
                    child: MyButton(
                      name: "Volver",
                      whenPress: (){
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
            if (isLoading)
              const Loader(),
          ]
        ),
      );
    });
  }
}