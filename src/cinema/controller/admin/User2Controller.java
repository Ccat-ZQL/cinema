package cinema.controller.admin;

import cinema.entities.User;
import cinema.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author Mango
 * @Date: 2021/6/1 11:13:10
 */
@Controller
@RequestMapping("/admin/user")
public class User2Controller {

    @Resource
    private UserService userService;

    /**
     * 跳转到用户管理界面
     * @return
     */
    @RequestMapping
    public String toUser() {
        return "admin/user";
    }

    /**
     * 获取所欲的普通用户
     * @return
     */
    @ResponseBody
    @RequestMapping("/getAllUsers")
    public List<User> getAllUsers() {
        return userService.getAllUsers();
    }

    /**
     * 单个删除
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping("/removeUser")
    public boolean removeUser(@RequestParam("id") Long id) {
        Integer result = userService.removeUser(id);
        if (result > 0) {
            return true;
        }
        return false;
    }

    /**
     * 批量删除
     * @param ids
     * @return
     */
    @ResponseBody
    @RequestMapping("/delMulti")
    public boolean removeMulti(@RequestParam("ids") String ids) {
        userService.removeUsers(ids);
        return true;
    }

    /**
     * 重置密码, 密码默认为 123456
     * @param phone
     * @return
     */
    @ResponseBody
    @RequestMapping("/resetPwd")
    public boolean resetPwd(@RequestParam("phone") String phone) {
        return userService.changePassword(phone, "123456");
    }

    /**
     * 获取个人信息
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping("/getInfo")
    public User getInfo(@RequestParam("id") Long id) {
        return userService.getInfo(id);
    }
}
