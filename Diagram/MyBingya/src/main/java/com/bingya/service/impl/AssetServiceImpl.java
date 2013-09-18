/**
 * 
 */
package com.bingya.service.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.flex.remoting.RemotingDestination;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bingya.dao.system.AssetMapper;
import com.bingya.domain.system.Asset;
import com.bingya.domain.system.AssetExample;
import com.bingya.service.IAssetService;
import com.bingya.util.DeleteFileUtil;
import com.bingya.util.Page;

/**
 * @author huangjixin
 * 
 */
@Transactional
@Service(value = "assetService")
@RemotingDestination(value="assetServiceImpl",channels={"my-amf"})
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
	public int deleteByPrimaryKey(Integer id) {
		Asset asset = assetMapper.selectByPrimaryKey(id);
		asset.getPath();
		String uploadPath = System.getProperty("web.root");
		uploadPath += asset.getPath();
		DeleteFileUtil.delete(uploadPath);
		int lastDot = (uploadPath ).lastIndexOf(".");
		// 文件后缀
		String suffix = (uploadPath ).substring(lastDot + 1,
				(uploadPath).length());
		String swfFileName = (uploadPath).substring(0,uploadPath.length()-suffix.length());
		swfFileName+="swf";
		DeleteFileUtil.delete(swfFileName);
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
	public Integer insert(Asset entity) {
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
	public Asset selectByPrimaryKey(Integer id) {
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

	@Override
	public Page queryByUserId(Page page, Integer userId) {
		AssetExample assetExample = new AssetExample();
		assetExample.createCriteria().andUserIdEqualTo(userId);
		assetExample.setPage(page);
		
		int total = assetMapper.countByExample(assetExample);
		page.setTotal(total);
		List<Asset> list = assetMapper.selectByExample(assetExample);
		page.setRows(list);
		return page;
	}

	@Override
	public List<Asset> selectByUserId(Integer userId) {
		AssetExample assetExample = new AssetExample();
		assetExample.createCriteria().andUserIdEqualTo(userId);
		
		List<Asset> list = assetMapper.selectByExample(assetExample);
		return list;
	}

	@Override
	public List<Asset> selectByName(String name) {
		AssetExample assetExample = new AssetExample();
		assetExample.createCriteria().andNameEqualTo(name);
		
		List<Asset> list = assetMapper.selectByExample(assetExample);
		return list;
	}

	@Override
	public List<String> getPathsById(Integer id) {
		List<String> list = new ArrayList<String>();
		Asset asset = assetMapper.selectByPrimaryKey(id);
		String path = asset.getPath();
		path = path.replace("\\", "/");
		int lastDot = path.lastIndexOf(".");
		if(lastDot!=-1){
			path = path.substring(0,lastDot);
		}
		String path1 = path+"1";
		String path2 = path+"2";
		String path3 = path+"3";
		String path4 = path+"4";
		path+=".swf";
		path1+=".swf";
		path2+=".swf";
		path3+=".swf";
		path4+=".swf";
		list.add(path);
		list.add(path1);
		list.add(path2);
		list.add(path3);
		list.add(path4);
		return list;
	}

	@Override
	public Boolean saveXmlStringToFile(String xmlString,int assetId) {
		Asset asset = assetMapper.selectByPrimaryKey(assetId);
		asset.getPath();
		String uploadPath = System.getProperty("web.root");
		uploadPath += asset.getPath();
		int lastIndex = (uploadPath ).lastIndexOf(File.separator);
		// 文件后缀
		String fileName = (uploadPath ).substring(lastIndex + 1,
				(uploadPath).length());
		String fileDir = (uploadPath).substring(0,uploadPath.length()-fileName.length());
		fileDir+=assetId+"_presentation.xml";
		DeleteFileUtil.string2File(xmlString, fileDir);
		return null;
	}

}
