package com.leds.server;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;


@RestController
public class ServerController{
    
    @Autowired
    UserRepository userRepo;

    @Autowired
    ChatRepository chatRepo;

    @Autowired
    MessageRepository messageRepo;
    
    @RequestMapping(value = "/user/signup", method = RequestMethod.POST)

    public User userSignUp(@RequestParam("name") String name, 
    @RequestParam("nickname") String nickname,
    @RequestParam("password") String password){
        User user = new User(name, nickname, password);
        userRepo.save(user);
        return user;
    } 

    @RequestMapping(value = "/user/login", method = RequestMethod.POST)

    public User userLogin(@RequestParam("nickname") String nickname,
    @RequestParam("password") String password){
        User user = userRepo.findByNickname(nickname);
        System.out.println(user);
        if(!(user == null) && user.getPassword().equals(password)){
            user.setLoggedIn(true);
            return user;
        }
        else{
            System.out.println(" Não passou na verificação");
            return new User("Error", "Error", "404");
        }
    }

    @RequestMapping(value = "/chat/create", method = RequestMethod.POST)
    public Chat chatCreate(@RequestParam("subject") String subject, @RequestParam("creator_nickname") String creatorNickname, 
    @RequestParam("destination_nickname") String destinationNickname){
        User user0 = userRepo.findByNickname(creatorNickname);
        User user1 = userRepo.findByNickname(destinationNickname);

        if(user0 != null && user1 != null && user0.getLoggedIn()){
           Chat chat = new Chat(subject, LocalDateTime.now(), user0, user1);
           chatRepo.save(chat);
           return chat;
        }
        return null;
    }

    @RequestMapping(value = "/chat/getlist", method = RequestMethod.GET)
    public List<Chat> chatList(@RequestParam("nickname") String nickname){
        User user = userRepo.findByNickname(nickname);
        if(user != null && user.getLoggedIn()){
            return chatRepo.findByUsers(user.getIdUser());
        }
        return null;
    }

    @RequestMapping(value = "/message/send", method = RequestMethod.POST)
    public Message messageSend(@RequestParam("sender_nickname") String senderNickname, 
        @RequestParam("chat_id") Long chatId,
        @RequestParam("text_message") String textMessage){
            Chat chat = chatRepo.findById(chatId).get();
            if(senderNickname == chat.getUser0().getNickname()){
                Message message = new Message(LocalDateTime.now(), textMessage, chat.getUser0(), chat);
                messageRepo.save(message);
                return message;
            }
            else if(senderNickname == chat.getUser1().getNickname()){
                Message message = new Message(LocalDateTime.now(), textMessage, chat.getUser1(), chat);
                messageRepo.save(message);
                return message;
            }
            else{
                return null;
            }
        }
    


} 