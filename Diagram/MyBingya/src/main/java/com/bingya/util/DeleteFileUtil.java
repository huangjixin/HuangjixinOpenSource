 package com.bingya.util;   
   
 import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.StringReader;
   
 /**  
  *   
  * @author XWZ  
  * 2007-11-27  
  * 删除文件或目录  
  */  
 public class DeleteFileUtil {   
     /**  
      * 删除文件，可以是单个文件或文件夹  
      * @param   fileName    待删除的文件名  
      * @return 文件删除成功返回true,否则返回false  
      */  
     public static boolean delete(String fileName){   
         File file = new File(fileName);   
         if(!file.exists()){   
             System.out.println("删除文件失败："+fileName+"文件不存在");   
             return false;   
         }else{   
             if(file.isFile()){   
                    
                 return deleteFile(fileName);   
             }else{   
                 return deleteDirectory(fileName);   
             }   
         }   
     }   
        
     /**  
      * 删除单个文件  
      * @param   fileName    被删除文件的文件名  
      * @return 单个文件删除成功返回true,否则返回false  
      */  
     public static boolean deleteFile(String fileName){   
         File file = new File(fileName);   
         if(file.isFile() && file.exists()){   
             file.delete();   
             System.out.println("删除单个文件"+fileName+"成功！");   
             return true;   
         }else{   
             System.out.println("删除单个文件"+fileName+"失败！");   
             return false;   
         }   
     }   
        
     /**  
      * 删除目录（文件夹）以及目录下的文件  
      * @param   dir 被删除目录的文件路径  
      * @return  目录删除成功返回true,否则返回false  
      */  
     public static boolean deleteDirectory(String dir){   
         //如果dir不以文件分隔符结尾，自动添加文件分隔符   
         if(!dir.endsWith(File.separator)){   
             dir = dir+File.separator;   
         }   
         File dirFile = new File(dir);   
         //如果dir对应的文件不存在，或者不是一个目录，则退出   
         if(!dirFile.exists() || !dirFile.isDirectory()){   
             System.out.println("删除目录失败"+dir+"目录不存在！");   
             return false;   
         }   
         boolean flag = true;   
         //删除文件夹下的所有文件(包括子目录)   
         File[] files = dirFile.listFiles();   
         for(int i=0;i<files.length;i++){   
             //删除子文件   
             if(files[i].isFile()){   
                 flag = deleteFile(files[i].getAbsolutePath());   
                 if(!flag){   
                     break;   
                 }   
             }   
             //删除子目录   
             else{   
                 flag = deleteDirectory(files[i].getAbsolutePath());   
                 if(!flag){   
                     break;   
                 }   
             }   
         }   
            
         if(!flag){   
             System.out.println("删除目录失败");   
             return false;   
         }   
            
         //删除当前目录   
         if(dirFile.delete()){   
             System.out.println("删除目录"+dir+"成功！");   
             return true;   
         }else{   
             System.out.println("删除目录"+dir+"失败！");   
             return false;   
         }   
     }   
        
     /** 
      * 将字符串写入指定文件(当指定的父路径中文件夹不存在时，会最大限度去创建，以保证保存成功！) 
      * 
      * @param res 原字符串 
      * @param filePath 文件路径 
      * @return 成功标记 
      */ 
     public static boolean string2File(String res, String filePath) { 
             boolean flag = true; 
             BufferedReader bufferedReader = null; 
             BufferedWriter bufferedWriter = null; 
             try { 
                     File distFile = new File(filePath); 
                     if (!distFile.getParentFile().exists()) distFile.getParentFile().mkdirs(); 
                     bufferedReader = new BufferedReader(new StringReader(res)); 
                     bufferedWriter = new BufferedWriter(new FileWriter(distFile)); 
                     char buf[] = new char[1024];         //字符缓冲区 
                     int len; 
                     while ((len = bufferedReader.read(buf)) != -1) { 
                             bufferedWriter.write(buf, 0, len); 
                     } 
                     bufferedWriter.flush(); 
                     bufferedReader.close(); 
                     bufferedWriter.close(); 
             } catch (IOException e) { 
                     e.printStackTrace(); 
                     flag = false; 
                     return flag; 
             } finally { 
                     if (bufferedReader != null) { 
                             try { 
                                     bufferedReader.close(); 
                             } catch (IOException e) { 
                                     e.printStackTrace(); 
                             } 
                     } 
             } 
             return flag; 
     }
     
     public static void main(String[] args) {   
         //String fileName = "g:/temp/xwz.txt";   
         //DeleteFileUtil.deleteFile(fileName);   
         String fileDir = "G:/temp/temp0/temp1";   
         //DeleteFileUtil.deleteDirectory(fileDir);   
         DeleteFileUtil.delete(fileDir);   
            
     }   
 }  