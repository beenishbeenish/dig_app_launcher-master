import 'dart:developer';
import 'dart:io';

import 'package:dig_app_launcher/APIModel/add_emergency_contact_request.dart';
import 'package:dig_app_launcher/APIModel/add_favorites_request.dart';
import 'package:dig_app_launcher/APIModel/delete_supervisor_request.dart';
import 'package:dig_app_launcher/APIModel/forgot_pass_request.dart';
import 'package:dig_app_launcher/APIModel/get_elderlies_request.dart';
import 'package:dig_app_launcher/APIModel/get_specific_elderly_request.dart';
import 'package:dig_app_launcher/APIModel/get_supervisors_request.dart';
import 'package:dig_app_launcher/APIModel/leisure_request.dart';
import 'package:dig_app_launcher/APIModel/letter_size_request.dart';
import 'package:dig_app_launcher/APIModel/login_request.dart';
import 'package:dig_app_launcher/APIModel/send_admin_invite_request.dart';
import 'package:dig_app_launcher/APIModel/send_installed_apps_request.dart';
import 'package:dig_app_launcher/APIModel/set_new_pass_request.dart';
import 'package:dig_app_launcher/APIModel/get_supervisor_elderly_request.dart';
import 'package:dig_app_launcher/APIModel/signup_request.dart';
import 'package:dig_app_launcher/APIModel/sound_request.dart';
import 'package:dig_app_launcher/APIModel/update_admin_account.dart';
import 'package:dig_app_launcher/APIModel/update_user_account.dart';
import 'package:dig_app_launcher/APIModel/upload_contact_response.dart';
import 'package:dig_app_launcher/APIModel/verify_otp_request.dart';
import 'package:dig_app_launcher/Utils/app_global.dart';
import 'package:dig_app_launcher/Utils/internet_checker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../body/add_favorite_body.dart';

AppGlobal appGlobal = AppGlobal();

//----------------- SignUp -----------------
Future<SignUpRequest?> requestSignUp(String name, String email, String password) async {

  SignUpRequest? result;
  bool isInternetAvailable = await CommonUtil().checkInternetConnection();

  if (isInternetAvailable){
    try{
      final url = Uri.parse('${AppGlobal.baseUrl}user');
      final response = await http.post(
        url,
        body: jsonEncode({'userFullName': name, 'userEmail': email, 'userPassword': password}),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        result = SignUpRequest.fromJson(responseData);
      } else {
        print('User registration failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
    }
    return result;
  } else {
    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertPopup(
    //         title: 'No internet',
    //         icon: true,
    //         content: 'Please Check your internet connection.',
    //       );
    //     });
    // return result;
  }
}

//----------------- Verify OTP -----------------
Future<VerifyOTPRequest?> requestVerifyOTP(String email, int otp) async {

  VerifyOTPRequest? result;
  bool isInternetAvailable = await CommonUtil().checkInternetConnection();

  if (isInternetAvailable){
    try{
      final url = Uri.parse('${AppGlobal.baseUrl}user/verify-otp');
      final response = await http.post(
        url,
        body: jsonEncode({'userEmail': email, "userOtp": otp}),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        result = VerifyOTPRequest.fromJson(responseData);
      } else {
        print('OTP verification failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
    }
    return result;
  } else {}
}

//----------------- Login -----------------
Future<LoginRequest?> requestLogin(String email, String password, bool isSupervisor) async {

  LoginRequest? result;
  bool isInternetAvailable = await CommonUtil().checkInternetConnection();

  if (isInternetAvailable){
    try{
      final url = Uri.parse('${AppGlobal.baseUrl}auth/login?isSupervisor=$isSupervisor');
      final response = await http.post(
        url,
        body: jsonEncode({'userEmail': email, 'userPassword': password}),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        result = LoginRequest.fromJson(responseData);
        await appGlobal.setTokenValue(result.data.accessToken);
      } else {
        print('Login failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
    }
    return result;
  } else {}
}

//----------------- Forgot Password -----------------
Future<ForgotPasswordRequest?> requestForgotPassOTP(String email) async {

  ForgotPasswordRequest? result;
  bool isInternetAvailable = await CommonUtil().checkInternetConnection();

  if (isInternetAvailable){
    try{
      final url = Uri.parse('${AppGlobal.baseUrl}user/send-otp');
      final response = await http.post(
        url,
        body: jsonEncode({'userEmail': email}),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        result = ForgotPasswordRequest.fromJson(responseData);
      } else {
        print('OTP request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
    }
    return result;
  } else {}
}

//----------------- Set New Password -----------------
Future<SetNewPassRequest?> requestSetNewPass(String email, String password) async {

  SetNewPassRequest? result;
  bool isInternetAvailable = await CommonUtil().checkInternetConnection();

  if (isInternetAvailable){
    try{
      final url = Uri.parse('${AppGlobal.baseUrl}user/set-password');
      final response = await http.post(
        url,
        body: jsonEncode({'userEmail': email, 'userPassword': password}),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        result = SetNewPassRequest.fromJson(responseData);
      } else {
        print('Reset password failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
    }
    return result;
  } else {}
}

//----------------- Update Elderly Account -----------------
Future<UpdateUserAccount?> requestUpdateUserAccount(String userName, String userEmail, String currentPassword, String newPassword) async {

  UpdateUserAccount? result;
  bool isInternetAvailable = await CommonUtil().checkInternetConnection();

  if (isInternetAvailable){
    try{
      final url = Uri.parse('${AppGlobal.baseUrl}elderlyAccountSetting');
      final accessToken = await AppGlobal().accessToken();
      final response = await http.put(
        url,
        body: jsonEncode({'elderlyName': userName, 'elderlyEmail': userEmail, 'elderlyCurrentPassword': currentPassword, 'elderlyNewPassword': newPassword}),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        result = UpdateUserAccount.fromJson(responseData);
      } else {
        print('Update elderly account failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
    }
    return result;
  } else {}
}

//----------------- Update Admin Account -----------------
Future<UpdateAdminAccount?> requestUpdateAdminAccount(String userEmail, String currentPassword, String newPassword) async {

  UpdateAdminAccount? result;
  bool isInternetAvailable = await CommonUtil().checkInternetConnection();

  if (isInternetAvailable){
    try{
      final url = Uri.parse('${AppGlobal.baseUrl}user');
      final accessToken = await AppGlobal().accessToken();
      final response = await http.put(
        url,
        body: jsonEncode({'userEmail': userEmail, 'userCurrentPassword': currentPassword, 'userNewPassword': newPassword}),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        result = UpdateAdminAccount.fromJson(responseData);
      } else {
        print('Update admin account failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
    }
    return result;
  } else {}
}

//----------------- Letter Size -----------------
Future<LetterSizeRequest?> requestLetterSize(int titleSize, int textSize, String elderlyId) async {

  LetterSizeRequest? result;
  bool isInternetAvailable = await CommonUtil().checkInternetConnection();

  if (isInternetAvailable){
    try{
      final url = Uri.parse('${AppGlobal.baseUrl}elderly/configuration/letter-size');
      final accessToken = await AppGlobal().accessToken();
      final response = await http.patch(
        url,
        body: jsonEncode({'userTitleSize': titleSize, 'userTextSize': textSize, 'elderlyId': elderlyId}),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        result = LetterSizeRequest.fromJson(responseData);
      } else {
        print('Letter Size failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
    }
    return result;
  } else {}
}

//----------------- Favorites -----------------
Future<UploadContactResponse?> requestAddFavorites(String personName, String personPhoneNumber, String personImage, bool allowVoice, bool allowVideo, bool allowWhatsApp, String elderlyId) async {

  UploadContactResponse? result;
  bool isInternetAvailable = await CommonUtil().checkInternetConnection();

  if (isInternetAvailable){
    try{
      final url = Uri.parse('${AppGlobal.baseUrl}elderly-favorites-contacts');
      print('URL: $url');
      final accessToken = await AppGlobal().accessToken();
      FavoriteContactModel contact = FavoriteContactModel(personName: personName, personImage: personImage, personPhoneNumber: personPhoneNumber, isVideo: allowVideo, isVoice: allowVoice, isWhatsApp: allowWhatsApp, elderlyId: elderlyId, id: '');
      AddFavoriteBody body = AddFavoriteBody(elderlyId: elderlyId, favoritesContacts: [contact]);
      // var body = jsonEncode({'personName': personName, 'personPhoneNumber': personPhoneNumber, 'personImage': personImage, 'isVoice': allowVoice, 'isVideo': allowVideo, 'isWhatsApp': allowWhatsApp, 'elderlyId': elderlyId});
      print('Body: ${jsonEncode(body)}');
      final response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        result = UploadContactResponse.fromJson(responseData);
      } else {
        print('Add favorite contact failed with status code: ${response.statusCode}');
        print(response);
      }

    } catch (e) {
      log(e.toString());
    }
    return result;
  } else {}
}

//----------------- Emergency Contact -----------------
Future<AddEmergencyContactRequest?> requestAddEmergencyContact(arr, String elderlyId) async {

  AddEmergencyContactRequest? result;
  bool isInternetAvailable = await CommonUtil().checkInternetConnection();

  if (isInternetAvailable){
    try{
      final url = Uri.parse('${AppGlobal.baseUrl}elderly-emergency-contacts');
      final accessToken = await AppGlobal().accessToken();
      print('Size of Array: ${arr.length}');
      print('Emergency Contacts: ${jsonEncode(arr)}');
      print('ElderlyID: $elderlyId');
      final response = await http.post(
        url,
        body: jsonEncode({'elderlyId': elderlyId, "emergencyContacts": arr}),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        result = AddEmergencyContactRequest.fromJson(responseData);
      } else {
        print('Add emergency contact failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
    }
    return result;
  } else {}
}

//----------------- Upload Contact -----------------
Future<UploadContactResponse> uploadContacts(List<FavoriteContactModel> contacts) async {

  UploadContactResponse result = UploadContactResponse(status: false, message: 'Por favor revise su connexion a internet.', data: []);

  bool isInternetAvailable = await CommonUtil().checkInternetConnection();


  if (isInternetAvailable){
    try{
      final elderlyId = await AppGlobal().retrieveId();
      AddFavoriteBody body = AddFavoriteBody(elderlyId: elderlyId, favoritesContacts: contacts);


      final url = Uri.parse('${AppGlobal.baseUrl}elderly-favorites-contacts');
      print(url);
      print(jsonEncode(body));
      final accessToken = await AppGlobal().accessToken();
      final response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );
      print('Response: ${response}');
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        result = UploadContactResponse.fromJson(responseData);
      } else {
        print('Response is failed : ${response.statusCode}');
      }
    } catch (e) {
      log('Exception: ${e.toString()}');
    }
  } else {
    print("No internet Coneection");
  }

  return result;
}

//----------------- Sound -----------------
Future<SoundRequest?> requestSound(int? volume, bool? bluetooth, String elderlyId) async {

  SoundRequest? result;
  bool isInternetAvailable = await CommonUtil().checkInternetConnection();

  if (isInternetAvailable){
    try{
      final url = Uri.parse('${AppGlobal.baseUrl}elderly/configuration/sound');
      final accessToken = await AppGlobal().accessToken();
      final response = await http.patch(
        url,
        body: jsonEncode({'userVolume': volume, 'userBluetooth': bluetooth, 'elderlyId': elderlyId}),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        result = SoundRequest.fromJson(responseData);
      } else {
        print('Sound failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
    }
    return result;
  } else {}
}

//----------------- Leisure -----------------
Future<LeisureRequest?> requestLeisure(arr, String elderlyId) async {

  LeisureRequest? result;
  bool isInternetAvailable = await CommonUtil().checkInternetConnection();

  if (isInternetAvailable){
    try{
      final url = Uri.parse('${AppGlobal.baseUrl}elderly-game');
      final accessToken = await AppGlobal().accessToken();
      final response = await http.post(
        url,
        body: jsonEncode({'elderlyId': elderlyId, "games": arr}),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        result = LeisureRequest.fromJson(responseData);
      } else {
        print('Leisure failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
    }
    return result;
  } else {}
}

//----------------- Send All Installed Apps -----------------
Future<SendInstalledAppRequest?> requestSendAllInstalledApps(arr, String elderlyId) async {

  SendInstalledAppRequest? result;
  bool isInternetAvailable = await CommonUtil().checkInternetConnection();

  if (isInternetAvailable){
    final url = Uri.parse('${AppGlobal.baseUrl}elderly/all-apps');
    final accessToken = await AppGlobal().accessToken();
    final response = await http.post(
      url,
      body: jsonEncode({'elderlyId': elderlyId, "allApps": arr}),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);
      result = SendInstalledAppRequest.fromJson(responseData);
    } else {
      print('Sending Apps failed with status code: ${response.statusCode}');
    }
    try{

    } catch (e) {
      log(e.toString());
    }
    return result;
  } else {}
}

//----------------- Invite Admin -----------------
Future<SendAdminInviteRequest?> requestSendAdminInvite(String email, String elderlyId) async {

  SendAdminInviteRequest? result;
  bool isInternetAvailable = await CommonUtil().checkInternetConnection();

  if (isInternetAvailable){
    try{
      final url = Uri.parse('${AppGlobal.baseUrl}user/send-invite');
      final accessToken = await AppGlobal().accessToken();
      final response = await http.post(
        url,
        body: jsonEncode({'userEmail': email, 'elderlyId': elderlyId}),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        result = SendAdminInviteRequest.fromJson(responseData);
      } else {
        print('Admin invitation failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
    }
    return result;
  } else {}
}

//----------------- Get All Admin Elderly -----------------
Future<GetElderlyRequest?> requestGetElderly() async {

  GetElderlyRequest? result;
  bool isInternetAvailable = await CommonUtil().checkInternetConnection();

  if (isInternetAvailable){
    try{
      final url = Uri.parse('${AppGlobal.baseUrl}administrator/elderly');
      final accessToken = await AppGlobal().accessToken();
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        result = GetElderlyRequest.fromJson(responseData);
      } else {
        print('Fetch Elderly failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
    }
    return result;
  } else {}
}

//----------------- Get Specific Elderly -----------------
Future<GetSpecificElderlyRequest?> requestGetSpecificElderly(String userId) async {

  GetSpecificElderlyRequest? result;
  bool isInternetAvailable = await CommonUtil().checkInternetConnection();

  if (isInternetAvailable){
    final url = Uri.parse('${AppGlobal.baseUrl}elderly/details/$userId');
    final accessToken = await AppGlobal().accessToken();
    final response = await http.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);
      result = GetSpecificElderlyRequest.fromJson(responseData);
    } else {
      print('Fetch Specific Elderly failed with status code: ${response.statusCode}');
    }
    try{

    } catch (e) {
      log(e.toString());
    }
    return result;
  } else {}
}

//----------------- Get All Supervisors -----------------
Future<GetSupervisorsRequest?> requestGetSupervisors() async {

  GetSupervisorsRequest? result;
  bool isInternetAvailable = await CommonUtil().checkInternetConnection();

  if (isInternetAvailable){
    try{
      final url = Uri.parse('${AppGlobal.baseUrl}administrator/supervisor');
      final accessToken = await AppGlobal().accessToken();
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        result = GetSupervisorsRequest.fromJson(responseData);
      } else {
        print('Fetch Supervisors failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
    }
    return result;
  } else {}
}

//----------------- Delete Specific Supervisor -----------------
Future<DeleteSupervisorsRequest?> requestDeleteSupervisor(String email) async {

  DeleteSupervisorsRequest? result;
  bool isInternetAvailable = await CommonUtil().checkInternetConnection();

  if (isInternetAvailable){
    try{
      final url = Uri.parse('${AppGlobal.baseUrl}user');
      final accessToken = await AppGlobal().accessToken();
      final response = await http.delete(
        url,
        body: jsonEncode({'userEmail': email}),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        result = DeleteSupervisorsRequest.fromJson(responseData);
      } else {
        print('Fetch Supervisors failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
    }
    return result;
  } else {}
}

//----------------- Get All Supervisor Elderly -----------------
Future<GetSupervisorElderlyRequest?> requestGetSupervisorElderly() async {

  GetSupervisorElderlyRequest? result;
  bool isInternetAvailable = await CommonUtil().checkInternetConnection();

  if (isInternetAvailable){
    try{
      final url = Uri.parse('${AppGlobal.baseUrl}supervisor/elderly');
      final accessToken = await AppGlobal().accessToken();
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        result = GetSupervisorElderlyRequest.fromJson(responseData);
      } else {
        print('Fetch Supervisor Elderly failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
    }
    return result;
  } else {}
}