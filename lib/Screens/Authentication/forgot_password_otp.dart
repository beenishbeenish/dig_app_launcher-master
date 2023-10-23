import 'dart:async';

import 'package:dig_app_launcher/Utils/api_services.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/loader.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgotPasswordOTPScreen extends StatefulWidget {

  String email;
  ForgotPasswordOTPScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<ForgotPasswordOTPScreen> createState() => _ForgotPasswordOTPScreenState();
}

class _ForgotPasswordOTPScreenState extends State<ForgotPasswordOTPScreen> {

  bool isLoading = false;

  TextEditingController passwordController = TextEditingController();
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
    passwordController.dispose();
    _timer.cancel();
    super.dispose();
  }

  final storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      )
  );

  Future<void> _storeCredentials(String email, String password) async {
    await storage.write(key: 'email', value: email);
    await storage.write(key: 'password', value: password);
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
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.08, right: MediaQuery.of(context).size.width * 0.08,
                        top: MediaQuery.of(context).size.height * 0.03
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Se ha enviado una OTP a su correo electrónico.\nIngrese OTP a continuación',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
                          child: Form(
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
                        ),
                        hasError ?Text(
                          hasError ? "*Por favor llene todas las celdas correctamente" : "",
                          style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w400),
                        ) : const SizedBox(),
                        timerValue>=1 ?
                        Text(
                          'Tiempo restante: ${getTimerText()}',
                          // timerValue>=10 ? "Tiempo restante: 00:${timerValue.ceil()}" : "Tiempo restante: 00:0${timerValue.ceil()}",
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
                        const Center(
                          child: Text(
                            'Establecer nueva contraseña',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                            value != null && value.length < 8
                                ? 'Ingrese un mínimo de 8 caracteres'
                                : null,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.vpn_key, color: Colors.grey),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: 'Escriba su nueva contraseña aquí',
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Center(
                    child: MyButton(
                      name: "Enviar",
                      whenPress: () {
                        formKey.currentState!.validate();
                        // conditions for validating
                        if (currentText.length != 4) {
                          errorController!.add(ErrorAnimationType.shake); // Triggering error shake animation
                          setState(() => hasError = true);
                        } else {
                          setState(() {
                            hasError = false;
                            isLoading = true;
                            requestVerifyOTP(widget.email, int.parse(currentText)).then((value) {
                              if(formKey.currentState!.validate() && value != null && value.status == true) {
                                requestSetNewPass(widget.email, passwordController.text).then((value) {
                                  _storeCredentials(widget.email, passwordController.text);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  otpController.clear();
                                });
                              }
                              else {
                                setState(() => hasError = true);
                              }
                            }).whenComplete(() {
                              setState(() {
                                isLoading = false; // Set the isLoading variable to false to hide the loader
                              });
                            });
                          });
                        }
                      },
                    ),
                  ),
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