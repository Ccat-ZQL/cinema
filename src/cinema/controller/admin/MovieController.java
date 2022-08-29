package cinema.controller.admin;

import cinema.entities.Movie;
import cinema.service.MovieService;
import cinema.util.FileUtil;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @author Mango
 * @Date: 2021/5/26 15:13:43
 */
@Controller
@RequestMapping("/admin/movie")
public class MovieController {

    @Resource
    private MovieService movieService;

    /**
     * 获取所有的电影信息
     * @return
     */
    @RequestMapping
    @ResponseBody
    public List<Movie> getAll() {
        return movieService.getAll();
    }

    /**
     * 获取单个电影详情信息
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping("/detail")
    public Movie detail(@RequestParam("id") Long id) {
        return movieService.detail(id);
    }

    /**
     * 删除单个电影
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping("/del")
    public Boolean del(@RequestParam("id") Long id,
                       HttpServletRequest request) {
        if (movieService.del(request, id) > 0) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * 批量删除电影
     * @param ids
     * @return
     */
    @ResponseBody
    @RequestMapping("/delMulti")
    public Boolean delMulti(@RequestParam("ids") String ids,
                       HttpServletRequest request) {
        movieService.delMulti(request, ids);
        return true;
    }

    @ResponseBody
    @RequestMapping("/addMovie")
    public Boolean addMovie(@RequestParam("name") String name,
                            @RequestParam("introduction") String introduction,
                            @RequestParam("showTime") @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") Date date,
                            @RequestParam("file") MultipartFile file,
                            HttpServletRequest request) {
        Movie movie = new Movie();
        movie.setIntroduction(introduction);
        movie.setName(name);
        movie.setShowTime(date);
        Integer result = movieService.addMovie(movie, request, file);
        if (result > 0) {
            return true;
        }
        return false;
    }


    @ResponseBody
    @RequestMapping("/updateMovie")
    public Boolean updateMovie(@RequestParam("id") Long id,
                               @RequestParam("name") String name,
                               @RequestParam("introduction") String introduction,
                               @RequestParam("showTime") @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") Date date,
                               @RequestParam(value = "file", required = false) MultipartFile file,
                               HttpServletRequest request) {
        System.out.println("name = " + name + ", introduction = " + introduction + ", date = " + date + ", file = " + file + ", request = " + request);
        Movie movie = new Movie();
        movie.setName(name);
        movie.setIntroduction(introduction);
        movie.setShowTime(date);
        movie.setId(id);
        Integer result = movieService.updateMovie(movie, request, file);
        if (result > 0) {
            return true;
        } else {
            return false;
        }
    }
}
