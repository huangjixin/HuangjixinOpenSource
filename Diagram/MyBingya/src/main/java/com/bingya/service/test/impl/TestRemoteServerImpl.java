/**
 * 
 */
package com.bingya.service.test.impl;

import org.springframework.flex.remoting.RemotingDestination;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bingya.service.test.ITestRemoteServer;


/**
 * @author huangjixin, 上午10:41:22
 *
 */
@Transactional
@Service
@RemotingDestination(value="testRemoteServerImpl",channels={"my-amf"})
public class TestRemoteServerImpl implements ITestRemoteServer {

	/* (non-Javadoc)
	 * @see com.bingya.service.system.ITestRemoteServer#getStr()
	 */
	@Override
	public String getStr() {
		// TODO Auto-generated method stub
		return "hello,world";
	}
	
	public static void main(String[] args) {
		System.out.println("ok");
	}
	//---------------------------------------------------
	// 常量（全部大写，用下划线分割），变量 （先常后私）
	//---------------------------------------------------

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
