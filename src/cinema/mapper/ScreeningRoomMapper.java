package cinema.mapper;

import cinema.entities.ScreeningRoom;
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
public interface ScreeningRoomMapper {

    /**
     * 获取单个电影院的详情
     *
     * @param id
     * @return
     */
    ScreeningRoom getById(@Param("id") Long id);

    /**
     * 获取所有的电影院信息
     *
     * @return
     */
    List<ScreeningRoom> getAll();

    /**
     * 获取一条记录信息
     * @param id
     * @return
     */
    ScreeningRoom getOne(@Param("id") Long id);
}
