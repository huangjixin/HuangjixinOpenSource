package com.bingya.sys.domain;

import org.springframework.roo.addon.dbre.RooDbManaged;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.jpa.entity.RooJpaEntity;
import org.springframework.roo.addon.json.RooJson;
import org.springframework.roo.addon.tostring.RooToString;

@RooJavaBean
@RooToString
@RooJpaEntity(versionField = "", table = "role_resource")
@RooDbManaged(automaticallyDelete = true)
@RooJson(deepSerialize = true)
public class RoleResource {
}
