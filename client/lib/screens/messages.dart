import 'package:flutter/material.dart';
import '../models/message.dart';
import '../models/chat.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'dart:io';
import 'package:http/io_client.dart';
import 'dart:convert' as JSON;

class Messages extends StatefulWidget{
  final List<dynamic> _allMessages;
  final Chat _chat;
  Messages(this._allMessages, this._chat);
  
  
  @override
  State<StatefulWidget> createState() => _MessagesState(_allMessages, _chat);
}

class _MessagesState extends State<Messages> {

  final List<dynamic> _allMessagesState;
  final Chat _chatState;
  _MessagesState(this._allMessagesState, this._chatState);
  TextEditingController _messageController = TextEditingController();
  //Intl.defaultLocale = 'pt_BR';
  //initializeDateFormatting();
  
    @override
  void initState() {
    _allMessagesState.add(Message(_chatState, _chatState.to, _chatState.from, "Hello", DateTime.utc(2019, 4, 20, 20, 18).toString()));
    _allMessagesState.insert(0,
         Message(_allMessagesState[0].chat, _allMessagesState[0].to,
         _allMessagesState[0].from, "My", DateTime.utc(2019, 4, 30, 20, 18).toString()));
    _allMessagesState.insert(0,
         Message(_allMessagesState[0].chat, _allMessagesState[0].to,
         _allMessagesState[0].from, "Friend", DateTime.utc(2019, 5, 1, 10, 54).toString()));
    _allMessagesState.insert(0,
         Message(_allMessagesState[0].chat, _allMessagesState[0].to,
         _allMessagesState[0].from, "Hisashi", DateTime.utc(2019, 5, 2, 15, 25).toString()));
    _allMessagesState.insert(0,
         Message(_allMessagesState[0].chat, _allMessagesState[0].to,
         _allMessagesState[0].from, "Buri", DateTime.now().toString()));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },),
      ),
      body: screenChat(),
    );
  }
 
  void newMessage(String message) {
    if(message.isNotEmpty) {
      setState(() {
        
        // _allMessagesState.insert(0, {
        //   "fromDialog": "Carlos",
        //   "message": message,
        //   "date": DateTime.now().toString(),
        // });
        if(_allMessagesState.length == 0 ) {
          debugPrint("me ajuda 100or");
          _allMessagesState.add(Message(_chatState, _chatState.to, _chatState.from, message, DateTime.now().toString()));
        } else {
          _allMessagesState.insert(0,
         Message(_allMessagesState[0].chat, _allMessagesState[0].to,
         _allMessagesState[0].from, message, DateTime.now().toString()));

        } 
        
        _messageController.text = "";
      });
    }
  } 

  Widget messageList() {
    debugPrint("hellow2");
    return ListView.builder(
        reverse: true,
        itemCount: countMessages(_allMessagesState),
        itemBuilder: (BuildContext context, int position) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [ 
              Center(child: timeStamp(_allMessagesState, position),),
              message(_allMessagesState, position),
            
            ]
          );
        },
      );
  }

  int countMessages(List<dynamic> _allMessages) {
    if(_allMessages == null) {
      return 0;
    }
    return _allMessages.length;
  }

  Widget screenChat() {
    return Column(
      children: <Widget>[
        Flexible(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: messageList(),
            
            )
        ),
        Divider(
          height: 1.0,
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: TextFormField(
            maxLines: null,
            textCapitalization: TextCapitalization.sentences,
            controller: _messageController,
            decoration: InputDecoration(
                hintText: 'Digite...',
                suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      newMessage(_messageController.text);
                    }
                )
            ),
          ),
        )
      ],
    );
  }

  Widget timeStamp(List _allMessagesState, int position) {
    Intl.defaultLocale = 'pt_BR';
    initializeDateFormatting();
    var date = DateFormat.yMMMMd("pt_BR").format(DateTime.parse(_allMessagesState[position].date));
    //DateFormat.yMMMMd("pt_BR").format(DateTime.now())
    debugPrint("Position: $position, ${_allMessagesState.length}");
    if(_allMessagesState.length == position+1) {
      return Column( children: <Widget>[Text( '$date'), Divider(height: 10.0,)]);
    }
    else if(position >= 0){
      int newMessageDay =  int.parse(_allMessagesState[position].date.substring(8,10));
      int oldMessageDay = int.parse(_allMessagesState[position+1].date.substring(8,10));
      debugPrint(" newDay:$newMessageDay  oldDay: $oldMessageDay");
      debugPrint("${_allMessagesState[position].date.substring(8,10)}");
      if(newMessageDay != oldMessageDay) {
        return Column( children: <Widget>[Text( '$date'), Divider(height: 10.0,)]);
      }
    }
    return Container();
  }

  Widget message(List messageList, int position) {
    debugPrint("${messageList[position].from.name}");
    int newMessageDay =  int.parse(_allMessagesState[position].date.substring(8,10));
    int oldMessageDay = newMessageDay;
    if(position < _allMessagesState.length-1) {
      oldMessageDay = int.parse(_allMessagesState[position+1].date.substring(8,10));

    } 

    if (_allMessagesState.length == position+1
        || position == 0 && messageList.length > 0 && messageList[position].from.name != messageList[position+1].from.name
        || newMessageDay != oldMessageDay) {
      return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                children: <Widget>[
                  Text("${_allMessagesState[position].from.name}", style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(" ${DateFormat.Hm().format(DateTime.parse(_allMessagesState[position].date))}",
                      style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15.0),
                      ),
                  //Text(" ${_allMessagesState[position].date}"),
                ],
              ),
              Text("${_allMessagesState[position].message}"),],);
    } else if (position > 0 && messageList.length > 0 && messageList[position].from.name == messageList[position-1].from.name) {
      return Text("${_allMessagesState[position].message}");
    } else if (position == 0 && messageList.length > 0 && messageList[position].from.name == messageList[position+1].from.name){
      debugPrint("Ta chegando so no final");
      return Text("${_allMessagesState[position].message}");
    }
    return Container();
  }

  void createMessage(String to , String subject, String message) async {
          HttpClient httpClient = new HttpClient()
        ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) {
          print("CERTIFICADO HTTP");
          // tests that cert is self signed, correct subject and correct date(s)
          return true;
        });

      IOClient ioClient = new IOClient(httpClient);
      var urlCreateChat = 'https://192.168.0.39:8443/message/send';


      Map<String, dynamic> newMessage = {
     //   "sender_nickname": _currentUser.nickname, 
        "text_message": message,
        "subject": subject,
        "to": to, 
      };

    
      print("clicked");
      ioClient
          .post(
            urlCreateChat,
            headers: {"Accept": "application/json"},
            // PROBLEM
            body: newMessage)
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

// bottomNavigationBar: Container(
//         margin: EdgeInsets.only(left: 16.0),
//         child: TextFormField(
//           maxLines: null,
//         controller: _messageController,
//           decoration: InputDecoration(
//               hintText: 'Digite...',
//               suffixIcon: IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () {
//                     newMessage(_messageController.text);
//                   }
//               )
//           ),
//         ),
//       ),