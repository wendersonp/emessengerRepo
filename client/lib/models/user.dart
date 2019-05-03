import './chat.dart';
import './message.dart';

class User {
  String _name;
  String _nickname;
  String _password;
  String _creationDate;
  List<Chat> _chats;
  
  //User(this._name, this._nickname, this._password, this._creationDate, this._chats);
  //User(this._name, this._nickname, this._chats);
  User(this._name, this._nickname, this._chats);
  
  String get name => _name;
  String get nickname => _nickname;
  List get chats => _chats;
  
  String get password => _password;
  String get creationDate => _creationDate;

  set username(String username) {
    if(username.length < 20) {
      _nickname = username;
    }
  }

  set password(String password) {
    if(password.length < 15) {
      _password = password;
    }
  }

  set creationDate(String creationDate) {
    _creationDate = creationDate;
  }

  void addChat(Chat c) {
    _chats.add(c);
  }
  
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["username"] = _nickname;
    map["password"] = _password;
    map["creationDate"] = _creationDate;
    map["chat"] = _chats.map((c) => c.toMap()).toList();
   
    return map;
  }


}