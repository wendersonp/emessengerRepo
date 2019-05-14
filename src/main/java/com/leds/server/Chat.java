package com.leds.server;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;

@Entity
public class Chat{

    @Id
    @GeneratedValue
    @Column(columnDefinition = "INT")
    private long idChat;

    @Column(nullable = false, columnDefinition = "VARCHAR(45)")
    private String subject;

    @Column(nullable = false, columnDefinition = "TIMESTAMP")
    private LocalDateTime lastUpdate;

    @ManyToMany
    @JoinTable(name = "Chat_User")
    private List<User> users = new ArrayList<User>();

    protected Chat (){}

    public Chat (String subject, LocalDateTime lastUpdate, List<User> users){
        this.subject = subject;
        this.lastUpdate = lastUpdate;
        this.users.addAll(users);
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
     * @return the users
     */
    public List<User> getUsers() {
        return users;
    }

    /**
     * @param users the users to set
     */
    public void setUsers(List<User> users) {
        this.users.clear();
        this.users.addAll(users);
    }

}