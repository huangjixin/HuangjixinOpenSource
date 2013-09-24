/**
 * 
 */
package com.bingya.service.system.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bingya.dao.system.RoleMapper;
import com.bingya.dao.system.RoleMenuMapper;
import com.bingya.dao.system.RoleResourceMapper;
import com.bingya.dao.system.UserRoleMapper;
import com.bingya.domain.system.Role;
import com.bingya.domain.system.RoleExample;
import com.bingya.domain.system.RoleMenu;
import com.bingya.domain.system.RoleMenuExample;
import com.bingya.domain.system.RoleResource;
import com.bingya.domain.system.RoleResourceExample;
import com.bingya.domain.system.UserRole;
import com.bingya.domain.system.UserRoleExample;
import com.bingya.service.system.IRoleService;
import com.bingya.util.Page;

/**
 * @author huangjixin
 * 
 */
@Transactional
@Service(value = "roleService")
public class RoleServiceImpl implements IRoleService {
	@Resource
	private RoleMapper roleMapper;

	@Resource
	private UserRoleMapper userRoleMapper;
	@Resource
	private RoleResourceMapper roleResourceMapper;
	@Resource
	private RoleMenuMapper roleMenuMapper;

	/*
	 * 删除角色。
	 * 
	 * @see
	 * com.bingya.service.system.IGenericService#deleteByPrimaryKey(java.lang
	 * .Integer)
	 */
	@Override
	public int deleteByPrimaryKey(Integer id) {
		// --先删除子表数据。
		// --角色用户。
		UserRoleExample userRoleExample = new UserRoleExample();
		userRoleExample.createCriteria().andRoleIdEqualTo(id);
		List<UserRole> userRoles = userRoleMapper
				.selectByExample(userRoleExample);
		for (UserRole userRole : userRoles) {
			userRoleMapper.deleteByPrimaryKey(userRole.getId());
		}

		// --角色资源。
		RoleResourceExample roleResourceExample = new RoleResourceExample();
		roleResourceExample.createCriteria().andRoleIdEqualTo(id);
		List<RoleResource> roleResources = roleResourceMapper
				.selectByExample(roleResourceExample);
		for (RoleResource roleResource : roleResources) {
			roleResourceMapper.deleteByPrimaryKey(roleResource.getId());
		}

		// --角色
		RoleMenuExample roleMenuExample = new RoleMenuExample();
		roleMenuExample.createCriteria().andRoleIdEqualTo(id);
		List<RoleMenu> roleMenus = roleMenuMapper
				.selectByExample(roleMenuExample);
		for (RoleMenu roleMenu : roleMenus) {
			roleMenuMapper.deleteByPrimaryKey(roleMenu.getId());
		}

		int i = roleMapper.deleteByPrimaryKey(id);
		return i;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.bingya.service.system.IGenericService#insert(java.io.Serializable)
	 */
	@Override
	public Integer insert(Role entity) {
		int i = roleMapper.insertSelective(entity);
		return entity.getId();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.bingya.service.system.IGenericService#selectAll()
	 */
	@Override
	public List<Role> selectAll() {
		List<Role> list = roleMapper.selectByExample(null);
		return list;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.bingya.service.system.IGenericService#selectByPrimaryKey(java.lang
	 * .Integer)
	 */
	@Override
	public Role selectByPrimaryKey(Integer id) {
		Role role = roleMapper.selectByPrimaryKey(id);
		return role;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.bingya.service.system.IGenericService#update(java.io.Serializable)
	 */
	@Override
	public int update(Role entity) {
		int i = roleMapper.updateByPrimaryKey(entity);
		return i;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.bingya.service.system.IGenericService#query(com.bingya.util.Page,
	 * java.lang.String, java.lang.String)
	 */
	@Override
	public Page query(Page page, String key, String orderCondition) {
		key = "%" + key + "%";
		RoleExample roleExample = new RoleExample();
		// roleExample.createCriteria().andDescriptionLike(key);
		roleExample.setPage(page);
		int total = roleMapper.countByExample(roleExample);
		page.setTotal(total);
		List<Role> list = roleMapper.selectByExample(roleExample);
		page.setRows(list);
		return page;
	}
	// ---------------------------------------------------
	// 常量（全部大写，用下划线分割），变量 （先常后私）
	// ---------------------------------------------------

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
