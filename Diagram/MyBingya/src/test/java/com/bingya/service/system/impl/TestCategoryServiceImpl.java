package com.bingya.service.system.impl;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.fail;

import java.util.List;

import javax.annotation.Resource;

import org.json.JSONObject;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.bingya.service.ICategoryService;

import flexjson.JSONSerializer;

@RunWith(SpringJUnit4ClassRunner.class)
// 指定测试用例的运行器 这里是指定了Junit4
@ContextConfiguration({ "/META-INF/spring/applicationContext.xml" })
// 指定Spring的配置文件 /为classpath下
public class TestCategoryServiceImpl {

	@Resource
	private ICategoryService categoryService;

	@Test
	public void testDeleteByPrimaryKey() {
		fail("Not yet implemented");
	}

	// ---------------------------------------------------
	// 常量（全部大写，用下划线分割），变量 （先常后私）
	// ---------------------------------------------------

	@Test
	public void testInsert() {
		fail("Not yet implemented");
	}

	@Test
	public void testSelectAll() {
		fail("Not yet implemented");
	}

	@Test
	public void testSelectByPrimaryKey() {
		fail("Not yet implemented");
	}

	@Test
	public void testUpdate() {
		fail("Not yet implemented");
	}

	@Test
	public void testQuery() {
		fail("Not yet implemented");
	}

	@Test
	public void testGetByParentId() {
		fail("Not yet implemented");
	}

	@Test
	public void testGetCategoryTree() {
		List<JSONObject> list = categoryService.getCategoryTree();
		System.out.println(list.toString());
		assertNotNull(list);
	}

	// ---------------------------------------------------
	// public 公有方法
	// ---------------------------------------------------

	// ---------------------------------------------------
	// protected 方法
	// ---------------------------------------------------

	// ---------------------------------------------------
	// private 私有方法
	// ---------------------------------------------------
}
