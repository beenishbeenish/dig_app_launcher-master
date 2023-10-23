import 'package:alarm/alarm.dart';
import 'package:dig_app_launcher/Screens/Configuration/AddEmergencyContact/EmergencyContactsBloc/emergency_contacts_bloc.dart';
import 'package:dig_app_launcher/Screens/Configuration/AddFavourite/ContactsBloc/contacts_bloc.dart';
import 'package:dig_app_launcher/Screens/Configuration/AddMedicine/MedicineBloc/medicine_bloc.dart';
import 'package:dig_app_launcher/Screens/Configuration/Leisure/LeisureBloc/leisure_bloc.dart';
import 'package:dig_app_launcher/Screens/Configuration/LetterSize/LetterSizeBloc/letter_size_bloc.dart';
import 'package:dig_app_launcher/Screens/Configuration/Sound/SoundBloc/sound_bloc.dart';
import 'package:dig_app_launcher/Screens/ElderlyHome/ElderlyHomeBloc/elderly_home_bloc.dart';
import 'package:dig_app_launcher/Screens/ElderlyHome/elderly_home.dart';
import 'package:dig_app_launcher/Screens/UserModeSelection/user_mode_selection.dart';
import 'package:dig_app_launcher/Screens/WelcomeScreen/welcome_screen.dart';
import 'package:dig_app_launcher/Utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'GetElderlyDataBloc/elderly_data_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Alarm.init(showDebugLogs: true);
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<bool> _checkFirstLaunch() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('firstLaunch') ?? true;
    return isFirstLaunch;
  }

  Future<bool> _checkIsLogin() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool('IsLogin') ?? false;
    return isLogin;
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiProvider(
        providers: [
          BlocProvider<ElderlyHomeBloc>(
            create: (context) => ElderlyHomeBloc(),
          ),
          BlocProvider<LetterSizeBloc>(
            create: (context) => LetterSizeBloc(),
          ),
          BlocProvider<ContactsBloc>(
            create: (context) => ContactsBloc(),
          ),
          BlocProvider<EmergencyContactsBloc>(
            create: (context) => EmergencyContactsBloc(),
          ),
          BlocProvider<SoundBloc>(
            create: (context) => SoundBloc(),
          ),
          BlocProvider<MedicineBloc>(
            create: (context) => MedicineBloc(),
          ),
          BlocProvider<LeisureBloc>(
            create: (context) => LeisureBloc(),
          ),
          BlocProvider<ElderlyDataBloc>(
            create: (context) => ElderlyDataBloc(),
          )
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'DIGABU',
          theme: ThemeData(
            primaryColor: kColorPrimary,
            scaffoldBackgroundColor: const Color(0xffFCFCFC),
            bottomAppBarTheme: const BottomAppBarTheme(color: Color(0xffFFFFFF)),
            appBarTheme: const AppBarTheme(
              elevation: 0.0,
              backgroundColor: kColorBG,
            ),
            colorScheme: const ColorScheme.dark(
              primary: Colors.black,
            ),
          ),
          home: FutureBuilder<bool>(
            future: _checkFirstLaunch(),
            builder: (BuildContext context, AsyncSnapshot<bool> isFirstLaunchSnapshot) {
              if (isFirstLaunchSnapshot.connectionState == ConnectionState.done) {
                if(isFirstLaunchSnapshot.data == true){
                  return const WelcomeScreen();
                }
                else{
                  return FutureBuilder<bool>(
                    future: _checkIsLogin(),
                    builder: (BuildContext context, AsyncSnapshot<bool> isLoginSnapshot) {
                      if (isLoginSnapshot.connectionState == ConnectionState.done) {
                        if (isLoginSnapshot.data == true) {
                          return ElderlyHomeScreen();
                        }
                        else {
                          return const UserModeSelectionScreen();
                        }
                      }
                      else {
                        return Container(color: Colors.white);
                      }
                    }
                  );
                }
              } else {
                  return Container(color: Colors.white);
              }
            },
          ),
        ),
      );
    });
  }
}