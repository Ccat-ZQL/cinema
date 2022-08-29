package cinema.mapper;

import cinema.entities.Arrangement;
import cinema.entities.Movie;
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
public interface ArrangementMapper {
    /**
     * 获取电影的安排
     * @return
     */
    List<Arrangement> getArrangementByDate(@Param("movieId")Long movieId);

    /**
     * 获取电影所有的安排
     *
     * @param id
     * @return
     */
    List<Arrangement> getByMovieId(@Param("id") Long id);

    /**
     * 查看本次安排详情
     *
     * @param id
     * @return
     */
    Arrangement getById(@Param("id") Long id);

    /**
     * 通过id删除
     *
     * @param id
     * @return
     */
    Integer delById(@Param("id") Long id);

    /**
     * 添加电影场次
     * @param arrangement
     * @return
     */
    Integer addArrangement(@Param("arrangement") Arrangement arrangement);

    /**
     * 提交订单后更新座位json
     * @param seat 座位json串
     * @return
     */
    Integer updateSeats(@Param("seat")String seat,@Param("id")Long id);
}
