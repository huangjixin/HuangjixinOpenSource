/**
 * 
 */
package com.bingya.service.impl;

import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bingya.dao.system.ArticleMapper;
import com.bingya.dao.system.CommentMapper;
import com.bingya.domain.system.Article;
import com.bingya.domain.system.ArticleExample;
import com.bingya.domain.system.Comment;
import com.bingya.domain.system.CommentExample;
import com.bingya.service.IArticleService;
import com.bingya.util.Page;

/**
 * @author huangjixin
 * 
 */
@Transactional
@Service(value = "articleService")
public class ArticleServiceImpl implements IArticleService {
	// ---------------------------------------------------
	// 常量（全部大写，用下划线分割），变量 （先常后私）
	// ---------------------------------------------------
	@Resource
	private ArticleMapper articleMapper;

	@Resource
	private CommentMapper commentMapper;

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
		// --先删除子表数据。
		CommentExample commentExample = new CommentExample();
		commentExample.createCriteria().andTbArticleIdEqualTo(id);
		List<Comment> commentss = commentMapper.selectByExample(commentExample);
		for (Comment comment : commentss) {
			commentMapper.deleteByPrimaryKey(comment.getId());
		}

		// 外键删除完毕；
		int i = articleMapper.deleteByPrimaryKey(id);
		return i;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.bingya.service.IGenericService#insert(java.io.Serializable)
	 */
	@Override
	public String insert(Article entity) {
		Date date = new Date();
		Long time = date.getTime();
		entity.setId("" + time);
		int i = articleMapper.insertSelective(entity);
		if (i == 0) {
			return "" + i;
		}

		return entity.getId();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.bingya.service.IGenericService#selectAll()
	 */
	@Override
	public List<Article> selectAll() {
		return articleMapper.selectByExample(null);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.bingya.service.IGenericService#selectByPrimaryKey(java.lang.Integer)
	 */
	@Override
	public Article selectByPrimaryKey(String id) {
		return articleMapper.selectByPrimaryKey(id);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.bingya.service.IGenericService#update(java.io.Serializable)
	 */
	@Override
	public int update(Article entity) {
		return articleMapper.updateByExampleSelective(entity, null);
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
		ArticleExample articleExample = new ArticleExample();
		// articleExample.createCriteria().andDescriptionLike(key);
		articleExample.setPage(page);
		int total = articleMapper.countByExample(articleExample);
		page.setTotal(total);
		List<Article> list = articleMapper.selectByExample(articleExample);
		page.setRows(list);
		return page;
	}

}
