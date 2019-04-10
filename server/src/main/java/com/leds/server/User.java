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

    


}