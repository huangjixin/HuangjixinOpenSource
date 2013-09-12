/**
 * 
 */
package com.bingya.service.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.json.JSONObject;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bingya.dao.system.ArticleMapper;
import com.bingya.dao.system.CategoryMapper;
import com.bingya.domain.system.Article;
import com.bingya.domain.system.ArticleExample;
import com.bingya.domain.system.Category;
import com.bingya.domain.system.CategoryExample;
import com.bingya.service.ICategoryService;
import com.bingya.util.Page;

import flexjson.JSONException;

/**
 * @author huangjixin
 * 
 */
@Transactional
@Service(value = "categoryService")
public class CategoryServiceImpl implements ICategoryService {
	// ---------------------------------------------------
	// 常量（全部大写，用下划线分割），变量 （先常后私）
	// ---------------------------------------------------
	@Resource
	private CategoryMapper categoryMapper;

	@Resource
	private ArticleMapper articleMapper;

	// ---------------------------------------------------
	// public 公有方法
	// ---------------------------------------------------
	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.bingya.service.IGenericService#deleteByPrimaryKey(java.lang.Integer)
	 */
	@Override
	public int deleteByPrimaryKey(Integer id) {
		// --先删除子表数据。
		ArticleExample articleExample = new ArticleExample();
		articleExample.createCriteria().andTbCategoryIdEqualTo(id);
		List<Article> articles = articleMapper.selectByExample(articleExample);
		for (Article article : articles) {
			articleMapper.deleteByPrimaryKey(article.getId());
		}

		// 做递归删除。
		List<Category> categoryList = getByParentId(id);
		for (Category category : categoryList) {
			deleteByPrimaryKey(category.getId());
		}

		// 外键删除完毕；
		int i = categoryMapper.deleteByPrimaryKey(id);
		return i;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.bingya.service.IGenericService#insert(java.io.Serializable)
	 */
	@Override
	public Integer insert(Category entity) {
		int i = categoryMapper.insertSelective(entity);
		return entity.getId();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.bingya.service.IGenericService#selectAll()
	 */
	@Override
	public List<Category> selectAll() {
		return categoryMapper.selectByExample(null);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.bingya.service.IGenericService#selectByPrimaryKey(java.lang.Integer)
	 */
	@Override
	public Category selectByPrimaryKey(Integer id) {
		return categoryMapper.selectByPrimaryKey(id);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.bingya.service.IGenericService#update(java.io.Serializable)
	 */
	@Override
	public int update(Category entity) {
		return categoryMapper.updateByExampleSelective(entity, null);
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
		CategoryExample categoryExample = new CategoryExample();
		// menuExample.createCriteria().andDescriptionLike(key);
		categoryExample.setPage(page);
		int total = categoryMapper.countByExample(categoryExample);
		page.setTotal(total);
		List<Category> list = categoryMapper.selectByExample(categoryExample);
		page.setRows(list);
		return page;
	}

	@Override
	public List<Category> getByParentId(Integer id) {
		CategoryExample categoryExample = new CategoryExample();
		categoryExample.createCriteria().andParentidEqualTo(id);
		return categoryMapper.selectByExample(categoryExample);
	}

	@Override
	public List<JSONObject> getCategoryTree() {
		CategoryExample categoryExample = new CategoryExample();
		categoryExample.createCriteria().andParentidIsNull();

		List<Category> categories = categoryMapper
				.selectByExample(categoryExample);
		List<JSONObject> children = new ArrayList<JSONObject>();

		try {
			for (Category category : categories) {
				JSONObject jsonObject;

				jsonObject = searialCategory(category);
				children.add(jsonObject);
			}
		} catch (org.json.JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return children;
	}

	// ---------------------------------------------------
	// protected 方法
	// ---------------------------------------------------

	// ---------------------------------------------------
	// private 私有方法
	// ---------------------------------------------------

	private JSONObject searialCategory(Category category)
			throws org.json.JSONException {
		JSONObject jsonObject = new JSONObject();
		try {
			jsonObject.put("id", category.getId());
			jsonObject.put("parentId", category.getParentid());
			jsonObject.put("name", category.getName());

			List<JSONObject> list = searialChild(category);
			if (null != list) {
				jsonObject.put("children", list);
			}

		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return jsonObject;
	}

	/**
	 * 序列化孩子。
	 * 
	 * @param category
	 * @return
	 */
	private List<JSONObject> searialChild(Category category) {
		List<JSONObject> children = null;
		List<Category> list = getByParentId(category.getId());
		if (list != null && list.size() > 0) {
			children = new ArrayList<JSONObject>();
		}
		try {
			for (Category object : list) {
				JSONObject jsonObject = searialCategory(object);
				children.add(jsonObject);
			}
		} catch (Exception e) {
			// TODO: handle exception
		}
		return children;
	}
}
