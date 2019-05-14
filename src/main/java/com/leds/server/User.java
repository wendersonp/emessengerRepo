package com.leds.server;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Entity
public class User{

    @Id //Chave-Primaria
    @GeneratedValue //Auto-Incremento
    @Column(columnDefinition = "INT")
    private long idUser;

    @Column(nullable = false, columnDefinition = "VARCHAR(40)")
    private String name;

    @Column(nullable = false, unique = true, columnDefinition = "VARCHAR(40)")
    private String nickname;

    @Column(nullable = false, columnDefinition = "VARCHAR(40)")
    private String password;

    @Column(nullable = false, columnDefinition = "BIT")
    private Boolean loggedIn = false;

    protected User(){}

    public User(String name, String nickname, String password){
        this.name = name;
        this.nickname = nickname;
        this.password = password;
    }
    /**
     * @return the id
     */
    public long getIdUser() {
        return idUser;
    }

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @return the nickname
     */
    public String getNickname() {
        return nickname;
    }

    /**
     * @return the password
     */
    public String getPassword() {
        return password;
    }

    /**
     * @param idUser the idUser to set
     */
    public void setIdUser(long idUser) {
        this.idUser = idUser;
    }

    /**
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * @param nickname the nickname to set
     */
    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    /**
     * @param password the password to set
     */
    public void setPassword(String password) {
        this.password = password;
    }

    /**
     * @return the loggedIn
     */
    public Boolean getLoggedIn() {
        return loggedIn;
    }

    /**
     * @param loggedIn the loggedIn to set
     */
    public void setLoggedIn(Boolean loggedIn) {
        this.loggedIn = loggedIn;
    }

    


}