package com.bingya.sys.web;

import com.bingya.sys.domain.TbComment;
import org.springframework.roo.addon.web.mvc.controller.scaffold.RooWebScaffold;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/tbcomments")
@Controller
@RooWebScaffold(path = "tbcomments", formBackingObject = TbComment.class)
public class TbCommentController {
}
