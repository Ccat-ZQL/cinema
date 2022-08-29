package cinema.controller.admin;

import cinema.entities.ScreeningRoom;
import cinema.entities.ext.Row;
import cinema.service.ScreeningRoomService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author Mango
 * @Date: 2021/5/29 9:03:46
 *
 * sr   screeningRoom
 */
@Controller
@RequestMapping("/admin/sr")
public class ScreeningRoomController {

    @Resource
    private ScreeningRoomService screeningRoomService;

    @ResponseBody
    @RequestMapping
    public List<ScreeningRoom> getAllNumberToChinese() {
        return screeningRoomService.getAllNumberToChinese();
    }
}
