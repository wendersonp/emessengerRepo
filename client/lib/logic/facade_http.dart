import 'package:flutter/material.dart';

//import 'dart:http';
import 'dart:convert' as JSON;
import 'dart:io';
//import 'package:messenger_app/logic/class/user.dart';
import 'package:http/io_client.dart';

import '../screens/emails.dart';
import '../models/user.dart';

import 'class/chat.dart';
import 'package:messenger_app/screens/home/login.dart';

class FacadeHttp{

  static const String URL = 'https://dry-peak-13680.herokuapp.com';
  
  static FacadeHttp _instance;
  static String _token;


  HttpClient _httpClient;
  IOClient _ioClient;

  FacadeHttp(){
      print('FacadeToken:$_token');
      _setClient();
  }

  void _setClient(){
    this._httpClient= new HttpClient()
        ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) {
          print("CERTIFICADO HTTP");
          // tests that cert is self signed, correct subject and correct date(s)
          return true;
        });

    this._ioClient= new IOClient(this._httpClient);

  }


  static FacadeHttp getIntance(){
      if(_instance ==null) _instance = new FacadeHttp();
        return _instance;
  }

  void submitLogin(String user, String pass, BuildContext context) async {
    
    if (user.isNotEmpty &&
        pass.isNotEmpty) {
          print("Clicked");


      var login = Map<String, dynamic>();
  
      login['nickname'] = user;
      login['password'] = pass;

      this._ioClient
          .put('https://dry-peak-13680.herokuapp.com/user/login',
          headers: {"Accept": "application/json"},
          body: login)
          .then((response)  {
              print("Login:");
              print('Response: ${response.statusCode}  Body:${response.body} ');
              
              if(!(response.body.contains('rr'))){
                print("token gerado");
                print(response.body);
                _token = response.body;

                this._ioClient.get(
                    'https://dry-peak-13680.herokuapp.com/user/get?nickname=$user',
                    headers: {
                      'Authorization': 'Bearer $_token',
                      "Accept": "application/json"
                    }).then((value) {
                      print("NEWYasasSER: ${value.body}");
                      var infoNewUser = JSON.jsonDecode(value.body);
                      
                      print("ox: ${infoNewUser['name']}");

                      User newUser = User(
                        infoNewUser['idUser'],
                        infoNewUser['name'],
                        infoNewUser['nickname'],
                        infoNewUser['accessToken'],
                        [],
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => Emails(newUser)));
                        }
                      );
              }
           }
          )
          .catchError((err) {
            print(err.toString());
            print('deu ruim');
      });

    
    }
  }

  void submitSign(String user, String pass, String name) {
    if (user.isNotEmpty &&
        pass.isNotEmpty && name.isNotEmpty) {
          print("Clicked");

      var sign = Map<String, dynamic>();

      sign['name'] = name;
      sign['nickname'] = user;
      sign['password'] = pass;
      
      this._ioClient
          .post(
            'https://dry-peak-13680.herokuapp.com/user/signup',
            headers: { "Accept": "application/json" },
            body: sign)
          .then((response) {
            print("Signup:");
            print('Response: ${response.statusCode}  Body:${response.body} ');

            if(response.body == "Signup Success"){ 
              print("Deu certo signup");
            }
        })
          .catchError((err) {
            print(err.toString());
            print('Não funcionou');

      });
    }
  }

  void logoutUser(String nickname, BuildContext context) {

    var logout = Map<dynamic,  String>();
    logout['nickname'] = nickname;

    this._ioClient
          .put(
            '$URL/user/logout',
            headers: {
              "Accept": "application/json",
              'Authorization': 'Bearer $_token'
            },
          body: logout)
          .then((response)  {
              print("Logout:");
              print('Response: ${response.statusCode}  Body:${response.body} ');

              
                if(response.body.contains('Success')){
                  print("logout feito");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
                }
              }
            )
          .catchError((err) {
            print(err.toString());
            print('deu ruim');
      });

  }

  void getChats(String user, String token) {
      _token = token;
      this._ioClient.get(
      '$URL/chat/getlist?nickname=$user',
      headers: {
        'Authorization': 'Bearer $_token',
        "Accept": "application/json"
      }).then((value) {
        print("lista de chats: ${value.body}");
        var infoNewUser = JSON.jsonDecode(value.body);
        
        print("ox: ${infoNewUser}");
        print(_token);

      })
      .catchError((err) {
        print(err.toString());
      });
  } 

  void createChat(String currentUser, String toUser, String subject, BuildContext context, String token) {

    var newChat = Map<dynamic,  dynamic>();
    newChat['nickname'] = subject;
    newChat['users_nicknames'] = [currentUser, toUser];

    this._ioClient.post(
      '$URL/chat/create',
      headers: {
        'Authorization': 'Bearer $_token',
        "Accept": "application/json"
      },
      body: newChat
      ).then((response) {
        print("mensagem enviada");
        print(response.body);
      })
      .catchError((err) {
      });
      
  }  

  void removeToken(String nickname) {
    this._ioClient
          .put('$URL/remove/token',
          headers: {
            "Accept": "application/json",
          },
          body: {
            nickname: nickname
          })
          .then((response)  {
              print("Logout:");
              print('Response: ${response.statusCode}  Body:${response.body} ');
              
              if(response.body.contains('success')){
                _token = '';
              }
           }
          )
          .catchError((err) {
            print(err.toString());
            print('Token não foi removido');
          });
  }

  void middleware(String response) {
    if(response.contains("invalid_token")) {
      print("Token expirado, usuario precisa ser deslogado");
    }
  }

}

    
