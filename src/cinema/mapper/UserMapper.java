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
public interface UserMapper {
    /**
     * 注册时用于验证该手机号是否存在
     *
     * @param phone
     * @return
     */
    Integer userUnique(@Param("phone") String phone);

    /**
     * 注册用户
     *
     * @param user
     * @return
     */
    Integer createUser(@Param("user") User user);

    /**
     * 用户登录
     *
     * @return
     */
    User login(@Param("phone") String phone, @Param("password") String password);

    /**
     * 修改密码
     */
    Integer changePassword(@Param("phone") String phone, @Param("password") String password);

    /**
     * 获取所有的普通用户
     *
     * @return
     */
    List<User> getAllUsers();

    /**
     * 删除用户
     *
     * @param id
     * @return
     */
    Integer removeUser(@Param("id") Long id);

    /**
     * 获取个人信息
     * @param id
     * @return
     */
    User getInfo(@Param("id") Long id);
}
