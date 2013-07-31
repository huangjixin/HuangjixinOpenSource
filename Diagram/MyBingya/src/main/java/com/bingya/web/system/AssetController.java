/**
 * 
 */
package com.bingya.web.system;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * @author huangjixin
 * 
 */
@RequestMapping("/assets")
@Controller
public class AssetController extends BasicController {
	// ---------------------------------------------------
	// 常量（全部大写，用下划线分割），变量 （先常后私）
	// ---------------------------------------------------

	// ---------------------------------------------------
	// public 公有方法
	// ---------------------------------------------------

	/**
	 * 跳转到用户列表页面。
	 * @param page
	 * @param size
	 * @param uiModel
	 * @return
	 */
	@RequestMapping(produces = "text/html")
	public String list(
			@RequestParam(value = "page", required = false) Integer page,
			@RequestParam(value = "size", required = false) Integer size,
			Model uiModel) {
		return "assets/list";
	}
	// ---------------------------------------------------
	// protected 方法
	// ---------------------------------------------------

	// ---------------------------------------------------
	// private 私有方法
	// ---------------------------------------------------
}
