/**
 * 
 */
package com.bingya.service;

import java.util.List;

import com.bingya.domain.system.Asset;
import com.bingya.service.domain.AssetBusiDomain;
import com.bingya.util.Page;

/**
 * @author huangjixin
 *
 */
public interface IAssetService extends IGenericService<Asset, Integer> {
	Page queryByUserId(Page page, Integer userId);
	
	List<Asset> selectByUserId(Integer userId);
	
	List<Asset> selectByName(String name);

	AssetBusiDomain getPathsById(Integer id);

	/**
	 * 把字符串的xml写到讲义所在文件夹下面。
	 * @param xmlString
	 * @param assetId
	 */
	Boolean saveXmlStringToFile(String xmlString,int userId,int courseId,String name,int assetId);
	
	String saveXmlStr(String xmlString,int userId,int courseId,String name,int assetId);
}
