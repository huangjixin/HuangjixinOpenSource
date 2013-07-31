/**
 * 
 */
package com.bingya.service.system.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bingya.dao.system.ResourceMapper;
import com.bingya.domain.system.Resource;
import com.bingya.domain.system.ResourceExample;
import com.bingya.service.system.IResourceService;
import com.bingya.util.Page;

/**
 * @author huangjixin
 * 
 */
@Transactional
@Service(value = "resourceService")
public class ResourceServiceImpl implements IResourceService {
	// ---------------------------------------------------
	// 常量（全部大写，用下划线分割），变量 （先常后私）
	// ---------------------------------------------------
	@Autowired(required=true)
	private ResourceMapper resourceMapper;

	// ---------------------------------------------------
	// public 公有方法
	// ---------------------------------------------------

	// ---------------------------------------------------
	// protected 方法
	// ---------------------------------------------------

	// ---------------------------------------------------
	// private 私有方法
	// ---------------------------------------------------
	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.bingya.service.IGenericService#deleteByPrimaryKey(java.lang.Integer)
	 */
	@Override
	public int deleteByPrimaryKey(String id) {
		// 外键删除完毕；
		int i = resourceMapper.deleteByPrimaryKey(id);
		return i;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.bingya.service.IGenericService#insert(java.io.Serializable)
	 */
	@Override
	public String insert(Resource entity) {
		int i = resourceMapper.insertSelective(entity);
		return entity.getId();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.bingya.service.IGenericService#selectAll()
	 */
	@Override
	public List<Resource> selectAll() {
		return resourceMapper.selectByExample(null);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.bingya.service.IGenericService#selectByPrimaryKey(java.lang.Integer)
	 */
	@Override
	public Resource selectByPrimaryKey(String id) {
		return resourceMapper.selectByPrimaryKey(id);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.bingya.service.IGenericService#update(java.io.Serializable)
	 */
	@Override
	public int update(Resource entity) {
		return resourceMapper.updateByExampleSelective(entity, null);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.bingya.service.IGenericService#query(com.bingya.util.Page,
	 * java.lang.String, java.lang.String)
	 */
	@Override
	public Page query(Page page, String key, String orderCondition) {
		key = "%" + key + "%";
		ResourceExample resourceExample = new ResourceExample();
		// resourceExample.createCriteria().andDescriptionLike(key);
		resourceExample.setPage(page);
		int total = resourceMapper.countByExample(resourceExample);
		page.setTotal(total);
		List<Resource> list = resourceMapper.selectByExample(resourceExample);
		page.setRows(list);
		return page;
	}

}
