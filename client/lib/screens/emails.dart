import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:messenger_app/logic/class/chat_notifier.dart';

import 'package:messenger_app/models/user.dart';

import 'package:messenger_app/screens/new_email.dart';
import 'package:messenger_app/screens/messages.dart';

import 'package:messenger_app/logic/facade_http.dart';

class Emails extends StatefulWidget {

  //final String _name;
  //final String _nickname;
  final User _currentUser;
  Emails(this._currentUser);

  @override
  State<StatefulWidget> createState() => _EmailsState(_currentUser);
}

class _EmailsState extends State<Emails> {
  final User _currentUserState;
  _EmailsState(this._currentUserState);
  


  List _chats;
  //List _chatsWork;
  int listCount;
  
  void initState() {

       
    FacadeHttp facade = FacadeHttp();

        ChatNotifier((c) {
          setState(() {

            print("Lista foi atualizada");
            _chats = c;
            print(_chats);
          });
      
    }, facade, _currentUserState.nickname, _currentUserState.accessToken);

    
    print("Fora do metodo $_chats");
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
      if (_currentUserState == null) {
        debugPrint("No user");
      } else {
        debugPrint("Name: " + _currentUserState.name);
        debugPrint("Nickname: " + _currentUserState.nickname);
      }
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de conversas"),
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
                child: Text("Olá"),
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
    Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => NewEmail(_currentUserState),),);
  }

  int listEmailsCount(List emails) {
    if(emails == null) {
      return 0;
    }
    return emails.length;
  }

  // Using that one
  Widget listEmailUser() {
    //int listSize = listEmailsCount(_currentUserState.chats);
    int listSize = listEmailsCount(_chats);
    print("List size: $listSize");
    if(listSize == 0) {
      return Center(child: Text("Caixa de entrada vazia", style: TextStyle(color: Colors.black54)));
    }
    return  ListView.builder(
      itemCount: listSize,
      itemBuilder: (BuildContext context, int position) {
        
        int reverse = listSize-position-1;

        String to = _chats[reverse]['users'][1]['nickname'];
        String sub = _chats[reverse]['subject'];
        String date = _chats[reverse]['lastUpdate'];

        Intl.defaultLocale = 'pt_BR';
        initializeDateFormatting();
        var dateHm = DateFormat.Hm('pt_BR').format(DateTime.parse(date));

        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            //leading: Text(to.substring(0,1)),
            leading: Text("${sub.substring(0,1)}"),
            title: Text("$to    $dateHm", 
              style: TextStyle(
                fontWeight: FontWeight.w500,
                ),
              ),
            subtitle: Text("$sub"),
            onTap: () {
              Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => Messages(_currentUserState, _chats[reverse]['idChat'], _chats[reverse]['users'])),
              );
            },
          ),
        );
      },
    );
  }
}
