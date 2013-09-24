/**
 * 
 */
package com.bingya.service.domain;

import java.io.Serializable;
import java.util.List;

/**
 * @author Administrator
 *
 */
public class AssetBusiDomain implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4984949492744754023L;
	
	private String titleXmlString;
	
	private List<String> paths;

	public String getTitleXmlString() {
		return titleXmlString;
	}

	public void setTitleXmlString(String titleXmlString) {
		this.titleXmlString = titleXmlString;
	}

	public List<String> getPaths() {
		return paths;
	}

	public void setPaths(List<String> paths) {
		this.paths = paths;
	}
}
