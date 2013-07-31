package com.bingya.sys.web;

import com.bingya.service.system.IMenuService;
import com.bingya.sys.domain.Menu;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.roo.addon.web.mvc.controller.scaffold.RooWebScaffold;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@RequestMapping("/menus")
@Controller
@RooWebScaffold(path = "menus", formBackingObject = Menu.class)
public class MenuController {

    @Resource
    private IMenuService menuService;

    @RequestMapping("getMenu")
    @ResponseBody
    public ResponseEntity<java.lang.String> getMenu(HttpServletRequest httpServletRequest) {
        String basePath = httpServletRequest.getScheme() + "://" + httpServletRequest.getServerName() + ":" + httpServletRequest.getServerPort() + httpServletRequest.getContextPath() + "/";
        System.out.println(basePath);
        HttpHeaders responseHeaders;
        responseHeaders = new HttpHeaders();
        String menuStr = menuService.getMenuXmlStr(basePath);
        return new ResponseEntity<String>(menuStr, responseHeaders, HttpStatus.OK);
    }

    @RequestMapping("showMenu")
    @ResponseBody
    public Menu showMenu() {
        Menu menu = new Menu();
        menu.setName("test menu");
        return menu;
    }
}
