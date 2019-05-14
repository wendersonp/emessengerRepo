package com.leds.server;

import java.time.LocalDateTime;
import java.util.ArrayList;
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
    public String userSignUp(@RequestParam("name") String name, 
    @RequestParam("nickname") String nickname,
    @RequestParam("password") String password){
        User user = new User(name, nickname, password);
        userRepo.save(user);
        return "Signup Success";
    } 



    @RequestMapping(value = "/user/login", method = RequestMethod.PUT)

    public String userLogin(@RequestParam("nickname") String nickname,
    @RequestParam("password") String password){
        User user = userRepo.findByNickname(nickname);
        if(!(user == null) && user.getPassword().equals(password)){
            user.setLoggedIn(true);
            userRepo.save(user);
            return "Login Success";
        }
        else{
            return "Login Error";
        }
    }

    @RequestMapping(value = "/logged/user/get", method = RequestMethod.GET)
    public User getUser(@RequestParam("nickname") String nickname){
        User user = userRepo.findByNickname(nickname);
        return user;
    }

    @RequestMapping(value = "/user/logout", method = RequestMethod.PUT)
    public String userLogout(@RequestParam("nickname") String nickname){
        User user = userRepo.findByNickname(nickname);
        if(!(user == null) && user.getLoggedIn() == true){
            user.setLoggedIn(false);
            userRepo.save(user);
            return "Logout Success";
        }
        else{
            return "Logout Error";
        }
    }

    @RequestMapping(value = "/logged/chat/create", method = RequestMethod.POST)
    public Chat chatCreate(@RequestParam("subject") String subject, @RequestParam("users_nicknames") List<String> usersNicknames){
        
        List<User> userList = new ArrayList<User>();
        Boolean firstUserRegistrated = false;

        for (String userNickname  : usersNicknames) {
            User user = userRepo.findByNickname(userNickname);
            if(user != null){
                if(firstUserRegistrated == false){
                    if(user.getLoggedIn() == true){
                        userList.add(user);
                        firstUserRegistrated = true;
                    }
                    else{
                        System.out.println("User not logged in");
                        return null;
                    }
                }
                else{
                    userList.add(user);
                }
            }
        }


        if(userList.size() > 1){
           Chat chat = new Chat(subject, LocalDateTime.now(), userList);
           chatRepo.save(chat);
           return chat;
        }
        return null;
    }

    @RequestMapping(value = "/logged/chat/getlist", method = RequestMethod.GET)
    public List<Chat> chatList(@RequestParam("nickname") String nickname){
        User user = userRepo.findByNickname(nickname);
        if(user != null && user.getLoggedIn() == true){
            List<Chat> chatList = chatRepo.findByUsers(user.getIdUser());
            return chatList;
        }
        return null;
    }

    @RequestMapping(value = "/logged/message/send", method = RequestMethod.POST)
    public Message sendMessage(@RequestParam("sender_nickname") String senderNickname,
    @RequestParam("chat_id") Long chatId,
    @RequestParam("text_message") String textMessage){

        Chat chat = chatRepo.findById(chatId).get();
        User senderUser = userRepo.findByNickname(senderNickname);

        if(senderUser != null && senderUser.getLoggedIn() == true){
            Boolean senderInChat = false;
            for(User user: chat.getUsers()){
                if(user.getIdUser() == senderUser.getIdUser()){
                    senderInChat = true;
                }
            }

            if(senderInChat){
                LocalDateTime updateTime = LocalDateTime.now();

                Message message = new Message(updateTime, textMessage, senderUser, chat, chat.getUsers());
                messageRepo.save(message);
                
                chat.setLastUpdate(updateTime);
                chatRepo.save(chat);
                return message;
            }
            return null;
        }
        return null;
    }
    
    @RequestMapping(value = "/logged/message/getlist", method = RequestMethod.GET)
    public List<Message> getChatMessages(@RequestParam("nickname") String nickname, 
    @RequestParam("chat_id") Long chatId){
        User user = userRepo.findByNickname(nickname);
        
        if(user != null && user.getLoggedIn() == true){
            return messageRepo.getUserMessages(user.getIdUser(), chatId);
        }
        return null;
    }

    @RequestMapping(value="/logged/chat/addusers", method=RequestMethod.GET)
    public Chat addUsersToChat(@RequestParam("users_nicknames") List<String> usersNicknames, @RequestParam("chat_id") Long idChat){
        Chat chat = chatRepo.findById(idChat).get();
        List<User> chatUsers = new ArrayList<User>();
        chatUsers.addAll(chat.getUsers());
        for(String nickname: usersNicknames){
            User user = userRepo.findByNickname(nickname);
            if(user != null){
                chatUsers.add(user);
            }
        }
        chat.setUsers(chatUsers);
        chatRepo.save(chat);
        return chat;
    }
    

    /*@RequestMapping("/secured")
    public String secured(){
        return "Utilizando HTTPS = OK";
    }*/

} 