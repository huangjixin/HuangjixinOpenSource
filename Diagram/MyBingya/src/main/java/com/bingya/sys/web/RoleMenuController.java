package com.bingya.sys.web;

import com.bingya.sys.domain.RoleMenu;
import org.springframework.roo.addon.web.mvc.controller.scaffold.RooWebScaffold;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/rolemenus")
@Controller
@RooWebScaffold(path = "rolemenus", formBackingObject = RoleMenu.class)
public class RoleMenuController {
}
