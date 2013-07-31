/**
 * 
 */
package com.bingya.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bingya.dao.system.AssetMapper;
import com.bingya.domain.system.Asset;
import com.bingya.domain.system.AssetExample;
import com.bingya.service.IAssetService;
import com.bingya.util.Page;

/**
 * @author huangjixin
 * 
 */
@Transactional
@Service(value = "assetService")
public class AssetServiceImpl implements IAssetService {
	// ---------------------------------------------------
	// 常量（全部大写，用下划线分割），变量 （先常后私）
	// ---------------------------------------------------
	@Resource
	private AssetMapper assetMapper;

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
		int i = assetMapper.deleteByPrimaryKey(id);
		return i;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.bingya.service.IGenericService#insert(java.io.Serializable)
	 */
	@Override
	public String insert(Asset entity) {
		int i = assetMapper.insertSelective(entity);
		return entity.getId();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.bingya.service.IGenericService#selectAll()
	 */
	@Override
	public List<Asset> selectAll() {
		return assetMapper.selectByExample(null);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.bingya.service.IGenericService#selectByPrimaryKey(java.lang.Integer)
	 */
	@Override
	public Asset selectByPrimaryKey(String id) {
		return assetMapper.selectByPrimaryKey(id);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.bingya.service.IGenericService#update(java.io.Serializable)
	 */
	@Override
	public int update(Asset entity) {
		return assetMapper.updateByExampleSelective(entity, null);
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
		AssetExample assetExample = new AssetExample();
		// assetExample.createCriteria().andDescriptionLike(key);
		assetExample.setPage(page);
		int total = assetMapper.countByExample(assetExample);
		page.setTotal(total);
		List<Asset> list = assetMapper.selectByExample(assetExample);
		page.setRows(list);
		return page;
	}

}
