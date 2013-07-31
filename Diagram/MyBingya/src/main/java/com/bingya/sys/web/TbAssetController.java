package com.bingya.sys.web;

import com.bingya.sys.domain.TbAsset;
import org.springframework.roo.addon.web.mvc.controller.scaffold.RooWebScaffold;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/tbassets")
@Controller
@RooWebScaffold(path = "tbassets", formBackingObject = TbAsset.class)
public class TbAssetController {
}
