import 'package:auto_size_text/auto_size_text.dart';
import 'package:dig_app_launcher/Helper/DBModels/leisure_model.dart';
import 'package:dig_app_launcher/Helper/DBModels/letter_size_model.dart';
import 'package:dig_app_launcher/Screens/Configuration/Leisure/LeisureBloc/leisure_bloc.dart';
import 'package:dig_app_launcher/Widgets/appbar.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:installed_apps/installed_apps.dart';

class ShowLeisureScreen extends StatefulWidget {
  const ShowLeisureScreen({Key? key}) : super(key: key);

  @override
  State<ShowLeisureScreen> createState() => _ShowLeisureScreenState();
}

class _ShowLeisureScreenState extends State<ShowLeisureScreen> {

  int titleFont = 22;
  int textFont = 16;

  late LeisureBloc _leisureBloc;
  RequestAppData? requestAppData;
  RequestLetterSizeDetail? requestLetterSizeDetail;

  @override
  void initState() {
    _leisureBloc = BlocProvider.of<LeisureBloc>(context);
    _leisureBloc.add(GetAllAppEvent());
    _leisureBloc.add(GetLetterSizeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LeisureBloc, LeisureState>(
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
        else if (state is GetAllAppState) {
          requestAppData = state.appDetail;
          if (requestAppData != null && requestAppData!.appList != null) {
            requestAppData!.appList!.sort((a, b) => a.appName.compareTo(b.appName));
          }
        }
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
            top: MediaQuery.of(context).size.height * 0.02
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1, right: MediaQuery.of(context).size.width * 0.01,
                ),
                child: Column(
                  children: [
                    AutoSizeText(
                      'Ocio',
                      style: TextStyle(fontSize: titleFont.toDouble(), fontWeight: FontWeight.bold, color: Colors.black),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 1.5,
                color: const Color(0xffD0D0D0),
                indent: MediaQuery.of(context).size.width * 0.1,
                endIndent: MediaQuery.of(context).size.width * 0.1,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              requestAppData != null && requestAppData!.appList!.isNotEmpty ?
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          childAspectRatio: 1.5
                        ),
                        itemCount: requestAppData != null? requestAppData!.appList!.length : 0,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  final String packageName = requestAppData!.appList![index].appUrl;
                                  InstalledApps.startApp(packageName);
                                },
                                child: Column(
                                  children: [
                                    Image.memory(
                                      requestAppData!.appList![index].appImage,
                                      width: 48,
                                      height: 48,
                                    ),
                                    Text(
                                      requestAppData!.appList![index].appName,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 12, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ) :
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Center(
                  child: Text(
                    "No ocio guardados todavía",
                    style: TextStyle(fontSize: textFont.toDouble(), fontWeight: FontWeight.bold, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Center(
                child: MyButton(
                  name: "Cancelar",
                  whenPress: (){
                    Navigator.pop(context);
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