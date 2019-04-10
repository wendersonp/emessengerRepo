package com.leds.server;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;


@RestController
public class UserController{
    
    @Autowired
    UserRepository userRepo;
    
    @RequestMapping(value = "/user/signup")

    public User userSignUp(@RequestParam("name") String name, 
    @RequestParam("nickname") String nickname,
    @RequestParam("password") String password){
        User user = new User(name, nickname, password);
        userRepo.save(user);

        /*for(User userInList : userRepo.findAll()){
            System.out.println(userInList.getName().toString());
        }*/
        return user;
    } 

    @RequestMapping(value = "/user/login")

    public User userLogin(@RequestParam("nickname") String nickname,
    @RequestParam("password") String password){
        User user = userRepo.findByNickname(nickname);
        System.out.println(user);
        if(!(user == null) && user.getPassword().equals(password)){
            return user;
        }
        else{
            System.out.println(" Não passou na verificação");
            return new User("Error", "Error", "404");
        }
    }
} 