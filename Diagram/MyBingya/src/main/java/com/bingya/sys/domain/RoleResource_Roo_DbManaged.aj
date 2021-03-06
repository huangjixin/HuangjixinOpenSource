// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.bingya.sys.domain;

import com.bingya.sys.domain.Resource;
import com.bingya.sys.domain.Role;
import com.bingya.sys.domain.RoleResource;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

privileged aspect RoleResource_Roo_DbManaged {
    
    @ManyToOne
    @JoinColumn(name = "resource_id", referencedColumnName = "id", nullable = false)
    private Resource RoleResource.resourceId;
    
    @ManyToOne
    @JoinColumn(name = "role_id", referencedColumnName = "id", nullable = false)
    private Role RoleResource.roleId;
    
    public Resource RoleResource.getResourceId() {
        return resourceId;
    }
    
    public void RoleResource.setResourceId(Resource resourceId) {
        this.resourceId = resourceId;
    }
    
    public Role RoleResource.getRoleId() {
        return roleId;
    }
    
    public void RoleResource.setRoleId(Role roleId) {
        this.roleId = roleId;
    }
    
}
