import 'package:flutter/material.dart';

import 'package:messenger_app/models/user.dart';

import 'package:messenger_app/screens/emails.dart';

import 'package:messenger_app/logic/facade_http.dart';

import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {

  State<StatefulWidget> createState() => _LoginPageStates();
}

class _LoginPageStates extends State<LoginPage> {

  TextEditingController _userControllerLogin = TextEditingController();
  TextEditingController _passwordControllerLogin = TextEditingController();

  TextEditingController _userdControllerSign = TextEditingController();
  TextEditingController _passwordControllerSign = TextEditingController();
  TextEditingController _nameControllerSign = TextEditingController();
  TextEditingController _control = TextEditingController(); 
  FacadeHttp _facade = FacadeHttp.getIntance();

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
          bottomNavigationBar: new BottomAppBar(
            color: Colors.black,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              
                children: <Widget>[
                  IconButton(
                    color: Colors.white,
                    onPressed: () {
                    getContainerIP();
                  }, icon: Icon(Icons.settings)),
                ],
              ),
            ),
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
                            color: Colors.teal,
                            textColor: Colors.white,
                            child: Text('Login'),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                            onPressed: ()  {
                              

                              _facade.submitLogin(_userControllerLogin.text, _passwordControllerLogin.text, context)
                              .then((valid){
                                if(!valid){
                                  showDialog(context: context, builder: (context) {
                                    CloseButton button = CloseButton(key: Key('X'));

                                    return AlertDialog(title: Text('Erro'),
                                                       content: Text('Usuário ou senha incorretos'),
                                                       actions: <Widget>[button] );
                                  });
                                }
                              });
                            }
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
                            color: Colors.teal,
                            textColor: Colors.white,
                            child: Text('Criar conta'),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                            onPressed: () async {
                                                           
                              _facade.submitSign(_nameControllerSign.text, _userdControllerSign.text, _passwordControllerSign.text, context)
                              .then((sucess){
                                if(!sucess){
                                  showDialog(context: context, builder: (context) {
                                    CloseButton button = CloseButton(key: Key('X'));

                                    return AlertDialog(title: Text('Erro'),
                                                       content: Text('Não foi possível efetuar o cadastro! Escolha outro nome de usuário.'),
                                                       actions: <Widget>[button] );
                                  });
                                }
                              });
                                
                            },
                          )
                      )
                  ),
                
              ]
            )
        )
    );
  }


  submitLoginSemServer() {
    if( _userControllerLogin.text.isNotEmpty ) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
            Emails(User(555,"test","test","test", []))));
    }
  }

  void getContainerIP(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Coloque o endereço do servidor :", style: TextStyle(color: Colors.black),),
          content:TextFormField(
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: "url",
            ),
            controller: _control,
            textInputAction: TextInputAction.done,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
          ),
          actions: <Widget>[
            RaisedButton(
              child: new Text("Confirmar", style: TextStyle(color: Colors.white),),
              onPressed: (){
                Navigator.of(context).pop();
                _facade.setIP(_control.text);
                Fluttertoast.showToast(
                  msg: "Base Url: ${_facade.getIP()}",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  fontSize: 16.0
                );
              },
            )
          ],
        );
      
        
      }

    );  
  }
}