package com.leds.server;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

public interface UserRepository extends CrudRepository<User, Long>{

    User findByNickname(String nickname);
    
    @Modifying
    @Query("UPDATE User u SET u.loggedIn = value WHERE u.id = usId")
    void setLoggedInById(Boolean value, Long usId);
}