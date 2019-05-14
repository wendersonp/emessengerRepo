package com.leds.server;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

public interface ChatRepository extends CrudRepository<Chat, Long>{

    @Query("SELECT c FROM Chat c JOIN c.users cu WHERE cu.idUser = ?1")
    List<Chat> findByUsers(Long userId);
}