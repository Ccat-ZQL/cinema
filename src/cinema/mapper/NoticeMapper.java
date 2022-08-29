package cinema.mapper;

import cinema.entities.Notice;
import cinema.entities.Order;
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
public interface NoticeMapper {

    /**
     * 创建公告
     */
    Integer createNotice(@Param("notice")Notice notice);

    /**
     * 获取所有公告
     */
    List<Notice> getAllNotice();

    /**
     * 删除公告
     */
    Integer deleteById(@Param("id")Long id);

    /**
     * 分页获取公告
     */
    List<Notice> getNoticeByPage(@Param("currentPage")Integer currentPage,@Param("size")Integer size);

    /**
     * 查询公告总数
     */
    Integer getNoticeNumber();
}

