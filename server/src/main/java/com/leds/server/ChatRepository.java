package com.leds.server;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface ChatRepository extends JpaRepository<Chat, Long>{
    @Query("SELECT c FROM Chat c WHERE c.user0 = userId OR c.user1 = ?1 ORDER BY c.lastUpdate DESC")
    List<Chat> findByUsers(Long userId);
}