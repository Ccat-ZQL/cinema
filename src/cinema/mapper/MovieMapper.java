package cinema.mapper;

import cinema.entities.Movie;
import cinema.entities.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * @author ：ZQL
 * @date ：Created in 2021/5/26 1:14
 */
@Repository
@Mapper
public interface MovieMapper {

    /**
     * 查询所有的电影信息
     *
     * @return
     */
    List<Movie> getAll();

    /**
     * 获取电影详情信息
     *
     * @param id
     * @return
     */
    Movie detail(@Param("id") Long id);

    /**
     * 删除单个电影
     *
     * @param id
     * @return
     */
    Integer del(@Param("id") Long id);

    /**
     * 分页查询电影信息
     *
     * @param page 当前页 每页6条记录
     * @return
     */
    List<Movie> getMovies(@Param("page") Integer page);

    /**
     * 获取电影总数
     */
    Integer getMovieNumber();

    /**
     * 添加电影
     *
     * @param movie
     * @return
     */
    Integer addMovie(@Param("movie") Movie movie);

    /**
     * 更新电影信息
     * @param movie
     * @return
     */
    Integer updateMovie(@Param("movie") Movie movie);
}
