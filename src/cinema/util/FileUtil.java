package cinema.util;

import cinema.constant.FileConstant;
import org.apache.commons.io.FileUtils;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * @author Mango
 * @Date: 2021/5/26 1:32:48
 */
public class FileUtil {

    /**
     * 读取文件内容
     * @param path
     * @return
     */
    public static String readFileContent(String path) {
        File file = new File(path);
        BufferedReader reader = null;
        StringBuffer sbf = new StringBuffer();
        try {
            reader = new BufferedReader(new FileReader(file));
            String tempStr;
            while ((tempStr = reader.readLine()) != null) {
                sbf.append(tempStr);
            }
            reader.close();
            return sbf.toString();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e1) {
                    e1.printStackTrace();
                }
            }
        }
        return sbf.toString();
    }

    /**
     * 文件上传
     * @param request
     * @param multipartFile
     * @return
     */
    public static Map<String, Object> uploadFile(HttpServletRequest request, MultipartFile multipartFile,
                                                 String uploadFilePath) {
        Map<String, Object> resultMap = new HashMap<>();
        String rootPath = request.getServletContext().getRealPath(uploadFilePath);
        File root = new File(rootPath);
        if (!root.exists()) {
            root.mkdirs();
        }
        if (!rootPath.endsWith(File.separator)) {{
            rootPath = rootPath.concat(File.separator);
        }}
        String originalFilename = multipartFile.getOriginalFilename();
        String suffix = originalFilename.substring(originalFilename.lastIndexOf("."));
        String prefix = UUID.randomUUID().toString();
        String realName = prefix + suffix;
        File file = new File(root, realName);
        try {
            FileUtils.copyInputStreamToFile(multipartFile.getInputStream(), file);
            resultMap.put(FileConstant.CODE, FileConstant.Tips.FILE_UPLOAD_SUCCESS);
            resultMap.put(FileConstant.FILE_NAME, realName);
        } catch (IOException e) {
            resultMap.put("code", -1);
        }
        return resultMap;
    }

    public static FileConstant.Tips delFile(HttpServletRequest request, String fileName,
                                            String uploadFilePath) {
        String rootPath = request.getServletContext().getRealPath(uploadFilePath);
        File root = new File(rootPath);
        if (!root.exists()) {
            root.mkdirs();
            // 文件不存在
            return FileConstant.Tips.FILE_NOT_EXIST;
        }
        if (!rootPath.endsWith(File.separator)) {{
            rootPath = rootPath.concat(File.separator);
        }}
        File file = new File(root, fileName);
        if (!file.exists()) {
            // 文件不存在
            return FileConstant.Tips.FILE_NOT_EXIST;
        }
        if (file.delete()) {
            // 文件删除成功
            return FileConstant.Tips.FILE_DELETE_SUCCESS;
        } else {
            // 文件删除失败
            return FileConstant.Tips.FILE_DELETE_FAIL;
        }
    }
}
