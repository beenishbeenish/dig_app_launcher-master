import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dig_app_launcher/Helper/DBModels/contacts_model.dart';
import 'package:dig_app_launcher/Helper/DBModels/letter_size_model.dart';
import 'package:dig_app_launcher/Screens/ElderlyHome/ElderlyHomeBloc/elderly_home_bloc.dart';
import 'package:dig_app_launcher/Utils/app_images.dart';
import 'package:dig_app_launcher/Widgets/appbar.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class FavouriteDetail extends StatefulWidget {

  int index;
  String name, phoneNumber;
  Uint8List? image;
  FavouriteDetail({Key? key, required this.index, required this.name, required this.phoneNumber, this.image}) : super(key: key);

  @override
  State<FavouriteDetail> createState() => _FavouriteDetailState();
}

class _FavouriteDetailState extends State<FavouriteDetail> {

  int titleFont = 22;
  int textFont = 16;

  late ElderlyHomeBloc _elderlyHomeBloc;
  RequestLetterSizeDetail? requestLetterSizeDetail;
  RequestContactsDetail? requestContactsDetail;

  void openWhatsAppChat() async {
    String phoneNumber = widget.phoneNumber;

    String url = "whatsapp://send?phone=$phoneNumber";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      // throw 'Could not launch $url';
      Fluttertoast.showToast(msg: 'WhatsApp no está instalado.');
    }
  }

  _callNumber() async{
    String number = widget.phoneNumber;
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  void videoCall() async {
    String phoneNumber = widget.phoneNumber;

    String url = "https://wa.me/$phoneNumber/?action=video_call";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    _elderlyHomeBloc = BlocProvider.of<ElderlyHomeBloc>(context);
    _elderlyHomeBloc.add(GetLetterSizeEvent());
    _elderlyHomeBloc.add(GetAllContactsEvent());
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
          else if (state is GetAllContactsDetailState) {
            requestContactsDetail = state.contactsDetail;
          }
        }, builder: (context, state) {
      return Scaffold(
        appBar: Appbar(onSOSPress: true, onInicioPress: true),
        body: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.1, right: MediaQuery.of(context).size.width * 0.1,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                'Tus favoritos',
                style: TextStyle(fontSize: titleFont.toDouble(), fontWeight: FontWeight.bold, color: Colors.black),
                maxLines: 1,
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.01, bottom: MediaQuery.of(context).size.height * 0.02
                ),
                child: const Divider(
                  height: 1,
                  thickness: 1.5,
                  color: Color(0xffD0D0D0),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.image != null?
                    Image.memory(
                      widget.image!,
                      height: MediaQuery.of(context).size.height * 0.125,
                    ) :
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.12,
                      width: MediaQuery.of(context).size.width * 0.18,
                      child: const Icon(Icons.person, color: Colors.black, size: 50),
                    ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          widget.name,
                          style: TextStyle(fontSize: titleFont.toDouble(), fontWeight: FontWeight.bold, color: Colors.black),
                          maxLines: 1,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.045),
                        AutoSizeText(
                          widget.phoneNumber,
                          style: TextStyle(fontSize: textFont.toDouble(), fontWeight: FontWeight.bold, color: Colors.black),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: requestContactsDetail?.contactsDetailList![widget.index].whatsapp == '1'? () {
                        openWhatsAppChat();
                      } :(){},
                      child: Column(
                        children: [
                          AutoSizeText(
                            'Whatsapp',
                            style: TextStyle(fontSize: textFont.toDouble(), fontWeight: FontWeight.bold, color: Colors.black),
                            maxLines: 1,
                          ),
                          const SizedBox(height: 5),
                          SvgPicture.asset(
                            AppImages.whatsapp,
                            width: MediaQuery.of(context).size.width *0.175,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.13,
                      width: 1.5,
                      color: const Color(0xffD0D0D0),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: requestContactsDetail?.contactsDetailList![widget.index].voiceCall == '1'? (){
                        _callNumber();
                      } : (){},
                      child: Column(
                        children: [
                          AutoSizeText(
                            'Llamar',
                            style: TextStyle(fontSize: textFont.toDouble(), fontWeight: FontWeight.bold, color: Colors.black),
                            maxLines: 1,
                          ),
                          const SizedBox(height: 5),
                          SvgPicture.asset(
                            AppImages.telephone,
                            width: MediaQuery.of(context).size.width *0.165,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.13,
                      width: 1.5,
                      color: const Color(0xffD0D0D0),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: requestContactsDetail?.contactsDetailList![widget.index].videoCall == '1'? (){
                        openWhatsAppChat();
                        // videoCall();
                      } : (){},
                      child: Column(
                        children: [
                          AutoSizeText(
                            'Vídeo',
                            style: TextStyle(fontSize: textFont.toDouble(), fontWeight: FontWeight.bold, color: Colors.black),
                            maxLines: 1,
                          ),
                          const SizedBox(height: 5),
                          Image.asset(
                            "assets/images/play.png",
                            width: MediaQuery.of(context).size.width *0.175,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.03, bottom: MediaQuery.of(context).size.height * 0.03
                ),
                child: const Divider(
                  height: 1,
                  thickness: 1.5,
                  color: Color(0xffD0D0D0),
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
      );
    });
  }
}