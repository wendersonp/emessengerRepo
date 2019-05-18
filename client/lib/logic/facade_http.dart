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

  static FacadeHttp _instance;


  HttpClient _httpClient;
  IOClient _ioClient;
  String _token;

  FacadeHttp(){
  
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

              
              if(!(response.body.contains('err'))){
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

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => Emails(newUser)));
                        }
                      );
              }
            //print("Map:   $result");
            
        //ioClient.close();

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
            headers: {"Accept": "application/json"},
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
            print('deu ruim');

      });
    }
  }

  void logoutUser(String nickname, BuildContext context) {
    this._ioClient
          .put('https://dry-peak-13680.herokuapp.com/user/logout',
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $_token',  
          },
          body: {
            nickname: nickname
          })
          .then((response)  {
              print("Logout:");
              print('Response: ${response.statusCode}  Body:${response.body} ');

              
                if(response.body.contains('Success')){
                  print("logout feito");
                        Navigator.push(
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

  Map getEmails(User user){
          HttpClient httpClient = new HttpClient()
        ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) {
          print("CERTIFICADO HTTP");
          // tests that cert is self signed, correct subject and correct date(s)
          return true;
        });

      IOClient ioClient = new IOClient(httpClient);
      var urlGetList = 'https://dry-peak-13680.herokuapp.com/secured/message/getlist';

      var getList = Map<String, dynamic>();

      print("clicked");
      ioClient
          .get(
            urlGetList,
            headers: {"Accept": "application/json"},)
            // PROBLEM
            //body: getList)
          .then((response) {
            print("Signup:");
            print('Response: ${response.statusCode}  Body:${response.body} ');

            Map result = JSON.jsonDecode(response.body);

            print("Map:   $result");
            return result;

            // dar um email como parametro pra esta função
            // fazer função no email q pega o map result e atualiza a lista de emails
        })
          .catchError((err) {
            print(err.toString());
            print('não funcionou');
            ioClient.close();
      });


  }

  Map addUserInChat(Chat chat, String nickname, String id){
    HttpClient httpClient = new HttpClient()
        ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) {
          // tests that cert is self signed, correct subject and correct date(s)
          return true;
        });
    IOClient ioClient = new IOClient(httpClient);
    var urlAddUserInChat = 'https://dry-peak-13680.herokuapp.com/secured/chat/addusers';   
    var listUsers = [chat.to.nickname, chat.from.nickname, nickname];
    var add = Map<String, dynamic>();
    add["users_nicknames"] = [listUsers];
    add["chat_id"] = [id];
     ioClient
          .put(
            urlAddUserInChat,
            headers: {"Accept": "application/json"},
            body: add )
          .then((response) {
            print("Signup:");
            print('Response: ${response.statusCode}  Body:${response.body} ');

            Map result = JSON.jsonDecode(response.body);
            print("Map:   $result");

            return result;

        })
          .catchError((err) {
        print(err.toString());
        print('nao funcionou');
            ioClient.close();

      });


  }

  Map getUserInfos(User user){
    HttpClient httpClient = new HttpClient()
        ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) {
          // tests that cert is self signed, correct subject and correct date(s)
          return true;
        });
    IOClient ioClient = new IOClient(httpClient);

    ioClient
          .get(
            'https://dry-peak-13680.herokuapp.com/secured/user/get',
            headers: {"Accept": "application/json"},
            // PROBLEM
          )
          .then((response) {
            print('Response: ${response.statusCode}  Body:${response.body} ');

            Map result = JSON.jsonDecode(response.body);
            print("Map:   $result");

            return result;


          })
          .catchError((err) {
            print(err.toString());
            print('Não funcionou');
            ioClient.close();
      });
  }

  void removeToken(String nickname) {
    this._ioClient
          .put('https://dry-peak-13680.herokuapp.com/remove/token',
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
                print("token removido");
              }
           }
          )
          .catchError((err) {
            print(err.toString());
            print('Token não foi removido');
          });
  }

}

    
