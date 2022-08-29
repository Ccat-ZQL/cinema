package cinema.service;

import cinema.entities.Movie;
import cinema.entities.User;
import cinema.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * @author ：ZQL
 * @date ：Created in 2021/5/26 1:13
 */
@Service
@Transactional
public class UserService {
    @Autowired
    private UserMapper userMapper;

    /**
     * 用于注册是检查该手机号是否存在
     * @param phone
     * @return
     */
    public Boolean userUnique(String phone){
        if (userMapper.userUnique(phone) > 0){
            return false;
        }
        return true;
    }

    /**
     * 用户注册
     * @param user
     * @return
     */
    public Boolean createUser(User user){
        if (userMapper.createUser(user) > 0){
            return true;
        }
        return false;
    }

    /**
     * 用户登录
     * @return
     */
    public User login(String phone,String password){
        return userMapper.login(phone, password);

    }

    /**
     * 修改密码
     */
    public Boolean changePassword(String phone ,String password){
        if (userMapper.changePassword(phone,password) > 0){
            return true;
        }
        return  false;
    }

    /**
     * 获取所有的普通用户
     * @return
     */
    public List<User> getAllUsers() {
        return userMapper.getAllUsers();
    }

    /**
     * 删除单个用户
     * @param id
     * @return
     */
    public Integer removeUser(Long id) {
        return userMapper.removeUser(id);
    }

    /**
     * 删除多个用户
     * @param ids
     * @return
     */
    public Integer removeUsers(String ids) {
        String[] split = ids.split(",");
        for (int i = 0; i < split.length; i++) {
            userMapper.removeUser(Long.parseLong(split[i]));
        }
        return 1;
    }

    /**
     * 获取个人信息
     * @param id
     * @return
     */
    public User getInfo(Long id) {
        return userMapper.getInfo(id);
    }
}
