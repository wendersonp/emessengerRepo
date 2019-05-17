
//import 'dart:http';
import 'dart:convert' as JSON;
import 'dart:io';
import 'package:messenger_app/logic/class/user.dart';
import 'package:http/io_client.dart';

import 'class/chat.dart';

class FacadeHttp{

  static FacadeHttp _instance;


  HttpClient _httpClient = null;
  IOClient _ioClient = null;
  String _accessToken = null;
  String _userToken = null;

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

  void submitLogin(String user, String pass){
    
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
          .put('https://dry-peak-13680.herokuapp.com/user/login',
          headers: {"Accept": "application/json"},
          body: login)
          .then((response) {
              print("Login:");
              print('Response: ${response.statusCode}  Body:${response.body} ');

              
              if(!(response.body.contains('err'))){
                print("token gerado");
                print(response.body);


              }
            //print("Map:   $result");
            
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

    //return false;
    
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

}

    
