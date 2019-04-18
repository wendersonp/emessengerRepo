package com.leds.server;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;

@Entity
public class Message{
    @Id
    @GeneratedValue
    @Column(columnDefinition = "INT")
    private long idMessage;

    @Column(nullable = false, columnDefinition = "DATETIME")
    private LocalDateTime sentTime;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String textMessage;

    @ManyToOne
    private User senderUser;

    @ManyToOne
    private Chat chatFr;

    public Message (LocalDateTime sentTime, String textMessage, User senderUser, Chat chatFr){
        this.sentTime = sentTime;
        this.textMessage = textMessage;
        this.senderUser = senderUser;
        this.chatFr = chatFr;
    }

    protected Message (){}

    /**
     * @return the idMessage
     */
    public long getIdMessage() {
        return idMessage;
    }

    /**
     * @param idMessage the idMessage to set
     */
    public void setIdMessage(long idMessage) {
        this.idMessage = idMessage;
    }

    /**
     * @return the sentTime
     */
    public LocalDateTime getSentTime() {
        return sentTime;
    }

    /**
     * @param sentTime the sentTime to set
     */
    public void setSentTime(LocalDateTime sentTime) {
        this.sentTime = sentTime;
    }

    /**
     * @return the textMessage
     */
    public String getTextMessage() {
        return textMessage;
    }

    /**
     * @param textMessage the textMessage to set
     */
    public void setTextMessage(String textMessage) {
        this.textMessage = textMessage;
    }

    /**
     * @return the senderUser
     */
    public User getSenderUser() {
        return senderUser;
    }

    /**
     * @param senderUser the senderUser to set
     */
    public void setSenderUser(User senderUser) {
        this.senderUser = senderUser;
    }

    /**
     * @return the chatFrom
     */
    public Chat getChatFr() {
        return chatFr;
    }

    /**
     * @param chatFrom the chatFrom to set
     */
    public void setChatFr(Chat chatFr) {
        this.chatFr = chatFr;
    }
}
