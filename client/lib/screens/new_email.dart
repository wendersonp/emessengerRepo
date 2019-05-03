import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http/io_client.dart';
import 'dart:convert' as JSON;

import '../models/user.dart';
import '../models/chat.dart';

class NewEmail extends StatefulWidget {
  final Map<String, dynamic> _emails;
  final User _currentUser;

  NewEmail(this._emails, this._currentUser);
  //NewEmail({Key key, this.name}) : super(key: key);
  //final String name;

  _NewEmailState createState() => _NewEmailState();
}

class _NewEmailState extends State<NewEmail> {

  User _currentUser;
   Map<String, dynamic> _allEmails;
  TextEditingController _toController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    _currentUser = widget._currentUser;
    _allEmails = widget._emails;
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
        actions: [
          IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child:ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 5.0, bottom:5.0),
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
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
            padding: EdgeInsets.only(top: 5.0, bottom:5.0),
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              controller: _messageController,
              maxLines: 5,
              
              style: textStyle,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Mensagem",
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
                  if(_toController.text.isNotEmpty && _subjectController.text.isNotEmpty && _messageController.text.isNotEmpty) {
                    sendEmail(_toController.text, _subjectController.text, _messageController.text);
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

  void sendEmail(String to , String subject, String message) {
    var dateNow = DateTime.now();
    var formater = DateFormat('yyyy-MM-dd hh:mm');
    //var date = formater.format(dateNow);
    var date = DateFormat.Hm().format(DateTime.now()).toString();
    debugPrint("to: $to, subject: $subject, message: $message, date: ${DateFormat.Hm().format(DateTime.now()).toString()} ");
    Map<String, dynamic> email = {
      "from": "Carlos", 
      "to": to, 
      "subject": subject,
      "dateEmail": DateFormat.Hm().format(DateTime.now()).toString(), 
      "messages":[{
        "fromDialog": "Carlos", 
        "message": message, 
        "date": DateFormat.Hm().format(DateTime.now()).toString()
        }],
    };

    if(_allEmails["emails"] == null) {
      _allEmails["emails"] = [email];
    }
    else {
      _allEmails["emails"].insert(0, email);
    }
    _currentUser.addChat(Chat(_currentUser, _currentUser, subject, [], date, message));
  }  

  void createChat(String to , String subject, String message) async {
          HttpClient httpClient = new HttpClient()
        ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) {
          print("CERTIFICADO HTTP");
          // tests that cert is self signed, correct subject and correct date(s)
          return true;
        });

      IOClient ioClient = new IOClient(httpClient);
      var urlCreateChat = 'https://192.168.0.39:8443/chat/create';


      Map<String, dynamic> newChat = {
        "subject": subject,
        "creator_nickname": _currentUser.nickname, 
        "destination_nickneme": to, 
      };

    
      print("clicked");
      ioClient
          .post(
            urlCreateChat,
            headers: {"Accept": "application/json"},
            // PROBLEM
            body: newChat)
          .then((response) {
            print("Signup:");
            print('Response: ${response.statusCode}  Body:${response.body} ');

            Map result = JSON.jsonDecode(response.body);
            print("Map:   $result");
            if(response.body == null) {
              print("Chat não foi criado");
            }
            else {
              print("funcionou");
            }
          })

          .catchError((err) {
            print(err.toString());
            print('deu ruim');
            ioClient.close();

          });
    }
}