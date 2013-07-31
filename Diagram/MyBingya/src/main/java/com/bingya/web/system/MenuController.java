package com.bingya.web.system;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bingya.domain.system.Menu;
import com.bingya.service.system.IMenuService;
import com.bingya.util.Page;

@RequestMapping("/menus")
@Controller
public class MenuController extends BasicController {

	@Resource
	private IMenuService menuService;

	@RequestMapping("getMenu")
	public String getMenu(HttpServletRequest httpServletRequest,
			HttpServletResponse httpServletResponse) {
		String basePath = httpServletRequest.getScheme() + "://"
				+ httpServletRequest.getServerName() + ":"
				+ httpServletRequest.getServerPort()
				+ httpServletRequest.getContextPath() + "/";
		String menuStr = menuService.getMenuXmlStr(basePath);
		return json(menuStr, httpServletResponse);
	}

	@RequestMapping("getMenuTree")
	public String getMenuTree(HttpServletRequest httpServletRequest,
			HttpServletResponse httpServletResponse) {
		List<JSONObject> list = menuService.getMenuTree();
		return json(list, httpServletResponse);
	}

	@RequestMapping("deleteById")
	public String deleteById(
			@RequestParam(value = "id", required = true) String id,
			HttpServletRequest httpServletRequest,
			HttpServletResponse httpServletResponse) {
		int i = menuService.deleteByPrimaryKey(id);
		return json(i, httpServletResponse);
	}

	@RequestMapping("update")
	public String update(
			@RequestParam(value = "id", required = true) String id,
			@RequestParam(value = "name", required = true) String name,
			@RequestParam(value = "parentId", required = true) String parentId,
			HttpServletRequest httpServletRequest,
			HttpServletResponse httpServletResponse) {
		Menu menu = menuService.selectByPrimaryKey(id);
		menu.setName(name);
		menu.setParentid(parentId);
		int i = menuService.update(menu);
		return json(i, httpServletResponse);
	}

	@RequestMapping("getMenuListByPage")
	@ResponseBody
	public Page getMenuListByPage(
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
		resultPage = menuService.query(resultPage, null, null);
		return resultPage;
	}

	@RequestMapping(method = RequestMethod.POST, produces = "text/html")
	public String create(@Valid Menu menu, BindingResult bindingResult,
			Model uiModel, HttpServletRequest httpServletRequest) {
		if (bindingResult.hasErrors()) {
			populateEditForm(uiModel, menu);
			return "menus/create";
		}
		uiModel.asMap().clear();
		String i = menuService.insert(menu);
//		return "redirect:/menus/"
//				+ encodeUrlPathSegment("" + i, httpServletRequest);
		return "redirect:/menus";
	}

	@RequestMapping(params = "form", produces = "text/html")
	public String createForm(Model uiModel) {
		Menu menu = new Menu();
		menu.setName("test");
		populateEditForm(uiModel, menu);
		return "menus/create";
	}

	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = "text/html")
	public String delete(@PathVariable("id") String id,
			@RequestParam(value = "page", required = false) Integer page,
			@RequestParam(value = "size", required = false) Integer size,
			Model uiModel) {
		menuService.deleteByPrimaryKey(id);
		uiModel.asMap().clear();
		uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
		uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
		return "redirect:/menus";
	}

	@RequestMapping(value = "/{id}", produces = "text/html")
	public String show(@PathVariable("id") String id, Model uiModel) {
		uiModel.addAttribute("menu", menuService.selectByPrimaryKey(id));
//		uiModel.addAttribute("itemId", id);
		return "menus/show";
	}

	@RequestMapping(produces = "text/html")
	public String list(
			@RequestParam(value = "page", required = false) Integer page,
			@RequestParam(value = "size", required = false) Integer size,
			Model uiModel) {
		return "menus/list";
	}
}
