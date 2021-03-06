// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.bingya.sys.domain;

import com.bingya.sys.domain.Menu;
import flexjson.JSONDeserializer;
import flexjson.JSONSerializer;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

privileged aspect Menu_Roo_Json {
    
    public String Menu.toJson() {
        return new JSONSerializer().exclude("*.class").deepSerialize(this);
    }
    
    public static Menu Menu.fromJsonToMenu(String json) {
        return new JSONDeserializer<Menu>().use(null, Menu.class).deserialize(json);
    }
    
    public static String Menu.toJsonArray(Collection<Menu> collection) {
        return new JSONSerializer().exclude("*.class").deepSerialize(collection);
    }
    
    public static Collection<Menu> Menu.fromJsonArrayToMenus(String json) {
        return new JSONDeserializer<List<Menu>>().use(null, ArrayList.class).use("values", Menu.class).deserialize(json);
    }
    
}
