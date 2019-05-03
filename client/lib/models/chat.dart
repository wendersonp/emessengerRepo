import './message.dart';
import './user.dart';

class Chat {
  User _from;
  User _to;
  String _subject;
  String _message;
  String _date;
  List<Message> _messages;

  Chat(this._to, this._from, this._subject, this._messages, this._date, this._message) {

    Message m = Message(this, _to, _from, _message, _date);
    _from.addChat(this);
    _to.addChat(this);
  }
  
  String get message => _message;
  String get subject => _subject;
  String get date => _date;
  User get to => _to;
  User get from => _from;
  List get messages => _messages;

  void addMessage(Message m) {
		_messages.add(m);
  }
  
  Map toMap() {
    var map = Map<String, dynamic>();
    //var m = List<Map<String, dynamic>>();
   
    map["to"] = _to.nickname;
    map["from"] = _from.nickname;
    map["messages"] = _messages.map((message) => message.toMap()).toList();
    
    //m.add(map);
    
    return map;
  }

  // set message(String message) {
  //   if(message.length <= 255) {
  //     _message = message;
  //   }
  // }

  // set date(String date) {
  //   _date = date;
  // }


}