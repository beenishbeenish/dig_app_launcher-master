import 'package:dig_app_launcher/Helper/DBModels/sound_model.dart';
import 'package:dig_app_launcher/Popup/alert_dialog_popup.dart';
import 'package:dig_app_launcher/Screens/Configuration/Sound/set_ringtone.dart';
import 'package:dig_app_launcher/Utils/api_services.dart';
import 'package:dig_app_launcher/Utils/app_global.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/loader.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:volume_controller/volume_controller.dart';

import 'SoundBloc/sound_bloc.dart';

class SetVolumeScreen extends StatefulWidget {

  String? elderlyId;
  int? volume;
  bool? isBluetooth;
  SetVolumeScreen({Key? key, this.elderlyId, this.isBluetooth, this.volume}) : super(key: key);

  @override
  State<SetVolumeScreen> createState() => _SetVolumeScreenState();
}

class _SetVolumeScreenState extends State<SetVolumeScreen> {

  bool saveVisible = false;
  bool isLoading = true;
  bool isGetData = true;
  double _volumeListenerValue = 0;
  double _getVolume = 0;
  // double _setVolumeValue = 0;

  double? currentVolume;
  String storedId = '';

  late SoundBloc _soundBloc;
  RequestSoundDetail? requestSoundDetail;
  late AppGlobal appGlobal;

  Future<void> getVolume() async {
    _getVolume = await VolumeController().getVolume();
    print("Get Vol Function: $_getVolume");
    setState(() {
      isLoading = false;
      isGetData = false;
    });
  }

  Future<void> retrieveStoredId() async {
    String id = await appGlobal.retrieveId();
    setState(() {
      storedId = id;
    });
  }

  void _checkUserRole() async {
    String? userRole = await appGlobal.getUserRole();

    if(userRole == 'elderly') {
      if (requestSoundDetail != null && requestSoundDetail!.soundDetailList != null && requestSoundDetail!.soundDetailList!.isNotEmpty) {
        currentVolume = requestSoundDetail!.soundDetailList!.first.volume.toDouble();

        setState(() {
          isLoading = false;
          isGetData = false;
        });
      }
      else {
        // VolumeController().listener((volume) {
        //   setState(() {
        //     print("Volume Listener: $volume");
        //     _volumeListenerValue = volume;
        //   });
        // });
        VolumeController().getVolume().then((volume) {
          setState(() {
            currentVolume = volume;
          });
        });
        // getVolume();
        setState(() {
          isLoading = false;
          isGetData = false;
        });
      }
    }
    else if (userRole == 'administrator' && widget.elderlyId != null) {
      currentVolume = widget.volume!.toDouble();
      setState(() {
        isLoading = true;
        isGetData = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    appGlobal = AppGlobal();
    _soundBloc = BlocProvider.of<SoundBloc>(context);
    _soundBloc.add(GetSoundEvent());
    retrieveStoredId();
    // _checkUserRole();
  }

  @override
  void dispose() {
    VolumeController().removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SoundBloc, SoundState>(
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
        else if (state is GetSoundState) {
          requestSoundDetail = state.soundDetail;
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
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1, vertical: MediaQuery.of(context).size.height * 0.05
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Inicio > Sonido',
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.09),
                  child: Visibility(
                    visible: !isGetData && currentVolume != null,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Visibility(
                            visible: saveVisible,
                            child: const Text(
                              'Cambios guardados',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff408022)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
                          child: const Text(
                            'Modificar volumen',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
                          child: Row(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.05,
                                child: Image.asset('assets/images/volume_speaker.png')
                              ),
                              Transform(
                                transform: Matrix4.translationValues(-15, 0, 0.0),
                                child: Slider(
                                  min: 0,
                                  max: 1,
                                  onChanged: (double value) {
                                    setState(() {
                                      currentVolume = value;
                                    });
                                  },
                                  value: currentVolume != null? currentVolume!.toDouble() : 0,
                                ),
                              ),
                              Text(
                                currentVolume != null? '${(currentVolume! * 10).toInt()}' : '',
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        Center(
                          child: MyButton(
                            name: "Modificar",
                            whenPress: () async {
                              setState(() {
                                isLoading = true;
                              });

                              String? userRole = await appGlobal.getUserRole();

                              if(userRole == 'elderly'){
                                requestSound((currentVolume!.toInt() * 10), false, storedId).then((value) {
                                  if(value != null && value.status == true){
                                    _soundBloc.add(SaveVolumeEvent(currentVolume!.toInt()));
                                    setState(() {
                                      VolumeController().setVolume(currentVolume!);
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
                                              text: "El volumen no se guarda. Comprueba tu conexión a Internet e inténtalo de nuevo.",
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
                                requestSound(currentVolume!.toInt(), widget.isBluetooth, widget.elderlyId!).then((value) {
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
                                            text: "El volumen no se guarda. Comprueba tu conexión a Internet e inténtalo de nuevo.",
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
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.025, bottom: MediaQuery.of(context).size.height * 0.04),
                          child: Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(10),
                                backgroundColor: const Color(0xffF5F5F5),
                                shape: RoundedRectangleBorder( //to set border radius to button
                                    borderRadius: BorderRadius.circular(8)
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => const SetRingtoneScreen(),
                                  ),
                                ).then((value) {
                                  VolumeController().listener((volume) {
                                    setState(() {
                                      _volumeListenerValue = volume;
                                    });
                                  });
                                  VolumeController().getVolume().then((volume) => currentVolume = volume);
                                  getVolume();
                                });
                              },
                              child: const Text(
                                'Hacer sonar',
                                style: TextStyle(fontSize: 17, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: MyButton(
                            name: "Volver",
                            whenPress: (){
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
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