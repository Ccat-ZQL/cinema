package cinema.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author Mango
 * @Date: 2021/5/26 15:54:51
 */
@Controller
@RequestMapping("/admin/index")
public class IndexController {

    /**
     * 跳转到管理员首页
     * @return
     */
    @RequestMapping
    public String toIndex() {
        return "admin/index";
    }
}
