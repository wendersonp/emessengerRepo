import 'dart:convert';

import 'package:flutter/material.dart';

import 'dart:convert' as JSON;
import 'dart:io';
import 'package:http/io_client.dart';

import 'package:messenger_app/screens/emails.dart';
import 'package:messenger_app/models/user.dart';

import 'package:messenger_app/screens/home/login.dart';

class FacadeHttp {

  static  String BASE_URL = 'http://150.165.202.45:32448';
  
  static FacadeHttp _instance;
  static String _token;


  HttpClient _httpClient;
  IOClient _ioClient;

  FacadeHttp(){
      _setClient();
  }


  static FacadeHttp getIntance(){
      if(_instance ==null) _instance = new FacadeHttp();
        return _instance;
  }

  void setIP(String newIp){
    if(newIp=="") return;
    BASE_URL = newIp;
  }

  String getIP(){
    return BASE_URL;
  }


  void _setClient(){
    this._httpClient= new HttpClient()
        ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) {
          // tests that cert is self signed, correct subject and correct date(s)
          return true;
        });

    this._ioClient= new IOClient(this._httpClient);

  }


  

  Future<bool> submitLogin(String user, String pass, BuildContext context) async {
    
    if (user.isNotEmpty &&
        pass.isNotEmpty) {


      var login = Map<String, dynamic>();
  
      login['nickname'] = user;
      login['password'] = pass;

      return await this._ioClient
          .put('$BASE_URL/user/login',
          body: login)
          .then((response)  {

              if(response.body.contains('Login Error'))
                return false;
              
              if(!(response.body.contains('rr'))){
                _token = response.body;

                this._ioClient.get(
                    '$BASE_URL/user/get?nickname=$user',
                    headers: {
                      'Authorization': 'Bearer $_token',
                    }).then((value) {
                      var infoNewUser = JSON.jsonDecode(value.body);
                      

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
      });
    }
  }

  Future<bool> submitSign(String name, String user  , String pass, BuildContext context) async{
    if (user.isNotEmpty &&
        pass.isNotEmpty && name.isNotEmpty) {

      var sign = Map<dynamic, dynamic>();

      sign['name'] = name;
      sign['nickname'] = user;
      sign['password'] = pass;
      
      return await this._ioClient
          .post(
            '$BASE_URL/user/signup?name=$name&nickname=$user&password=$pass',
            headers: { "Accept": "application/json" },
            )
          .then((response) {

            if(response.body == "Signup Success"){ 
              
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
                  return true;
            }

            return false;
        })
          .catchError((err) {

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
      
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => LoginPage()));

              }
            )
          .catchError((err) {
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
      })
      .catchError((err) {
        print(err.toString());
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
      })
      .catchError((err) {
        print(err.toString());
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
        if(response.statusCode == 200){
          var map = json.decode(response.body);
          users = map['users'];
        }

      })
      .catchError((err) {
        print(err.toString());
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
              if(response.body.contains('success')){
                _token = '';
              }
           }
          )
          .catchError((err) {
            print(err.toString());
          });
  }

  void middleware(String response) {
    if(response.contains("expired")) {
      print("Token expirado, usuario precisa ser deslogado");
    }
  }

}

    
