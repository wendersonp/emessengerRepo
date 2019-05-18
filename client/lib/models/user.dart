import './chat.dart';


class User {
  int _idUser;
  String _name;
  String _nickname;
  String _accessToken;
  List<Chat> _chats;
  

  User(this._idUser, this._name, this._nickname, this._accessToken, this._chats);
  
  int get idUser => _idUser;
  String get name => _name;
  String get nickname => _nickname;
  List get chats => _chats;
  
  String get accessToken => _accessToken;

  set username(String username) {
    if(username.length < 20) {
      _nickname = username;
    }
  }

  set password(String accessToken) {
    if(accessToken.length < 45) {
      _accessToken = accessToken;
    }
  }

  void addChat(Chat c) {
    _chats.add(c);
  }
  
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["username"] = _nickname;
    map["password"] = _accessToken;
    map["chat"] = _chats.map((c) => c.toMap()).toList();
   
    return map;
  }


}