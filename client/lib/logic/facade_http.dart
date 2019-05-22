import 'dart:convert';

import 'package:flutter/material.dart';

import 'dart:convert' as JSON;
import 'dart:io';
import 'package:http/io_client.dart';

import 'package:messenger_app/screens/emails.dart';
import 'package:messenger_app/models/user.dart';

import 'package:messenger_app/screens/home/login.dart';

class FacadeHttp {

  static const String BASE_URL = 'https://dry-peak-13680.herokuapp.com';
  
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

  Future<bool> submitLogin(String user, String pass, BuildContext context) async {
    
    if (user.isNotEmpty &&
        pass.isNotEmpty) {
          print("Clicked");


      var login = Map<String, dynamic>();
  
      login['nickname'] = user;
      login['password'] = pass;

      return await this._ioClient
          .put('$BASE_URL/user/login',
          body: login)
          .then((response)  {
              print("Login:");
              print('Response: ${response.statusCode}  Body:${response.body} ');

              if(response.body.contains('Login Error'))
                return false;
              
              if(!(response.body.contains('rr'))){
                print("token gerado");
                print(response.body);
                _token = response.body;

                this._ioClient.get(
                    '$BASE_URL/user/get?nickname=$user',
                    headers: {
                      'Authorization': 'Bearer $_token',
                    }).then((value) {
                      print("NEWYasasSER: ${value.body}");
                      var infoNewUser = JSON.jsonDecode(value.body);
                      
                      //print("ox: ${infoNewUser['name']}");

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

              return true;
           }
          )
          .catchError((err) {
            print(err.toString());
            print('deu ruim');
      });
    }
  }

  void submitSign(String name, String user  , String pass, BuildContext context) {
    if (user.isNotEmpty &&
        pass.isNotEmpty && name.isNotEmpty) {
          print("Clicked");

      var sign = Map<dynamic, dynamic>();

      sign['name'] = name;
      sign['nickname'] = user;
      sign['password'] = pass;
      
      this._ioClient
          .post(
            '$BASE_URL/user/signup?name=$name&nickname=$user&password=$pass',
            headers: { "Accept": "application/json" },
            )
          .then((response) {
            print("Signup:");
            print('Response: ${response.statusCode}  Body:${response.body} ');

            if(response.body == "Signup Success"){ 
              print("Deu certo signup");
              
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => LoginPage()));

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
            '$BASE_URL/user/logout',
            headers: {
              "Accept": "application/json",
              'Authorization': 'Bearer $_token'
            },
          body: logout)
          .then((response)  {
              print("Logout:");
              print('Response: ${response.statusCode}  Body:${response.body} ');

              
                  print("logout feito");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => LoginPage()));

              }
            )
          .catchError((err) {
            print(err.toString());
            print('deu ruim');
      });

  }

  Future<String> getChats(String user, String token) async {
      _token = token;
      var response = await this._ioClient.get(
      '$BASE_URL/chat/getlist?nickname=$user',
      headers: {
        'Authorization': 'Bearer $_token',
        "Accept": "application/json"
      });

      return response.body;
  } 

  void createChat(String currentUser, String toUser, String subject, BuildContext context, String token) {

    this._ioClient.post(
      '$BASE_URL/chat/create?subject=$subject&users_nicknames=$currentUser,$toUser',
      headers: {
        'Authorization': 'Bearer $_token',
        "Accept": "application/json"
      },
      ).then((response) {
        print("chat criado");
        print('Response: ${response.statusCode}  Body:${response.body}');
      })
      .catchError((err) {
        print(err.toString());
        print("Chat não foi criado");
      });
  }  

  void sendMessage(String currentUser, int idChat, String message, String token) {

      _token = token;

      
      var messageData = Map<dynamic, dynamic>();

      messageData['sender_nickname'] = currentUser;
      messageData['chat_id'] = idChat.toString();
      messageData['text_message'] = message;

        this._ioClient.post(
      '$BASE_URL/message/send',
      headers: {
        'Authorization': 'Bearer $_token',
        "Accept": "application/json"
      },
      body: messageData,
      ).then((response) {
        print("mensagem enviada????");
        print('Response: ${response.statusCode}  Body:${response.body}');
      })
      .catchError((err) {
        print(err.toString());
        print("Mensagem nao foi enviada");
      });
  }


  // Notify precisa ser implementado para esse metodo
  Future<String> getMessage(String user, String idChat) async {
      var response = await this._ioClient.get(
      '$BASE_URL/message/getlist?nickname=$user&chat_id=$idChat',
      headers: {
        'Authorization': 'Bearer $_token',
        "Accept": "application/json"
      });

      return response.body;
  }

  // Precisa melhorar
  void addUsersChat(String idChat, List users, String newUser, String token) {

    _token = token;

    this._ioClient.put(
      '$BASE_URL/chat/addusers?users_nicknames=$newUser&chat_id=$idChat',
      headers: {
        'Authorization': 'Bearer $_token',
        "Accept": "application/json"
      },
      ).then((response) {
        print('Response: ${response.statusCode}  Body:${response.body}');
        if(response.statusCode == 200){
          var map = json.decode(response.body);
          users = map['users'];
        }

          print(users);
      })
      .catchError((err) {
        print(err.toString());
        print("Usuário não foi adicionado");
      });
  }

  void removeToken(String nickname) {
    this._ioClient
          .put('$BASE_URL/remove/token',
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
    if(response.contains("expired")) {
      print("Token expirado, usuario precisa ser deslogado");
    }
  }

}

    
