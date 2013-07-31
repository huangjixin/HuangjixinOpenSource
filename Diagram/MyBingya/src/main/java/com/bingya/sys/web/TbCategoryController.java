package com.bingya.sys.web;

import com.bingya.sys.domain.TbCategory;
import org.springframework.roo.addon.web.mvc.controller.scaffold.RooWebScaffold;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/tbcategorys")
@Controller
@RooWebScaffold(path = "tbcategorys", formBackingObject = TbCategory.class)
public class TbCategoryController {
}
