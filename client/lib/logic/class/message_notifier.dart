import '../facade_http.dart';
import 'dart:async';
import 'dart:convert' as JSON;

typedef void MessageListen(List messages);

class MessageNotifier
{
  MessageListen _messageListen;
  FacadeHttp _facadeHttp;
  String _user;
  String _chatID, _lastMessage;
  bool _running;

  MessageNotifier(this._messageListen, this._facadeHttp, this._user, this._chatID)
  {
    _lastMessage = '0';
    _running = true;
    Timer.periodic(const Duration(seconds: 1), update);
  }

  void update(Timer timer)
  {
    if(!_running)
      timer.cancel();

      _facadeHttp.getMessage(_user, _chatID).then( (body){
        
        var data = JSON.jsonDecode(body);
        List list = [];
        Map message;

        if(data is Map)
        {
          message = data;
          list.add(message);
        }
        else if(data is List)
          list = data;

        if(list.isEmpty)
          return;
          
        message = list[0];

        if(message == null)
          return;

        if(message['sentTime'] == null)
          return;

        if(message['sentTime'].compareTo(_lastMessage) > 0)
        {
          _lastMessage = message['sentTime'];
          _messageListen(list);
        }
      })
      .catchError((err) => print('Error(line: 46, file: message_notifier): $err'));
  }

  void stop()
  {
    _running = false;
  }
}