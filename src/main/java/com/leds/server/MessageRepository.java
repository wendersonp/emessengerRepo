package com.leds.server;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;


public interface MessageRepository extends CrudRepository<Message, Long>{
    List<Message> findByChatFrOrderBySentTimeDesc(Chat chat);

    @Query("SELECT m FROM Message m JOIN m.receiverList mr WHERE mr.idUser = ?1 AND m.chatFr.idChat = ?2 ORDER BY m.sentTime DESC")
    List<Message> getUserMessages(Long idUser, Long idChatFr);
}