// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.bingya.sys.domain;

import com.bingya.sys.domain.Menu;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

privileged aspect Menu_Roo_Jpa_Entity {
    
    declare @type: Menu: @Entity;
    
    declare @type: Menu: @Table(name = "menu");
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id", length = 120)
    private String Menu.id;
    
    public String Menu.getId() {
        return this.id;
    }
    
    public void Menu.setId(String id) {
        this.id = id;
    }
    
}