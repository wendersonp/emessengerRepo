package com.leds.server;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;

@Entity
public class Chat{

    @Id
    @GeneratedValue
    @Column(columnDefinition = "INT")
    private long idChat;

    @Column(nullable = false, columnDefinition = "VARCHAR(45)")
    private String subject;

    @Column(nullable = false, columnDefinition = "DATETIME")
    private LocalDateTime lastUpdate;

    @ManyToOne
    private User user0;

    @ManyToOne
    private User user1;

    public Chat (String subject, LocalDateTime lastUpdate, User user0, User user1){
        this.subject = subject;
        this.lastUpdate = lastUpdate;
        this.user0 = user0;
        this.user1 = user1;
    }

    /**
     * @return the idChat
     */
    public long getIdChat() {
        return idChat;
    }

    /**
     * @param idChat the idChat to set
     */
    public void setIdChat(long idChat) {
        this.idChat = idChat;
    }

    /**
     * @return the subject
     */
    public String getSubject() {
        return subject;
    }

    /**
     * @param subject the subject to set
     */
    public void setSubject(String subject) {
        this.subject = subject;
    }

    /**
     * @return the lastUpdate
     */
    public LocalDateTime getLastUpdate() {
        return lastUpdate;
    }

    /**
     * @param lastUpdate the lastUpdate to set
     */
    public void setLastUpdate(LocalDateTime lastUpdate) {
        this.lastUpdate = lastUpdate;
    }

    /**
     * @return the user0
     */
    public User getUser0() {
        return user0;
    }

    /**
     * @param user0 the user0 to set
     */
    public void setUser0(User user0) {
        this.user0 = user0;
    }

    /**
     * @return the user1
     */
    public User getUser1() {
        return user1;
    }

    /**
     * @param user1 the user1 to set
     */
    public void setUser1(User user1) {
        this.user1 = user1;
    }

}