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

            _chats = c;
          });
      
    }, facade, _currentUserState.nickname, _currentUserState.accessToken);

    
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text("Lista de conversas", style: TextStyle(color: Colors.white),),
      ),
      body:listEmailUser(),
      drawer: Drawer(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 60.0),
                child: CircleAvatar(
                  backgroundColor: Colors.teal,
                  radius: 50.0,
                  child: Icon(Icons.person)),
                ),
        
              Padding( 
                padding: EdgeInsets.only(top: 30.0),
                child: Text("Olá ${_currentUserState.name}"),
              ),
              Padding(
                padding: EdgeInsets.only(top: 100.0),
                child: Card(
                  color: Colors.teal,
                  elevation: 2.0,
                  child: Padding(padding: EdgeInsets.symmetric(horizontal: 110.0), child: ListTile(
                  enabled: true,
                  title: Text("Sair", style: TextStyle(color: Colors.white),),
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
        backgroundColor: Colors.teal,
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
            leading: Icon(Icons.people_outline),
            title: Text("$to    $dateHm", 
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black
                ),
              ),
            subtitle: Text("$sub", style: TextStyle(color: Colors.black),),
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
