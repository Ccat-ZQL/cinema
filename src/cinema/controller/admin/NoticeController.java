package cinema.controller.admin;

import cinema.entities.Notice;
import cinema.service.NoticeService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author Mango
 * @Date: 2021/6/1 15:16:07
 */
@Controller
@RequestMapping("/admin/notice")
public class NoticeController {

    @Resource
    private NoticeService noticeService;

    /**
     * 跳转只公告首页
     * @return
     */
    @RequestMapping
    public String toNotice() {
        return "admin/notice";
    }

    /**
     * 获取所有的公告
     * @return
     */
    @ResponseBody
    @RequestMapping("/getAll")
    public List<Notice> getAll() {
        return noticeService.getAllNotice();
    }

    /**
     * 创建公告
     * @param title
     * @param content
     * @return
     */
    @ResponseBody
    @RequestMapping("/addNotice")
    public boolean add(@RequestParam("title") String title,
                       @RequestParam("content") String content) {
        Integer result = noticeService.createNotice(title, content);
        if (result > 0) {
            return true;
        }
        return false;
    }

    /**
     * 单个删除
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping("/delOne")
    public boolean remove(@RequestParam("id") Long id) {
        Integer result = noticeService.delOne(id);
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
    @RequestMapping("/delMul")
    public boolean delMul(@RequestParam("ids") String ids) {
        Integer result = noticeService.deleteByIds(ids);
        if (result > 0) {
            return true;
        }
        return false;
    }
}
