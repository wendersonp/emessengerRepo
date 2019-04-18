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
    
    @RequestMapping(value = "/user/signup", method = RequestMethod.GET)

    public User userSignUp(@RequestParam("name") String name, 
    @RequestParam("nickname") String nickname,
    @RequestParam("password") String password){
        User user = new User(name, nickname, password);
        userRepo.save(user);
        System.out.println("Chegou aqui");
        return user;
    } 

    @RequestMapping(value = "/user/login", method = RequestMethod.GET)

    public User userLogin(@RequestParam("nickname") String nickname,
    @RequestParam("password") String password){
        User user = userRepo.findByNickname(nickname);
        if(!(user == null) && user.getPassword().equals(password)){
            user.setLoggedIn(true);
            userRepo.save(user);
            return user;
        }
        else{
            System.out.println(" Não passou na verificação");
            return new User("Error", "Error", "404");
        }
    }

    @RequestMapping(value = "/chat/create", method = RequestMethod.GET)
    public String chatCreate(@RequestParam("subject") String subject, @RequestParam("creator_nickname") String creatorNickname, 
    @RequestParam("destination_nickname") String destinationNickname){
        User user0 = userRepo.findByNickname(creatorNickname);
        User user1 = userRepo.findByNickname(destinationNickname);


        if(user0 != null && user1 != null && user0.getLoggedIn() == true){
           Chat chat = new Chat(subject, LocalDateTime.now(), user0, user1);
           chatRepo.save(chat);
           return "Success";
        }
        return "Fail";
    }

    @RequestMapping(value = "/chat/getlist", method = RequestMethod.GET)
    public List<Chat> chatList(@RequestParam("nickname") String nickname){
        User user = userRepo.findByNickname(nickname);
        if(user != null && user.getLoggedIn() == true){
            List<Chat> chatList = chatRepo.findByUsers(user.getIdUser());
            return chatList;
        }
        return null;
    }

    @RequestMapping(value = "/message/send", method = RequestMethod.GET)
    public Message sendMessage(@RequestParam("sender_nickname") String senderNickname,
    @RequestParam("chat_id") Long chatId,
    @RequestParam("text_message") String textMessage){
        Chat chat = chatRepo.findById(chatId).get();
        User senderUser = userRepo.findByNickname(senderNickname);
        if(senderUser != null && senderUser.getLoggedIn() == true){
            if(senderUser.getIdUser() == chat.getUser0().getIdUser() || senderUser.getIdUser() == chat.getUser1().getIdUser()){
                LocalDateTime updateTime = LocalDateTime.now();
                Message message = new Message(updateTime, textMessage, senderUser, chat);
                messageRepo.save(message);
                chat.setLastUpdate(updateTime);
                chatRepo.save(chat);
                return message;
            }
            return null;
        }
        return null;
    }
    
    @RequestMapping(value = "/message/getlist", method = RequestMethod.GET)
    public List<Message> getChatMessages(@RequestParam("nickname") String nickname, 
    @RequestParam("chat_id") Long chatId){
        User user = userRepo.findByNickname(nickname);
        if(user != null && user.getLoggedIn() == true){
            Chat chat = chatRepo.findById(chatId).get();
            if(chat.getUser0().getNickname().equals(nickname) || chat.getUser1().getNickname().equals(nickname)){
                return messageRepo.findByChatFrOrderBySentTimeDesc(chat);
            }
        }
        return null;
    }

    @RequestMapping("/secured")
    public String secured(){
        return "Utilizando HTTPS = OK";
    }

} 