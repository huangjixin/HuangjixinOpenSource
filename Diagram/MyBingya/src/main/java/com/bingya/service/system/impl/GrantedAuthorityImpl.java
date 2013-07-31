/**
 * 
 */
package com.bingya.service.system.impl;

import org.springframework.security.core.GrantedAuthority;

import com.bingya.domain.system.Role;

/**
 * @author Administrator
 * 
 */
public class GrantedAuthorityImpl extends Role implements GrantedAuthority {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public GrantedAuthorityImpl(String authority) {
		setName(authority);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.springframework.security.core.GrantedAuthority#getAuthority()
	 */
	@Override
	public String getAuthority() {
		return getName();
	}

}
