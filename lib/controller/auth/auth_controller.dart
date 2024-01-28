// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/models/apiresponse_model.dart';
import 'package:smart_parker/models/login_model.dart';
import 'package:smart_parker/models/register_model.dart';
import 'package:http/http.dart' as http;
import 'package:smart_parker/models/user_model.dart';

class AuthController {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<ApiResponse> registerAccount({
    required String email,
    required String password,
    required String name,
  }) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.post(
          Uri.parse("${Environtment().baseURLServer}/api/auth/user/register"),
          headers: {
            'Accept': 'application/json',
          },
          body: {
            'email': email,
            'password': password,
            'name': name
          }).timeout(Duration(seconds: Environtment().timeOutDuration));

      switch (response.statusCode) {
        case 200:
          apiresponse.data = RegisterModel.fromJson(jsonDecode(response.body));
          break;
        case 401:
          apiresponse.error = unauthorizedMessage;
          apiresponse.unauthorized = true;
          break;
        case 400:
          apiresponse.error = jsonDecode(response.body)['message'];
          break;
        default:
          apiresponse.error = somethingWentWrong;
          break;
      }
    } catch (err) {
      if (err is TimeoutException) {
        apiresponse.error = timeoutException;
      } else if (err is SocketException) {
        apiresponse.error = socketException;
      } else {
        apiresponse.error = serverError;
      }
    }

    return apiresponse;
  }

  Future<ApiResponse> loginAccount(
      {required String email, required String password}) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.post(
          Uri.parse("${Environtment().baseURLServer}/api/auth/login"),
          headers: {
            'Accept': 'application/json',
          },
          body: {
            'email': email,
            'password': password,
          }).timeout(Duration(seconds: Environtment().timeOutDuration));

      switch (response.statusCode) {
        case 200:
          apiresponse.data = LoginModel.fromJson(jsonDecode(response.body));
          break;
        case 401:
          apiresponse.error = unauthorizedMessage;
          apiresponse.unauthorized = true;
          break;
        case 400:
          apiresponse.error = jsonDecode(response.body)['message'];
          break;
        default:
          apiresponse.error = somethingWentWrong;
          break;
      }
    } catch (err) {
      if (err is TimeoutException) {
        apiresponse.error = timeoutException;
      } else if (err is SocketException) {
        apiresponse.error = socketException;
      } else {
        apiresponse.error = serverError;
      }
    }

    return apiresponse;
  }

  Future<ApiResponse> getUserInfo({required String tokenSession}) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.get(
          Uri.parse("${Environtment().baseURLServer}/api/auth/user"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenSession'
          }).timeout(Duration(seconds: Environtment().timeOutDuration));

      // print("body NEww :" + response.body);

      switch (response.statusCode) {
        case 200:
          apiresponse.data =
              UserModel.fromJson(jsonDecode(response.body)['payload']);
          break;
        case 401:
          apiresponse.error = unauthorizedMessage;
          apiresponse.unauthorized = true;
          break;
        case 400:
          apiresponse.error = jsonDecode(response.body)['message'];
          break;
        default:
          apiresponse.error = somethingWentWrong;
          break;
      }
    } catch (err) {
      if (err is TimeoutException) {
        apiresponse.error = timeoutException;
      } else if (err is SocketException) {
        apiresponse.error = socketException;
      } else {
        apiresponse.error = serverError;
      }
    }

    return apiresponse;
  }

  Future<ApiResponse> logout(
      {required String tokenSession, required String tokenDevice}) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.delete(
          Uri.parse(
              "${Environtment().baseURLServer}/api/auth/logout/$tokenDevice"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenSession'
          }).timeout(Duration(seconds: Environtment().timeOutDuration));
      switch (response.statusCode) {
        case 200:
          apiresponse.data = jsonDecode(response.body)['message'];
          break;
        case 401:
          apiresponse.error = unauthorizedMessage;
          apiresponse.unauthorized = true;
          break;
        case 400:
          apiresponse.error = jsonDecode(response.body)['message'];
          break;
        default:
          apiresponse.error = somethingWentWrong;
          break;
      }
    } catch (err) {
      if (err is TimeoutException) {
        apiresponse.error = timeoutException;
      } else if (err is SocketException) {
        apiresponse.error = socketException;
      } else {
        apiresponse.error = serverError;
      }
    }

    return apiresponse;
  }

  Future<ApiResponse> checkSession({required String tokenSession}) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.get(
          Uri.parse("${Environtment().baseURLServer}/api/auth/checkSession"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenSession'
          }).timeout(Duration(seconds: Environtment().timeOutDuration));

      switch (response.statusCode) {
        case 200:
          apiresponse.data = jsonDecode(response.body)['message'];
          break;
        case 401:
          apiresponse.error = unauthorizedMessage;
          apiresponse.unauthorized = true;
          break;
        case 400:
          apiresponse.error = jsonDecode(response.body)['message'];
          break;
        default:
          apiresponse.error = somethingWentWrong;
          break;
      }
    } catch (err) {
      if (err is TimeoutException) {
        apiresponse.error = timeoutException;
      } else if (err is SocketException) {
        apiresponse.error = socketException;
      } else {
        apiresponse.error = serverError;
      }
    }

    return apiresponse;
  }

  Future<void> showAccountPicker(BuildContext context) async {
    await _googleSignIn.signOut();
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signInSilently();

      if (account == null) {
        // If no account is signed in, show account picker
        final GoogleSignInAccount? selectedAccount =
            await _googleSignIn.signIn();

        if (selectedAccount != null) {
          // final GoogleSignInAuthentication googleAuth =
          //     await selectedAccount.authentication;
          // User selected an account, do something with the account
          // print('Selected account: ${googleAuth.accessToken}');
          // successSnackbar(
          //    context:  context,title:  "Selamat datang",message:  googleAuth.accessToken.toString());
        } else {
          // User canceled account selection
        }
      } else {
        // User is already signed in, do something with the current account
      }
    } catch (error) {
      // failedSnackbar(context, "Mohon maaf terjadi kesalahan", error.toString());
    }
  }
}
