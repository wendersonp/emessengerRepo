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
        
        List list = JSON.jsonDecode(body);
        Map message = list.last;

        if(message == null)
          return;

        if(message['sentTime'] == null)
          return;

        if(message['sentTime'].compareTo(_lastMessage) > 0)
        {
          _lastMessage = message['sentTime'];
          _messageListen(list);
        }
      });
  }

  void stop()
  {
    _running = false;
  }
}