import './user.dart';
import './chat.dart';

class Message {
  Chat _chat;
  User _to;
  User _from;
  String _message;
  String _date;

  Chat get chat => _chat;
  String get message => _message;
  String get date => _date;
  User get to => _to;
  User get from => _from;

  Message(this._chat, this._to, this._from, this._message, this._date) {
    //_chat.addMessage(this);    
  }
  
  Map toMap() {
    var map = Map<String, dynamic>();
   
    map["to"] = _to.nickname;
    map["from"] = _from.nickname;
    map["date"] = _date;
    map["message"] = _message;
    
    return map;
  }

}