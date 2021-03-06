// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.bingya.sys.web;

import com.bingya.sys.domain.TbArticle;
import com.bingya.sys.web.TbArticleController;
import java.io.UnsupportedEncodingException;
import javax.servlet.http.HttpServletRequest;
import org.joda.time.format.DateTimeFormat;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.ui.Model;
import org.springframework.web.util.UriUtils;
import org.springframework.web.util.WebUtils;

privileged aspect TbArticleController_Roo_Controller {
    
    void TbArticleController.addDateTimeFormatPatterns(Model uiModel) {
        uiModel.addAttribute("tbArticle_createdate_date_format", DateTimeFormat.patternForStyle("M-", LocaleContextHolder.getLocale()));
    }
    
    void TbArticleController.populateEditForm(Model uiModel, TbArticle tbArticle) {
        uiModel.addAttribute("tbArticle", tbArticle);
        addDateTimeFormatPatterns(uiModel);
    }
    
    String TbArticleController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
        String enc = httpServletRequest.getCharacterEncoding();
        if (enc == null) {
            enc = WebUtils.DEFAULT_CHARACTER_ENCODING;
        }
        try {
            pathSegment = UriUtils.encodePathSegment(pathSegment, enc);
        } catch (UnsupportedEncodingException uee) {}
        return pathSegment;
    }
    
}
