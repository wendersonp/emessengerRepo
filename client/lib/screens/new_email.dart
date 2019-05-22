import 'package:flutter/material.dart';

import 'package:messenger_app/models/user.dart';

import 'package:messenger_app/logic/facade_http.dart';

class NewEmail extends StatefulWidget {
  final User _currentUser;

  NewEmail(this._currentUser);

  _NewEmailState createState() => _NewEmailState();
}

class _NewEmailState extends State<NewEmail> {

  User _currentUser;
  TextEditingController _toController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    _currentUser = widget._currentUser;
    _toController.text = "";
    _subjectController.text = "";
    _messageController.text = "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = TextStyle(
      decoration: TextDecoration.none,
      fontWeight: FontWeight.w500,
    );
    TextStyle labelStyle = TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w400,
      color: Theme.of(context).hintColor,
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Enviar novo email"),
      ),
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child:ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 5.0, bottom:5.0),
            child: TextField(
              textInputAction: TextInputAction.next,
              controller: _toController,
              style: textStyle,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Para",
                labelStyle: labelStyle,
            ),
           ), 
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0, bottom:5.0),
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              controller: _subjectController,
              style: textStyle,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Assunto",
                labelStyle: labelStyle,
            ),
           ), 
          ),
          Padding(
            padding: EdgeInsets.only(top: 25.0, left: 150.0, right: 20.0),
            child: ButtonTheme(
              height: 60.0,
              minWidth: 100.0,
              child: RaisedButton(
                onPressed: () { 
                  if(_toController.text.isNotEmpty && _subjectController.text.isNotEmpty) {
                    FacadeHttp facade = FacadeHttp.getIntance(); 
                    facade.createChat(_currentUser.nickname,_toController.text, _subjectController.text, context, _currentUser.token);
                    Navigator.pop(context);
                  }         
                },
                color: Theme.of(context).accentColor,
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(
                    color: Colors.black38,
                  )
                  ),
                child: Text("Enviar",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                    textScaleFactor: 1.5,
                  
              ),
            ),),
          ),
        ],
      ),
      ),
    );
  }

  void createNewChat(String toUser, String subject ) {
      FacadeHttp facade = FacadeHttp();
      facade.createChat(_currentUser.nickname, toUser, subject, context, _currentUser.accessToken);
  }


 }