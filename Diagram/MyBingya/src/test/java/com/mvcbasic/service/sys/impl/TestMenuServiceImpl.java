package com.mvcbasic.service.sys.impl;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.fail;

import java.util.List;

import javax.annotation.Resource;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.bingya.service.system.IMenuService;

import flexjson.JSONSerializer;
@RunWith(SpringJUnit4ClassRunner.class) //指定测试用例的运行器 这里是指定了Junit4  
@ContextConfiguration({"/META-INF/spring/applicationContext.xml"}) //指定Spring的配置文件 /为classpath下  
public class TestMenuServiceImpl {

	@Resource
	private IMenuService menuService;
	
	@Test
	public void testDeleteByPrimaryKey() {
		int i = menuService.deleteByPrimaryKey("12");
		Assert.assertEquals(1, i);
	}

	//---------------------------------------------------
	// 常量（全部大写，用下划线分割），变量 （先常后私）
	//---------------------------------------------------

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
	public void testGetMenu() {
		List list = menuService.getMenuTree();
		JSONSerializer jsons = new JSONSerializer();
		System.out.println(list.toString());
		assertNotNull(list);
	}
	
	@Test
	public void getMenuXmlStr() {
		String str = menuService.getMenuXmlStr("http://localhost:8088/MyBingya/");
		System.out.println(str);
		assertNotNull(str);
	}

	@Test
	public void testGetByParentId() {
		fail("Not yet implemented");
	}

	//---------------------------------------------------
	// public 公有方法
	//---------------------------------------------------

	//---------------------------------------------------
	// protected 方法
	//---------------------------------------------------

	//---------------------------------------------------
	// private 私有方法
	//---------------------------------------------------
}
