import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:messenger_app/logic/class/message_notifier.dart';
import 'package:messenger_app/logic/facade_http.dart';

import 'package:messenger_app/models/user.dart';


class Messages extends StatefulWidget{
  // final List<dynamic> _allMessages;
  // final Chat _chat;

  final User _currentUser;
  final int _idChat;
  final List _users;

  Messages(this._currentUser, this._idChat, this._users);
  
  
  @override
  State<StatefulWidget> createState() => _MessagesState(_currentUser, _idChat, _users);
}

class _MessagesState extends State<Messages> {

  // final List<dynamic> messages;
  // final Chat _chatState;

  final User _currentUserState;
  final int _idChatState;
  final List _usersState;
  List messages;

  _MessagesState(this._currentUserState, this._idChatState, this._usersState);
  TextEditingController _messageController = TextEditingController();
  
    @override
  void initState() {

    FacadeHttp facade = FacadeHttp.getIntance();

    MessageNotifier((m) {
      setState(() {
          messages = m;
          print("Atualização mensagens");
          print(messages);
          print("==========================");
      });
    }, facade, _currentUserState.nickname, _idChatState.toString());

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
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                  _showDialog();
              },
            )
          ],
      ),
      body: screenChat(),
    );
  }

  Widget messageList() {
    return ListView.builder(
        reverse: true,
        itemCount: countMessages(messages),
        itemBuilder: (BuildContext context, int position) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [ 
              Center(child: timeStamp(messages, position),),
              message(messages, position),
            
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


                     FacadeHttp facade = FacadeHttp.getIntance();
                      
                      if(_messageController.text.isNotEmpty)
                        facade.sendMessage(_currentUserState.nickname, _idChatState, _messageController.text);

                      _messageController.text = '';
                    }
                )
            ),
          ),
        )
      ],
    );
  }

  Widget timeStamp(List messages, int position) {
    Intl.defaultLocale = 'pt_BR';
    initializeDateFormatting();
    var date = DateFormat.yMMMMd("pt_BR").format(DateTime.parse(messages[position].date));
    //DateFormat.yMMMMd("pt_BR").format(DateTime.now())
    debugPrint("Position: $position, ${messages.length}");
    if(messages.length == position+1) {
      return Column( children: <Widget>[Text( '$date'), Divider(height: 10.0,)]);
    }
    else if(position >= 0){
      int newMessageDay =  int.parse(messages[position].date.substring(8,10));
      int oldMessageDay = int.parse(messages[position+1].date.substring(8,10));
      debugPrint(" newDay:$newMessageDay  oldDay: $oldMessageDay");
      debugPrint("${messages[position].date.substring(8,10)}");
      if(newMessageDay != oldMessageDay) {
        return Column( children: <Widget>[Text( '$date'), Divider(height: 10.0,)]);
      }
    }
    return Container();
  }

  Widget message(List messageList, int position) {
    debugPrint("${messageList[position].from.name}");
    int newMessageDay =  int.parse(messages[position].date.substring(8,10));
    int oldMessageDay = newMessageDay;
    if(position < messages.length-1) {
      oldMessageDay = int.parse(messages[position+1].date.substring(8,10));
    } 

    if (messages.length == position+1
        || position == 0 && messageList.length > 0 && messageList[position].from.name != messageList[position+1].from.name
        || newMessageDay != oldMessageDay) {
      return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                children: <Widget>[
                  Text("${messages[position].from.name}", style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(" ${DateFormat.Hm().format(DateTime.parse(messages[position].date))}",
                      style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15.0),
                      ),
                  //Text(" ${messages[position].date}"),
                ],
              ),
              Text("${messages[position].message}"),],);
    } else if (position > 0 && messageList.length > 0 && messageList[position].from.name == messageList[position-1].from.name) {
      return Text("${messages[position].message}");
    } else if (position == 0 && messageList.length > 0 && messageList[position].from.name == messageList[position+1].from.name){
      debugPrint("Ta chegando so no final");
      return Text("${messages[position].message}");
    }
    return Container();
  }

  void _showDialog() {
    TextEditingController _newUserController = TextEditingController();
    _newUserController.text = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Adicione um novo usuário ao chat", style: TextStyle(color: Colors.black),),
          content: TextField(
            controller: _newUserController,
            decoration: InputDecoration(hintText: "Nickname do novo integrante"),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Adicionar"),
              onPressed: () { 

                FacadeHttp facade = FacadeHttp.getIntance();
                facade.addUsersChat(_idChatState.toString(), _usersState, _newUserController.text, _currentUserState.accessToken);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
