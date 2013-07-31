package com.bingya.sys.web;

import com.bingya.sys.domain.TbArticle;
import org.springframework.roo.addon.web.mvc.controller.scaffold.RooWebScaffold;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/tbarticles")
@Controller
@RooWebScaffold(path = "tbarticles", formBackingObject = TbArticle.class)
public class TbArticleController {
}
