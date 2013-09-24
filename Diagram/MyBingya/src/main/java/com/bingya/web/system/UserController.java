/**
 * 
 */
package com.bingya.web.system;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.bingya.domain.system.User;
import com.bingya.service.system.IUserService;

/**
 * @author huangjixin
 * 
 */
@RequestMapping("/users")
@Controller
public class UserController extends BasicController {
	// ---------------------------------------------------
	// 常量（全部大写，用下划线分割），变量 （先常后私）
	// ---------------------------------------------------
	@Resource
	private IUserService userService;

	// ---------------------------------------------------
	// public 公有方法
	// ---------------------------------------------------

	@RequestMapping("deleteById")
	public String deleteById(
			@RequestParam(value = "id", required = true) Integer id,
			HttpServletRequest httpServletRequest,
			HttpServletResponse httpServletResponse) {
		int i = userService.deleteByPrimaryKey(id);
		return json(i, httpServletResponse);
	}

	@RequestMapping("update")
	public String update(@Valid User user, BindingResult bindingResult,
			Model uiModel, HttpServletRequest httpServletRequest,
			HttpServletResponse httpServletResponse) {

		int i = userService.update(user);
		// return "redirect:/menus/"
		// + encodeUrlPathSegment("" + i, httpServletRequest);
		return "redirect:/users";
	}

	@RequestMapping(method = RequestMethod.POST, produces = "text/html")
	public String create(@Valid User user, BindingResult bindingResult,
			Model uiModel, HttpServletRequest httpServletRequest) {
		if (bindingResult.hasErrors()) {
			populateEditForm(uiModel, user);
			return "menus/create";
		}
		uiModel.asMap().clear();
		Integer i = userService.insert(user);
		// return "redirect:/menus/"
		// + encodeUrlPathSegment("" + i, httpServletRequest);
		return "redirect:/users";
	}

	@RequestMapping(params = "form", produces = "text/html")
	public String createForm(Model uiModel) {
		User user = new User();
		populateEditForm(uiModel, user);
		return "users/create";
	}

	/**
	 * 跳转到用户列表页面。
	 * 
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
		return "users/list";
	}
	// ---------------------------------------------------
	// protected 方法
	// ---------------------------------------------------

	// ---------------------------------------------------
	// private 私有方法
	// ---------------------------------------------------
}
