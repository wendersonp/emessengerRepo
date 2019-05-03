import 'package:flutter/material.dart';

import '../emails.dart';
import '../../models/user.dart';

import 'dart:io';
import 'package:http/io_client.dart';
import 'dart:convert' as JSON;
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'package:async/async.dart';
// import 'package:dio/dio.dart';

class LoginPage extends StatefulWidget {

  State<StatefulWidget> createState() => _LoginPageStates();
}

class _LoginPageStates extends State<LoginPage> {

  TextEditingController _userControllerLogin = TextEditingController();
  TextEditingController _passwordControllerLogin = TextEditingController();

  TextEditingController _userdControllerSign = TextEditingController();
  TextEditingController _passwordControllerSign = TextEditingController();
  TextEditingController _nameControllerSign = TextEditingController();

  static String tag = 'login-page';
  String valor = "";

  final FocusNode _login = FocusNode();
  final FocusNode _sign = FocusNode();
  final FocusNode _loginP = FocusNode();
  final FocusNode _signP = FocusNode();
  final FocusNode _signName = FocusNode();


  @override
  Widget build(BuildContext context) {
    return

        Scaffold(
          backgroundColor: Colors.black,
          body: getContainer(),

      );
  }

  Widget getContainer(){
    return(
      ListView(
        children: <Widget>[
          Container(
            color: Colors.black,
            height: 100,
            width:  100,
          ),
          DefaultTabController(
            length: 2,
            initialIndex: 0,

            child:
            Column(
              children: <Widget>[
                TabBar(
                  isScrollable: true,
                  labelColor: Colors.white,
                  tabs: <Widget>[
                    Tab(
                      text:'Login' ,
                    ),
                    Tab(
                      text: 'Sign-Up',)
                  ],
                ),
                Container(
                  height: 400,
                  width: 300,
                  child: TabBarView(
                    children: <Widget>[
                      getContentLogin(),
                      getContentSignin()
                    ],
                  ),
                )
              ],
            ),
          )


        ],
      )
    );
  }





  Widget getContentLogin() {
    return (

        Center(

            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[


                  Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: TextFormField(
                      controller: _userControllerLogin,
                      textInputAction: TextInputAction.next,
                      focusNode: _login,
                      onFieldSubmitted: (term){
                        FocusScope.of(context).requestFocus(_loginP);
                      },
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                      maxLines: 1,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Nome de usuário',
                          //hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          )

                      ),

                    ),
                  ),

                  TextFormField(
                      textInputAction: TextInputAction.done,
                    controller: _passwordControllerLogin,
                    style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                      focusNode: _loginP,
                      maxLines: 1,
                      obscureText: true,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Senha',
                          //hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          )
                      ),
                    ),



                  Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                      child: ButtonTheme(
                          height: 50,
                          minWidth: 200,
                          child: RaisedButton(
                            color: Colors.deepOrangeAccent,
                            textColor: Colors.white,
                            child: Text('Login'),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                            onPressed: () {
                              submitLoginNoServer();
                              //submitLogin();
                              //Navigator.pushReplacement(context,
                                 // MaterialPageRoute(
                                    //  builder: (BuildContext context) =>
                                     //     Emails()));
                            },

                          )
                      )
                  )
                ]
            )

        )
    );
  }

  Widget getContentSignin() {

    return (
        Center(
            child: Column(
              
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Padding(padding: EdgeInsets.fromLTRB(0, 35, 0, 10),
                    child: TextFormField(
                    controller: _nameControllerSign,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      focusNode: _signName,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                          filled: true,
                          hintText: "Nome",
                          //hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          )
                      ),
                    ),
                    ),
                    
                    TextFormField(
                      controller: _userdControllerSign,
                      textInputAction: TextInputAction.next,
                      focusNode: _sign,
                      onFieldSubmitted: (term){
                        FocusScope.of(context).requestFocus(_signP);
                      },
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                          filled: true,
                          hintText: "Nome de usuário",
                          //hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          )
                      ),
                    ),
                  
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: TextFormField(
                    controller: _passwordControllerSign,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      focusNode: _signP,
                      obscureText: true,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                          filled: true,
                          hintText: "Senha",
                          //hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          )
                      ),
                    ),
                    
                  ),


                  Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                      child: ButtonTheme(
                          height: 50,
                          minWidth: 200,
                          child: RaisedButton(
                            color: Colors.deepOrangeAccent,
                            textColor: Colors.white,
                            child: Text('Criar conta'),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                            onPressed: () {
                              //submitSign();
                            },

                          )
                      )
                  ),
                
              ]
            )
        )
    );
  }

  void submitLogin() async {
    
    if (_userControllerLogin.text.isNotEmpty &&
        _passwordControllerLogin.text.isNotEmpty) {

      HttpClient httpClient = new HttpClient()
        ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) {
          print("CERTIFICADO HTTP");
          // tests that cert is self signed, correct subject and correct date(s)
          return true;
        });

      IOClient ioClient = new IOClient(httpClient);
      var urlLogin = 'https://192.168.0.39:8443/user/login';

      var login = Map<String, dynamic>();
  
      login['nickname'] = _userControllerLogin.text;
      login['password'] = _passwordControllerLogin.text;

      ioClient
          .put(urlLogin,
          headers: {"Accept": "application/json"},
          body: login)
          .then((response) {
        print("Login:");
        print('Response: ${response.statusCode}  Body:${response.body} ');

        Map result = JSON.jsonDecode(response.body);
        print("Map:   ${result["name"]}");
        print("Map:   ${result["nickname"]}");
        //User newUser = User(result['name'], result['nickname'], []);

        if( response.body.isNotEmpty ) {
          debugPrint("usuario logado");
          //debugPrint(newUser.nickname);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (BuildContext context) =>
          //       //Emails(result['name'], result['nickname'])
          //       ));
            }
          }
        )
          .catchError((err) {
            print(err.toString());
            print('deu ruim');
      });
    }
  }

   void submitSign() async {
    if (_userdControllerSign.text.isNotEmpty &&
        _passwordControllerSign.text.isNotEmpty) {


      HttpClient httpClient = new HttpClient()
        ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) {
          print("CERTIFICADO HTTP");
          // tests that cert is self signed, correct subject and correct date(s)
          return true;
        });

      IOClient ioClient = new IOClient(httpClient);
      var urlSignUp = 'https://192.168.0.39:8443/user/signup';

      var signUp = Map<String, dynamic>();
    
      signUp['name'] = _nameControllerSign.text;
      signUp['nickname'] = _userdControllerSign.text;
      signUp['password'] = _passwordControllerSign.text;

      print("clicked");
      ioClient
          .post(
            urlSignUp,
            headers: {"Accept": "application/json"},
            body: signUp)
          .then((response) {
            print("Signup:");
            print('Response: ${response.statusCode}  Body:${response.body} ');

            Map result = JSON.jsonDecode(response.body);
            print("Map:   ${result["name"]}");
            print("Map:   ${result["nickname"]}");

            // if(result['loggedIn'] && false) {
            //   User newUser = (result["name"], result['nickname'], []);
            //   Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (BuildContext context) => Emails(newUser)));
            // }


        })
          .catchError((err) {
        print(err.toString());
        print('Não funcionou');
            //ioClient.close();

      });

      // User newUser = User( "A", _userdControllerSign.text, _passwordControllerSign.text,
      //     DateTime.now().toString(), []);
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: (BuildContext context) => Emails(newUser)));
    }
  }

  submitLoginNoServer() {
    if( _userControllerLogin.text.isNotEmpty ) {
      debugPrint("usuario logado");
      //debugPrint(newUser.nickname);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
            Emails(User(_userControllerLogin.text, _userControllerLogin.text, []))));
    }
  }
}