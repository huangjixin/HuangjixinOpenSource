import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.bingya.domain.system.Asset;
import com.bingya.service.IAssetService;
import com.bingya.util.PDF2SWFUtil;

/**
 * 
 * @author crystal
 */
public class FileUploaded extends HttpServlet {

	// @Resource
	// private IAssetService assetService;

	/**
	 * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
	 * methods.
	 * 
	 * @param request
	 *            servlet request
	 * @param response
	 *            servlet response
	 */
	// 定义文件的上传路径

	private String uploadPath = "d://uploadtest//";

	// 限制文件的上传大小

	private int maxPostSize = 100 * 1024 * 1024;

	public FileUploaded() {
		super();
	}

	public void destroy() {
		super.destroy();
	}

	protected void processRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String userId = request.getParameter("userId");//用户Id；
		String course = request.getParameter("course");//上传课程；
		
		System.out.println("web.root:" + System.getProperty("web.root"));
		// uploadPath=request.getSession().getServletContext().getRealPath("");
		uploadPath = System.getProperty("web.root");
		System.out.println(uploadPath);
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter out = response.getWriter();

		// 保存文件到服务器中

		DiskFileItemFactory factory = new DiskFileItemFactory();
		factory.setSizeThreshold(4096);
		ServletFileUpload upload = new ServletFileUpload(factory);
		upload.setHeaderEncoding("UTF-8");
		upload.setSizeMax(maxPostSize);
		try {
			List fileItems = upload.parseRequest(request);
			Iterator iter = fileItems.iterator();
			while (iter.hasNext()) {
				FileItem item = (FileItem) iter.next();
				String name = null;
				String relativePath = "upload"+File.separator+userId+File.separator;
				if(course !=null){
					relativePath += course+File.separator;
				}
				
				ServletContext application = this.getServletContext();
				// 获取spring上下文信息 为servlet使用
				WebApplicationContext wac = WebApplicationContextUtils
						.getWebApplicationContext(application);
				IAssetService assetService = (IAssetService) wac.getBean("assetService");
				
				//如果用户上传了课程，那么创建课程文件夹；
				if (!item.isFormField()) {
					name = item.getName();
//					List<Asset> list = assetService.selectByName(name);
//					
//					if(list != null && list.size()>0){
//						throw new Exception("不用上传重名的pdf");
//					}
					
					try {
						File source = new File(uploadPath + relativePath);
						if (!source.exists()){
							source.mkdirs();							
						}
						
						relativePath+=name;
						item.write(new File(uploadPath + relativePath));
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				
				if (null != name) {
					
					
					int lastDot = (uploadPath + relativePath).lastIndexOf(".");
					// 文件后缀
					String suffix = (uploadPath + relativePath).substring(lastDot + 1,
							(uploadPath + relativePath).length());
					if ("pdf".equals(suffix)) {//当上传pdf附件的时候，把它转成swf文件。
						// 生成swf。
						PDF2SWFUtil.pdf2swf(uploadPath + relativePath,
								"D:\\Program Files\\SWFTools\\pdf2swf.exe");

						//保存附件的相对路径
						Asset asset = new Asset();
						asset.setPath(relativePath);
						asset.setUserId(Integer.parseInt(userId));
						asset.setName(name);
						assetService.insert(asset);
						
						response.getWriter().write("fileUploadComplete");
					} else if ("doc".equals(suffix) || "ppt".equals(suffix)) {

					}
				}
			}

		} catch (FileUploadException e) {
			e.printStackTrace();
			System.out.println(e.getMessage() + "结束");
		}
	}

	// <editor-fold defaultstate="collapsed"
	// desc="HttpServlet methods. Click on the + sign on the left to edit the code.">

	/**
	 * Handles the HTTP <code>GET</code> method.
	 * 
	 * @param request
	 *            servlet request
	 * @param response
	 *            servlet response
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		try {
			processRequest(request, response);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * Handles the HTTP <code>POST</code> method.
	 * 
	 * @param request
	 *            servlet request
	 * @param response
	 *            servlet response
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		try {
			processRequest(request, response);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * Returns a short description of the servlet.
	 */
	public String getServletInfo() {
		return "Short description";
	}
	// </editor-fold>

}
