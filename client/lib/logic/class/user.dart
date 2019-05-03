import './chat.dart';


class User {
  String _name="";
  String _nickname="";
  String _password="";
  String _creationDate;
  List<Chat> _chats;
  static User _instance;
  
  //User(this._name, this._nickname, this._password, this._creationDate, this._chats);
  _User(){}
  
  static User getInstance(){
    if(_instance== null){
      _instance = new User();
    }
    return _instance;
  }


  String get nickname => _nickname;
  List get chats => _chats;
  
  String get password => _password;
  String get creationDate => _creationDate;

  void setusername(String username) {
    if(username.length < 20) {
      _nickname = username;
    }
  }

  void setpassword(String password) {
    if(password.length < 15) {
      _password = password;
    }
  }

  void setcreationDate(String creationDate) {
    _creationDate = creationDate;
  }

  void addChat(Chat c) {
    _chats.add(c);
  }

  
  setAll(String username, String pass, String name){
    setusername(username);
    setpassword(pass);
    _name=name;
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