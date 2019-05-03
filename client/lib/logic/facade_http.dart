
import 'dart:_http';
import 'dart:convert' as JSON;
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:messenger_app/logic/class/user.dart';
import 'package:http/io_client.dart';
import 'package:path/path.dart';

class FacadeHttp{

  static FacadeHttp _instance;
  var _urlSignUp = 'https://192.168.0.39:8443/user/signup';
  var _urlLogin = 'https://192.168.0.39:8443/user/login';
  HttpClient _httpClient = null;
  IOClient _ioClient = null;


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

  void submitLogin(String user, String pass) async{
    
    if (user.isNotEmpty &&
        pass.isNotEmpty) {
          print("Clicked");
      //User newUser = User( "a",_userControllerLogin.text, _passwordControllerLogin.text,
      //   DateTime.now().toString(), []);
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: (BuildContext context) => Emails(newUser)));

      var login = Map<String, dynamic>();
  
      login['nickname'] = user;
      login['password'] = pass;

      this._ioClient
          .post(this._urlLogin,
          headers: {"Accept": "application/json"},
          body: login)
          .then((response) {
        print("Login:");
        print('Response: ${response.statusCode}  Body:${response.body} ');
        Map result = JSON.jsonDecode(response.body);
            print("Map:   $result");
            User newUser = User.getInstance();
            newUser.setAll(result['username'], result['name'], result['password']);
        //ioClient.close();
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (BuildContext context) =>
        //       Emails(newUser)));
           }
          )
          .catchError((err) {
        print(err.toString());
        print('deu ruim');
      });
    
    }
  }

  

  void submitSign(String user, String pass, String name){
    if (user.isNotEmpty &&
        pass.isNotEmpty && name.isNotEmpty) {
          print("Clicked");
      //User newUser = User( "a",_userControllerLogin.text, _passwordControllerLogin.text,
      //   DateTime.now().toString(), []);
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: (BuildContext context) => Emails(newUser)));

      var sign = Map<String, dynamic>();

      sign['name'] = name;
      sign['nickname'] = user;
      sign['password'] = pass;
      
      print("clicked");
      this._ioClient
          .post(
            this._urlSignUp,
            headers: {"Accept": "application/json"},
            body: sign)
          .then((response) {
            print("Signup:");
            print('Response: ${response.statusCode}  Body:${response.body} ');

            Map result = JSON.jsonDecode(response.body);
            print("Map:   $result");
            User newUser = User.getInstance();
            newUser.setAll(result['username'], result['name'], result['password']);
            //if(result['loggedIn'] && false) {
             // User newUser = (result[""],result[""], result[""]);
             // Navigator.pushReplacement(context,
               // MaterialPageRoute(builder: (BuildContext context) => Emails(newUser)));
            //}
        })
          .catchError((err) {
        print(err.toString());
        print('deu ruim');

      });
    
      
    }

  }

  getEmails() async {
          HttpClient httpClient = new HttpClient()
        ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) {
          print("CERTIFICADO HTTP");
          // tests that cert is self signed, correct subject and correct date(s)
          return true;
        });

      IOClient ioClient = new IOClient(httpClient);
      var urlGetList = 'https://192.168.0.39:8443/chat/getlist';

      var getList = Map<String, dynamic>();
      User userInstance = User.getInstance();
      getList['nickname'] = userInstance.nickname;

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

            // dar um email como parametro pra esta função
            // fazer função no email q pega o map result e atualiza a lista de emails
        })
          .catchError((err) {
        print(err.toString());
        print('deu ruim');
            ioClient.close();

      });


  }
}

    
