package cinema.service;

import cinema.constant.FileConstant;
import cinema.entities.Arrangement;
import cinema.entities.Movie;
import cinema.mapper.ArrangementMapper;
import cinema.mapper.MovieMapper;
import cinema.util.FileUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;
import java.text.DateFormat;
import java.util.*;

/**
 * @author Mango
 * @Date: 2021/5/26 15:39:17
 */
@Service
@Transactional(rollbackFor = Exception.class)
public class MovieService {

    @Resource
    private MovieMapper movieMapper;
    @Resource
    private ArrangementMapper arrangementMapper;

    public List<Movie> getAll() {
        return movieMapper.getAll();
    }

    public Movie detail(Long id) {
        return movieMapper.detail(id);
    }

    public Integer del(HttpServletRequest request, Long id) {
        String picUrl = movieMapper.detail(id).getPicUrl();
        FileUtil.delFile(request, picUrl, FileConstant.PIC_PATH);
        return movieMapper.del(id);
    }

    public Integer delMulti(HttpServletRequest request, String ids) {
        String[] split = ids.split(",");
        for (int i = 0; i < split.length; i++) {
            Long id = Long.parseLong(split[i]);
            String picUrl = movieMapper.detail(id).getPicUrl();
            FileUtil.delFile(request, picUrl, FileConstant.PIC_PATH);
            movieMapper.del(id);
        }
        return 1;
    }

    public Integer addMovie(Movie movie, HttpServletRequest request, MultipartFile multipartFile) {
        Map<String, Object> map = FileUtil.uploadFile(request, multipartFile, FileConstant.PIC_PATH);

        System.out.println("map = " + map);
        if (map.get(FileConstant.CODE).equals(FileConstant.Tips.FILE_UPLOAD_SUCCESS)) {
            String picUrl = map.get(FileConstant.FILE_NAME).toString();
            movie.setPicUrl(picUrl);
            Integer result = movieMapper.addMovie(movie);
            return result;
        } else {
            // 文件上传失败
            return -1;
        }
    }

    public Integer updateMovie(Movie movie, HttpServletRequest request, MultipartFile multipartFile) {
        if (!StringUtils.isEmpty(multipartFile)) {
            Movie detail = movieMapper.detail(movie.getId());
            FileUtil.delFile(request, detail.getPicUrl(), FileConstant.PIC_PATH);
            Map<String, Object> map = FileUtil.uploadFile(request, multipartFile, FileConstant.PIC_PATH);
            String picUrl = map.get(FileConstant.FILE_NAME).toString();
            movie.setPicUrl(picUrl);
        }

        Integer result = movieMapper.updateMovie(movie);
        return result;

    }

    /**
     * 分页获得电影列表
     * 每页6条记录
     * @param currentPage
     * @return
     */
    public List<Movie> getMovies(Integer currentPage){
        return movieMapper.getMovies(currentPage*6);
    }

    /**
     * 获取电影数量
     */
    public Integer getMovieNumber(){
        return movieMapper.getMovieNumber();
    }


}
