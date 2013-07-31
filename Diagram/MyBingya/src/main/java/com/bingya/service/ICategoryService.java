/**
 * 
 */
package com.bingya.service;

import java.util.List;

import org.json.JSONObject;

import com.bingya.domain.system.Category;

/**
 * @author huangjixin
 *
 */
public interface ICategoryService extends IGenericService<Category, Integer> {
	/**
	 * 将数据库当中的目录对象获取并返回json树。
	 * @return
	 */
	List<JSONObject> getCategoryTree();
	
	/**
	 * 根据parentId查询列表对象。
	 * @param id
	 * @return
	 */
	List<Category> getByParentId(String id);
}
