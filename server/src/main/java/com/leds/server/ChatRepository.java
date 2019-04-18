package com.leds.server;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

public interface ChatRepository extends CrudRepository<Chat, Long>{
    @Query("SELECT c FROM Chat c WHERE c.user0.idUser = ?1 OR c.user1.idUser = ?1 ORDER BY c.lastUpdate DESC")
    List<Chat> findByUsers(Long userId);
}