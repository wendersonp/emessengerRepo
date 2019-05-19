import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:http/io_client.dart';
import 'dart:convert' as JSON;

import 'package:messenger_app/models/chat.dart';
import 'package:messenger_app/models/user.dart';

import 'package:messenger_app/screens/new_email.dart';
import 'package:messenger_app/screens/messages.dart';

import 'package:messenger_app/logic/facade_http.dart';

class Emails extends StatefulWidget {

  //final String _name;
  //final String _nickname;
  final User _currentUser;
  Emails(this._currentUser);
  //{
    //_currentUser = User(_name, _nickname, []);
  //}

  @override
  State<StatefulWidget> createState() => _EmailsState(_currentUser);
}

class _EmailsState extends State<Emails> {
  //String date = DateFormat.Hm().format(DateTime.now());
  final User _currentUserState;
  //final String _nameState;
  //final String _nicknameState;
  _EmailsState(this._currentUserState);
  //_currentUser.addChat(Chat(_currentUserState, _currentUserState, "Hello", [], date, "message"));
  int listCount;
  
  void initState() {
    _currentUserState.addChat(Chat(_currentUserState, _currentUserState, "slack", [], DateFormat.Hm().format(DateTime.now()).toString(), "Hi"));

    FacadeHttp facade = FacadeHttp();
    facade.getChats(_currentUserState.nickname, _currentUserState.accessToken);
    
    super.initState();

  }

  Map<String, dynamic> allData = {
    "username": "Carlos",
    "name": "Nobrega",
    "nickname": "Alves",
    "emails": [],
  };

  
  @override
  Widget build(BuildContext context) {
      if (_currentUserState == null) {
        debugPrint("No user");
      } else {
        debugPrint("Name: " + _currentUserState.name);
        debugPrint("Nickname: " + _currentUserState.nickname);

        FacadeHttp facade = FacadeHttp();
        facade.getChats(_currentUserState.nickname, _currentUserState.accessToken);
        
      }
    return Scaffold(
      appBar: AppBar(
        title: Text("Email list"),
      ),
      body:listEmailUser(),
      drawer: Drawer(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: CircleAvatar(
                  radius: 40.0,
                  child: Text(_currentUserState.name..substring(0,1)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: Text("Hello"),
              ),
              Padding(
                padding: EdgeInsets.only(top: 120.0),
                child: Card(
                  elevation: 2.0,
                  child: Padding(padding: EdgeInsets.symmetric(horizontal: 110.0), child: ListTile(
                  enabled: true,
                  title: Text("Sair"),
                  onTap: () {
                    FacadeHttp facade = FacadeHttp.getIntance();
                             
                    facade.logoutUser(_currentUserState.nickname, context);
                  },
                ),
               ), 
              ),
              )
            ],
          ),
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToNewEmail();
        },
        tooltip: "Enviar novo email",
        child: Icon(Icons.add),
      ),
    );
  }

  void navigateToNewEmail() async {
    bool result = await Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => NewEmail(allData, _currentUserState),),);
  }
 
  //Very usefull function
  // ListView.builder 
  Widget listEmail() {
    int listSize = listEmailsCount(allData["emails"]);

    if(listSize == 0) {
      return Center(child: Text("Você não possui mensagens", style: TextStyle(color: Colors.black),),);
    }
    return  ListView.builder(
      itemCount: listSize,
      itemBuilder: (BuildContext context, int position) {
        
        String to = allData['emails'][position]["to"];
        
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: Text(to.substring(0,1)),
            title: Text("$to ${allData['emails'][position]["dateEmail"]} ", style: TextStyle(fontWeight: FontWeight.w500,),),
            subtitle: Text("${allData['emails'][position]["subject"]}"),
            onTap: () {
              Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => Messages(allData["emails"][position]["messages"], allData["emails"][position])),
              );
            },
          ),
        );
      },
    );
  }

  int listEmailsCount(List emails) {
    if(emails == null) {
      return 0;
    }
    return emails.length;
  }

  // Using that one
  Widget listEmailUser() {
    int listSize = listEmailsCount(_currentUserState.chats);

    if(listSize == 0) {
      return Center(child: Text("Caixa de entrada vazia", style: TextStyle(color: Colors.black54)));
    }
    return  ListView.builder(
      itemCount: listSize,
      itemBuilder: (BuildContext context, int position) {
        
        String to = _currentUserState.chats[position].to.nickname;
        //String date = _currentUserState.chats[position].date;
        String sub = _currentUserState.chats[position].subject;
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            //leading: Text(to.substring(0,1)),
            leading: Text("${sub.substring(0,1)}"),
            title: Text("$to ${_currentUserState.chats[position].date} ", 
              style: TextStyle(
                fontWeight: FontWeight.w500,
                ),
              ),
            subtitle: Text("$sub"),
            onTap: () {
              Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => Messages(_currentUserState.chats[position].messages, _currentUserState.chats[position])),
              );
            },
          ),
        );
      },
    );
  }

  void getEmails() async {
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
    
      getList['nickname'] = _currentUserState.nickname;

      print("clicked");
      ioClient
          .get(
            urlGetList,
            headers: {"Accept": "application/json"},)
            // GET isnt accepting a body
            //body: getList)
          .then((response) {
            print("getList:");
            print('Response: ${response.statusCode}  Body:${response.body} ');

            Map result = JSON.jsonDecode(response.body);
            print("Map:   $result");
        })
          .catchError((err) {
            print(err.toString());
            print('deu ruim');
            ioClient.close();

      });
    }
}
