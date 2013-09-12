/**
 * 
 */
package com.bingya.service;

import java.io.Serializable;
import java.util.List;

import com.bingya.util.Page;


/**
 * @author huangjixin
 * 
 */
public interface IGenericService<T extends Serializable, PK extends Serializable> {

	/**
	 * 根据主键删除实体。
	 * @param id
	 */
	int deleteByPrimaryKey(Integer id);

	/**
	 * 插入实体。
	 * @param entity
	 * @return
	 */
	Integer insert(T entity);

	/**
	 * 查询所有实体。
	 * @return
	 */
	List<T> selectAll();

	/**
	 * 根据id获得查询数据库实体类。
	 * @param id
	 * @return
	 */
	T selectByPrimaryKey(Integer id);

	/**
	 * 更新实体类。
	 * @param entity
	 * @return
	 */
	int update(T entity);

	/**
	 * 分页查询。
	 * @param page
	 * @param key
	 * @param orderCondition
	 * @return
	 */
	Page query(Page page,String key,String orderCondition);
}
