package com.leds.server;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

public interface ChatRepository extends CrudRepository<Chat, Long>{
    @Query("SELECT * FROM Chat c WHERE c.user0 == userId OR c.user1 == userId ORDER BY lastUpdate DESC")
    List<Chat> findByUser(Long userId);
}