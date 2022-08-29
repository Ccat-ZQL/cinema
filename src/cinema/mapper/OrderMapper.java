package cinema.mapper;

import cinema.entities.Arrangement;
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
public interface OrderMapper {
    /**
     * 分页获得订单列表 10条记录一页
     *
     * @return
     */
    List<Order> getOrderListByPage(@Param("page") Integer page, @Param("userId") Long userId, @Param("size") Integer size);

    /**
     * 获取该用户的所有订单数量
     */
    Integer getOrderNumberById(@Param("userId") Long userId);

    /**
     * 提交订单
     */
    Integer addOrder(@Param("order") Order order);

    /**
     * 更新订单状态
     */
    Integer updateStatus(@Param("id") Long id, @Param("status") Integer status);

    Order getById(@Param("id") Long id);

    /**
     * 获取该用户所有的订单
     *
     * @param id
     * @return
     */
    List<Order> getUserOrder(@Param("id") Long id);

    /**
     * 查询
     * @param key
     * @return
     */
    List<Order> getAllOrders(@Param("key") String key);
}
