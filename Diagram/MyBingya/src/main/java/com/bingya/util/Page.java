package com.bingya.util;


import java.util.ArrayList;
import java.util.List;

/**
 * 分页查询时的辅助工具类
 * @author linzongxue
 *
 */
@SuppressWarnings("rawtypes")
public class Page{
	protected int limit = 20; //每页显示条数
	protected int start = 0;  //起始行号
	protected int total = -1; //总数
	protected List rows = new ArrayList(); //结果集
	protected int page = 1;   //第几页
//	protected int pages = 0; //总页面码, jqGrid要求给出总页数，超级无聊


	//-- 访问查询结果函数 --//

	
	public int getLimit() {
		return limit;
	}

	public void setLimit(int limit) {
		this.limit = limit;
	}

	public int getStart() {
		return start;
	}

	public void setStart(int start) {
		this.start = start;
	}

	public List getRows() {
		return rows;
	}

	public void setRows(List rows) {
		this.rows = rows;
	}

	public int getTotal() {
		return (int)((total / limit) + (total % limit > 0 ? 1 : 0));
	}

	public void setTotal(int total) {
		this.total = total;
	}

	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page;
	}

//
//	public int getPages() {
//		return (int)((total / limit) + (total % limit > 0 ? 1 : 0));
//	}
}
