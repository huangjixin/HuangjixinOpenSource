/**
 * 
 */
package com.bingya.service.system.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.annotation.Resource;

import org.dom4j.Attribute;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.json.JSONObject;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bingya.dao.system.MenuMapper;
import com.bingya.dao.system.RoleMenuMapper;
import com.bingya.domain.system.Menu;
import com.bingya.domain.system.MenuExample;
import com.bingya.domain.system.RoleMenu;
import com.bingya.domain.system.RoleMenuExample;
import com.bingya.service.system.IMenuService;
import com.bingya.util.Page;

import flexjson.JSONException;

/**
 * @author huangjixin
 * 
 */
@Transactional
@Service(value = "menuService")
public class MenuServiceImpl implements IMenuService {

	// ---------------------------------------------------
	// 常量（全部大写，用下划线分割），变量 （先常后私）
	// ---------------------------------------------------
	@Resource
	private MenuMapper menuMapper;
	@Resource
	private RoleMenuMapper roleMenuMapper;

	private String url;

	// ---------------------------------------------------
	// public 公有方法
	// ---------------------------------------------------
	/*
	 * 根据Id删除菜单，子菜单也会被删除。
	 * 
	 * @see
	 * com.mvcbasic.service.sys.IGenericService#deleteByPrimaryKey(java.lang
	 * .Integer)
	 */
	@Override
	@Transactional
	public int deleteByPrimaryKey(String id) {
		// 外键删除；
		RoleMenuExample roleMenuExample = new RoleMenuExample();
		roleMenuExample.createCriteria().andMenuIdEqualTo(id);
		List<RoleMenu> roleMenuList = roleMenuMapper
				.selectByExample(roleMenuExample);
		for (RoleMenu roleMenu : roleMenuList) {
			roleMenuMapper.deleteByPrimaryKey(roleMenu.getId());
		}

		List<Menu> menuList = getByParentId(id);
		for (Menu menu : menuList) {
			deleteByPrimaryKey(menu.getId());
		}
		// 外键删除完毕；
		int i = menuMapper.deleteByPrimaryKey(id);
		return i;
	}

	/*
	 * 添加菜单。
	 * 
	 * @see
	 * com.mvcbasic.service.sys.IGenericService#insert(java.io.Serializable)
	 */
	@Override
	public String insert(Menu entity) {
		Date date = new Date();
		Long time = date.getTime();
		entity.setId("" + time);
		if ("".equals(entity.getParentid())) {
			entity.setParentid(null);
		}
		int i = menuMapper.insertSelective(entity);
		if (i == 0) {
			return "" + i;
		}
		return entity.getId();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.mvcbasic.service.sys.IGenericService#selectAll()
	 */
	@Override
	public List<Menu> selectAll() {
		return menuMapper.selectByExample(null);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.mvcbasic.service.sys.IGenericService#selectByPrimaryKey(java.lang
	 * .Integer)
	 */
	@Override
	public Menu selectByPrimaryKey(String id) {

		return menuMapper.selectByPrimaryKey(id);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.mvcbasic.service.sys.IGenericService#update(java.io.Serializable)
	 */
	@Override
	public int update(Menu entity) {
		return menuMapper.updateByExampleSelective(entity, null);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.mvcbasic.service.sys.IGenericService#query(com.mvcbasic.util.Page,
	 * java.lang.String, java.lang.String)
	 */
	@Override
	public Page query(Page page, String key, String orderCondition) {
		key = "%" + key + "%";
		MenuExample menuExample = new MenuExample();
		// menuExample.createCriteria().andDescriptionLike(key);
		menuExample.setPage(page);
		int total = menuMapper.countByExample(menuExample);
		page.setTotal(total);
		List<Menu> list = menuMapper.selectByExample(menuExample);
		page.setRows(list);
		return page;
	}

	@Override
	public List getMenuTree() {
		MenuExample menuExample = new MenuExample();
		menuExample.createCriteria().andParentidIsNull();

		List<Menu> list = menuMapper.selectByExample(menuExample);
		List children = new ArrayList();
		try {
			for (Menu object : list) {
				JSONObject jsonObject;

				jsonObject = searialMenu(object);
				children.add(jsonObject);
			}
		} catch (org.json.JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return children;
	}

	@Override
	public List<Menu> getByParentId(String id) {
		MenuExample menuExample = new MenuExample();
		menuExample.createCriteria().andParentidEqualTo(id);
		return menuMapper.selectByExample(menuExample);
	}

	@Override
	public String getMenuXmlStr(String basePath) {
		this.url = basePath;

		MenuExample menuExample = new MenuExample();
		menuExample.createCriteria().andParentidIsNull();

		Document doc = DocumentHelper.createDocument();
		Element root = doc.addElement("ul");
		List<Menu> list = menuMapper.selectByExample(menuExample);
		for (Menu object : list) {
			Element element = searialMenuToElement(object, root, 0);
		}
		return doc.asXML();
	}

	// ---------------------------------------------------
	// protected 方法
	// ---------------------------------------------------

	// ---------------------------------------------------
	// private 私有方法
	// ---------------------------------------------------

	private JSONObject searialMenu(Menu menu) throws org.json.JSONException {
		JSONObject jsonObject = new JSONObject();
		try {
			jsonObject.put("id", menu.getId());
			jsonObject.put("parentid", menu.getParentid());
			jsonObject.put("name", menu.getName());

			List list = searialChild(menu);
			if (null != list) {
				jsonObject.put("children", list);
			}

		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return jsonObject;
	}

	private List searialChild(Menu menu) {
		List children = null;
		List<Menu> list = getByParentId(menu.getId());
		if (list != null && list.size() > 0) {
			children = new ArrayList();
		}
		try {
			for (Menu object : list) {
				JSONObject jsonObject = searialMenu(object);
				children.add(jsonObject);
			}
		} catch (Exception e) {

		}
		return children;
	}

	/**
	 * 序列化菜单为Element。
	 * 
	 * @param menu
	 * @return
	 */
	private Element searialMenuToElement(Menu menu, Element parentEle,
			Integer index) {
		Element element = parentEle.addElement("li");
		Element hrefElement = element.addElement("a");
		hrefElement.addText(menu.getName());
		if (null != menu.getPath()) {
			hrefElement.addAttribute("href", url + menu.getPath());
		} else {
			hrefElement.addAttribute("href", url + "#");
		}

		searialChildToElement(menu, element, index);

		return element;
	}

	private Element searialChildToElement(Menu menu, Element parentEle,
			Integer index) {
		Element element = null;

		List<Menu> list = getByParentId(menu.getId());
		if (list != null && list.size() > 0) {
			Element hrefElement = parentEle.element("a");
			hrefElement.addAttribute("class", "sub" + index);
			Attribute attribute = hrefElement.attribute("class");
			// if(attribute == null){
			// parentEle.addAttribute("class", "parent");
			// }
			element = parentEle.addElement("ul");

			for (Menu object : list) {
				searialMenuToElement(object, element, index + 1);
			}
		}

		return element;
	}

}
// 不使用Spring，怎样能在Listener启动的Thread中获取web目录，还真不完全确定。其实我觉得实际代码也很简单。
// 就是基于普通的listener，然后在listener中获取web目录并放到JRE全局变量中。
//
// 但使用Spring，就可以用一种比较优雅的方式来获取了。
//
// 在web.xml中的<web-app>节点内加入：
//
//
// <context-param>
// <param-name>webAppRootKey</param-name>
// <param-value>tansungWeb.root</param-value>
// </context-param>
// <listener>
// <listener-class>org.springframework.web.util.WebAppRootListener</listener-class>
// </listener>
//
// 然后在普通的Java类中（不是action中），就可以通过System.getProperty("tansungWeb.root")获取了web根目录了。
//
// 然后再拼凑路径的时候，最好不要直接使用/或者\，最好使用File.separatorChar
// 参考：http://blog.csdn.net/hellostory/archive/2010/12/30/6106930.aspx
//
// 这样的做法，适用于Spring配置中启动的线程需要获取web目录。例如删除临时文件的线程，定时发送邮件的线程。