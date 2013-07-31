/**
 * 
 */
package com.bingya.web.system;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bingya.service.ICategoryService;
import com.bingya.util.Page;

/**
 * @author huangjixin
 * 
 */
@RequestMapping("/categorys")
@Controller
public class CategoryController extends BasicController {
	// ---------------------------------------------------
	// 常量（全部大写，用下划线分割），变量 （先常后私）
	// ---------------------------------------------------
	@Resource
	private ICategoryService categoryService;

	// ---------------------------------------------------
	// public 公有方法
	// ---------------------------------------------------

	/**
	 * 用于ajax调用的删除方法。
	 * 
	 * @param id
	 * @param httpServletRequest
	 * @param httpServletResponse
	 * @return
	 */
	@RequestMapping("deleteById")
	public String deleteById(
			@RequestParam(value = "id", required = true) String id,
			HttpServletRequest httpServletRequest,
			HttpServletResponse httpServletResponse) {
		int i = categoryService.deleteByPrimaryKey(id);
		return json(i, httpServletResponse);
	}

	@RequestMapping("getCategoryTree")
	public String getCategoryTree(HttpServletRequest httpServletRequest,
			HttpServletResponse httpServletResponse) {
		List<JSONObject> list = categoryService.getCategoryTree();
		return json(list, httpServletResponse);
	}

	@RequestMapping("getListByPage")
	@ResponseBody
	public Page getListByPage(
			@RequestParam("page") String page,
			@RequestParam("rows") String rows,
			@RequestParam("sidx") String sidx,
			@RequestParam("sord") String sord,
			@RequestParam(value = "isSearch", required = false) Boolean isSearch,
			@RequestParam(value = "searchField", required = false) String searchField,
			@RequestParam(value = "searchOper", required = false) String searchOper,
			@RequestParam(value = "searchString", required = false) String searchString,
			@RequestParam(value = "filters", required = false) String filters,
			HttpServletRequest request, HttpServletResponse response) {
		Integer pagePara = Integer.valueOf(page);
		Integer limit = Integer.valueOf(rows);
		Page resultPage = new Page();
		resultPage.setPage(pagePara);
		resultPage.setLimit(limit);
		resultPage.setStart(pagePara * limit - limit);
		resultPage = categoryService.query(resultPage, null, null);
		return resultPage;
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
		return "categorys/list";
	}
	// ---------------------------------------------------
	// protected 方法
	// ---------------------------------------------------

	// ---------------------------------------------------
	// private 私有方法
	// ---------------------------------------------------
}
