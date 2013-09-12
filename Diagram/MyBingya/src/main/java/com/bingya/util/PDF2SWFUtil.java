package com.bingya.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import com.artofsolving.jodconverter.DocumentConverter;
import com.artofsolving.jodconverter.openoffice.connection.OpenOfficeConnection;
import com.artofsolving.jodconverter.openoffice.connection.SocketOpenOfficeConnection;
import com.artofsolving.jodconverter.openoffice.converter.OpenOfficeDocumentConverter;

public class PDF2SWFUtil {

	/**
	 * 利用SWFTools工具将pdf转换成swf，转换完后的swf文件与pdf同名
	 * 
	 * @author iori
	 * @param fileDir
	 *            PDF文件存放路径（包括文件名）
	 * @param exePath
	 *            转换器安装路径
	 * @throws IOException
	 */
	public static synchronized void pdf2swf(String fileDir, String exePath)
			throws IOException {
		// 源文件不存在则返回
		File source = new File(fileDir);
		if (!source.exists())
			return;
		// 文件路径
		String filePath = fileDir.substring(0,
				fileDir.lastIndexOf(File.separator));
		// 文件名，不带后缀
		String fileName = fileDir.substring((filePath.length() + 1),
				fileDir.lastIndexOf("."));
		Process pro = null;
		if (isWindowsSystem()) {
			// 如果是windows系统
			// 命令行命令
			String cmd = exePath + " " + File.separator + fileDir + "\" -o \""
					+ filePath + File.separator + fileName + ".swf";
			cmd = exePath + " " + fileDir + " -o " + filePath + File.separator
					+ fileName + ".swf";
			// Runtime执行后返回创建的进程对象
			pro = Runtime.getRuntime().exec(cmd);
		} else {
			// 如果是linux系统,路径不能有空格，而且一定不能用双引号，否则无法创建进程
			String[] cmd = new String[3];
			cmd[0] = exePath;
			cmd[1] = fileDir;
			cmd[2] = filePath + "/" + fileName + ".swf";
			// Runtime执行后返回创建的进程对象
			pro = Runtime.getRuntime().exec(cmd);
		}
		// 非要读取一遍cmd的输出，要不不会flush生成文件（多线程）
		new DoOutput(pro.getInputStream()).start();
		new DoOutput(pro.getErrorStream()).start();
		try {
			// 调用waitFor方法，是为了阻塞当前进程，直到cmd执行完
			pro.waitFor();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 判断是否是windows操作系统
	 * 
	 * @author iori
	 * @return
	 */
	private static boolean isWindowsSystem() {
		String p = System.getProperty("os.name");
		return p.toLowerCase().indexOf("windows") >= 0 ? true : false;
	}

	/**
	 * 多线程内部类 读取转换时cmd进程的标准输出流和错误输出流，这样做是因为如果不读取流，进程将死锁
	 * 
	 * @author iori
	 */
	private static class DoOutput extends Thread {
		public InputStream is;

		// 构造方法
		public DoOutput(InputStream is) {
			this.is = is;
		}

		public void run() {
			BufferedReader br = new BufferedReader(new InputStreamReader(
					this.is));
			String str = null;
			try {
				// 这里并没有对流的内容进行处理，只是读了一遍
				while ((str = br.readLine()) != null)
					;
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				if (br != null) {
					try {
						br.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}
		}
	}

	/**
	 * 测试main方法
	 * 
	 * @param args
	 */
	public static void main(String[] args) {
//		File inputFile = new File("c:/document.doc"); 
//        File outputFile = new File("c:/document.pdf"); 
//        OpenOfficeConnection connection = new SocketOpenOfficeConnection(8100); 
//        connection.connect(); 
//        DocumentConverter converter = new OpenOfficeDocumentConverter(connection); 
//        converter.convert(inputFile, outputFile); 
//        connection.disconnect(); 
        
		// 转换器安装路径
		String exePath = "D:\\Program Files\\SWFTools\\pdf2swf.exe";
		try {
			PDF2SWFUtil
					.pdf2swf(
							"D:\\fb_workspace\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp2\\wtpwebapps\\MyBingya\\Spring_Roo_in_Action_英文版.pdf",
							exePath);

			System.out.println("success");
		} catch (IOException e) {
			System.err.println("转换出错！");
			e.printStackTrace();
		}
		
	}
}
