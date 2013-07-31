package com.bingya.sys.web;

import com.bingya.sys.domain.RoleResource;
import org.springframework.roo.addon.web.mvc.controller.scaffold.RooWebScaffold;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/roleresources")
@Controller
@RooWebScaffold(path = "roleresources", formBackingObject = RoleResource.class)
public class RoleResourceController {
}
