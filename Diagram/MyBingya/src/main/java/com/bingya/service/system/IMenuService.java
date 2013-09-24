package com.bingya.service.system;

import java.util.List;

import com.bingya.domain.system.Menu;
import com.bingya.service.IGenericService;

public interface IMenuService extends IGenericService<Menu, Integer> {
	List getMenuTree();

	List<Menu> getByParentId(Integer id);
	
	String getMenuXmlStr(String basePath);
}
