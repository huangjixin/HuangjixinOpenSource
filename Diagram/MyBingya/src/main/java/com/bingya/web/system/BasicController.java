/**
 * 
 */
package com.bingya.web.system;

import java.io.IOException;
import java.io.UnsupportedEncodingException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;
import org.springframework.web.util.UriUtils;
import org.springframework.web.util.WebUtils;

/**
 * @author huangjixin
 * 
 */
public class BasicController {
	// ---------------------------------------------------
	// 常量（全部大写，用下划线分割），变量 （先常后私）
	// ---------------------------------------------------

	// ---------------------------------------------------
	// public 公有方法
	// ---------------------------------------------------

	// ---------------------------------------------------
	// protected 方法
	// ---------------------------------------------------
	/**
	 * 向页面输出json字符串。<br>
	 * 例如：json("a", 1, "b", 2)将会生成这样的json：{a:1, b:2}
	 */
	protected String json(Object object, HttpServletResponse httpServletResponse) {
		try {
			httpServletResponse.setCharacterEncoding("UTF-8");
			httpServletResponse.getWriter().println(object);
			httpServletResponse.getWriter().close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 将模型添加进去。
	 * 
	 * @param uiModel
	 * @param object
	 */
	protected void populateEditForm(Model uiModel, Object object) {
		String name = object.getClass().getName();
		int dotIndex = name.lastIndexOf(".");
		name = name.substring(dotIndex+1).toLowerCase();
		uiModel.addAttribute(name, object);
	}

	protected String encodeUrlPathSegment(String pathSegment,
			HttpServletRequest httpServletRequest) {
		String enc = httpServletRequest.getCharacterEncoding();
		if (enc == null) {
			enc = WebUtils.DEFAULT_CHARACTER_ENCODING;
		}
		try {
			pathSegment = UriUtils.encodePathSegment(pathSegment, enc);
		} catch (UnsupportedEncodingException uee) {
		}
		return pathSegment;
	}
	// ---------------------------------------------------
	// private 私有方法
	// ---------------------------------------------------
}
