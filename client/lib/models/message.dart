//import './user.dart';
//import './chat.dart';

class Message {
  int _idChat;
  String _from;

  int get idChat => _idChat;
  String get from => _from;
    

  
  Message(this._from, this._idChat);

  // Talvez não precise
  Map toMap() {
    var map = Map<String, dynamic>();
   
    return map;
  }

}