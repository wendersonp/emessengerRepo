import 'dart:async';
import '../facade_http.dart';
import 'dart:convert' as JSON;

//Ouvinte que recebe uma lista de chats do servidor:
typedef void ChatListen(List chats);

class ChatNotifier
{
  ChatListen _chatListen;
  FacadeHttp _facade;
  String _user, _token, _lastUpdate;
  bool _running;

  ChatNotifier(this._chatListen, this._facade, this._user, this._token)
  {
    Timer.periodic(const Duration(seconds: 1), update);
    _running = true;
    _lastUpdate = '0';
  }

  void update(Timer timer)
  {
    //Se foi solicitado, pause o Notifier:
    if(!_running)
      timer.cancel();

    _facade.getChats(_user, _token)
    .then((body) {
      var data = JSON.jsonDecode(body);
      Map map = Map();
      List list = List();

      if(data is Map)
      {
         map = data;
         list.add(map);
      }else
         list = data;

      if(list.isEmpty)
        return;

      map = list?.last;

      if(map == null)
        return;

      if(map['lastUpdate'] == null)
        return;
      
      //Se ocorreu uma atualização:
      if(map['lastUpdate'].compareTo(_lastUpdate) > 0)
      {
        _lastUpdate = map['lastUpdate'];

        if(_chatListen != null) 
          _chatListen(list);
      }
    })//Em caso de exceção, faz nada.
    .catchError((err) => print('Error(line: 73, , file: notifier): $err'));
  }

  //Para o notifier.
  void stop()
  {
    _running = false;
  }
}