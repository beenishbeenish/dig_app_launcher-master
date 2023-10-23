import 'dart:async';

import 'package:dig_app_launcher/Popup/alert_dialog_popup.dart';
import 'package:dig_app_launcher/Popup/alert_popup.dart';
import 'package:dig_app_launcher/Popup/email_sent_acknowledge_popup.dart';
import 'package:dig_app_launcher/Screens/Authentication/login.dart';
import 'package:dig_app_launcher/Screens/InitialConfigration/add_initial_favorite.dart';
import 'package:dig_app_launcher/Utils/api_services.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:dig_app_launcher/Widgets/help_button.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/loader.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPVerification extends StatefulWidget {

  String name, email, password;
  OTPVerification({Key? key, required this.name, required this.email, required this.password}) : super(key: key);

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {

  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    )
  );

  bool isLoading = false;
  TextEditingController otpController = TextEditingController();

  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  late Timer _timer;
  double timerValue = 300;

  String getTimerText() {
    int minutes = (timerValue / 60).floor();
    int seconds = timerValue.toInt() % 60;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }

  Future<void> _storeCredentials(String name, String email, String password, String id,  String accessToken, String userRole) async {
    await storage.write(key: 'name', value: name);
    await storage.write(key: 'email', value: email);
    await storage.write(key: 'password', value: password);
    await storage.write(key: 'id', value: id);
    await storage.write(key: 'access_token', value: accessToken);
    await storage.write(key: 'user_role', value: userRole);
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (timerValue == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            timerValue--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();

    startTimer();
    getTimerText();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: Scaffold(
        appBar: const AppbarLogo(),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageContainer(imageHeight: MediaQuery.of(context).size.height * 0.2),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.075),
                  const Text(
                    'Introduzca el código',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const Text(
                    'de verificación',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.075),
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: PinCodeTextField(
                        appContext: context,
                        pastedTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
                        length: 4,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(3),
                          fieldHeight: 55,
                          fieldWidth: 50,
                          activeFillColor: const Color(0xffF4F4F4),
                          activeColor: const Color(0xffF4F4F4),
                          inactiveFillColor: const Color(0xffF4F4F4),
                          inactiveColor: const Color(0xffF4F4F4),
                          selectedFillColor: const Color(0xffF4F4F4),
                          selectedColor: const Color(0xffF4F4F4),
                        ),
                        cursorColor: Colors.black,
                        textStyle: const TextStyle(color: Colors.black),
                        animationDuration: const Duration(milliseconds: 0),
                        enableActiveFill: true,
                        errorAnimationController: errorController,
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.none,
                        boxShadows: const [
                          BoxShadow(
                            offset: Offset(0, 1),
                            color: Colors.black12,
                            blurRadius: 10,
                          )
                        ],
                        onCompleted: (v) {
                          debugPrint("Completed");
                        },
                        onChanged: (value) {
                          debugPrint(value);
                          setState(() {
                            currentText = value;
                          });
                        },
                        beforeTextPaste: (text) {
                          debugPrint("Allowing to paste $text");
                          return true;
                        },
                      )
                    ),
                  ),
                  hasError ?Text(
                    hasError ? "*Por favor llene todas las celdas correctamente" : "",
                    style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w400),
                  ) : const SizedBox(),
                  timerValue>=1 ?
                  Text(
                      'Tiempo restante: ${getTimerText()}',
                    style: const TextStyle(fontSize: 16, color: Color(0xff262626)),
                    textAlign: TextAlign.center,
                  ) :
                  const Text(
                    '¿No ha recibido el código?',
                    style: TextStyle(fontSize: 16, color: Color(0xff262626)),
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: timerValue>=1? (){} : () {
                      requestVerifyOTP(widget.email, int.parse(currentText)).then((value) {
                        startTimer();
                      });
                    },
                    child: Text(
                      'Reenviar código',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: timerValue>=1? Colors.grey: Colors.black, decoration: TextDecoration.underline),
                    ),
                  ),
                  MyButton(
                    name: "Enviar código",
                    whenPress: () async {
                      formKey.currentState!.validate();
                      // conditions for validating
                      if (currentText.length != 4) {
                        errorController!.add(ErrorAnimationType.shake); // Triggering error shake animation
                        setState(() => hasError = true);
                      } else {
                        setState(() {
                          hasError = false;
                          isLoading = true; // Hide loader
                          requestVerifyOTP(widget.email, int.parse(currentText)).then((value) {
                            if(value != null && value.status == true) {
                              _storeCredentials(widget.name, widget.email, widget.password, value.id, value.accessToken, value.data.userRole);
                              if(value.data.userRole == 'elderly'){
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const InitialFavouriteScreen()
                                  ), (Route<dynamic> route) => false
                                );
                              }
                              else if(value.data.userRole == 'administrator'){
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(isSupervisor: false)
                                  ), (Route<dynamic> route) => false
                                );
                              }
                              else if(value.data.userRole == 'supervisor'){
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(isSupervisor: true)
                                  ), (Route<dynamic> route) => false
                                );
                              }
                              else{
                                showDialog(
                                  context: context,
                                  builder: (_) => Dialog(
                                    insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
                                    child: SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.5,
                                      child: AlertDialogPopup(
                                        text: "Ocurrió un error. Intentar otra vez",
                                        isVisible: true,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              otpController.clear();
                            }
                            else {
                              showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                  insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    child: AlertPopup(
                                      title: "Código\nde verificación",
                                      text: "El código introducido no es correcto\n\nVuelva a internarlo\n",
                                      isVisible: false,
                                    ),
                                  ),
                                )
                              );
                              setState(() => hasError = true);
                            }
                          }).whenComplete(() {
                            setState(() {
                              isLoading = false; // Set the isLoading variable to false to hide the loader
                            });
                          });
                        },
                        );
                      }
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Padding(
                    padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.1),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: HelpButton(widget: EmailSentAcknowledgementPopup(name: widget.name, email: widget.email, password: widget.password)),
                    ),
                  )
                ],
              ),
            ),
            if (isLoading)
              const Loader(),
          ]
        ),
      ),
    );
  }
}