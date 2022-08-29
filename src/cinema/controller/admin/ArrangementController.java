package cinema.controller.admin;

import cinema.entities.Arrangement;
import cinema.entities.ext.Row;
import cinema.service.ArrangementService;
import cinema.service.ScreeningRoomService;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

/**
 * @author Mango
 * @Date: 2021/5/29 9:38:03
 *
 * am => arrangement
 */
@Controller
@RequestMapping("/admin/am")
public class ArrangementController {


    @Resource
    private ArrangementService arrangementService;

    @Resource
    private ScreeningRoomService screeningRoomService;

    /**
     * 获取该电影所有的安排
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping
    public List<Arrangement> getByMovieId(@RequestParam("id") Long id) {
        return arrangementService.getByMovieId(id);
    }



    @ResponseBody
    @RequestMapping("/seat/{id}")
    public List<Row> seat(@PathVariable("id") Long id) {
        System.out.println("id = " + id);
        List<Row> result = arrangementService.getById(id);
        return result;
    }

    @ResponseBody
    @RequestMapping("/del/{id}")
    public Boolean delById(@PathVariable("id") Long id) {
        Integer result = arrangementService.delById(id);
        if (result > 0) {
            return true;
        }
        return false;
    }

    @ResponseBody
    @RequestMapping("/add")
    public Boolean add(@RequestParam("movieId") Long movieId,
                       @RequestParam("roomId") Long roomId,
                       @RequestParam("startTime") @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")Date startTime,
                       @RequestParam("endTime") @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") Date endTime,
                       @RequestParam("price") Double price) {
        Arrangement arrangement = new Arrangement();
        arrangement.setMovieId(movieId);
        arrangement.setRoomId(roomId);
        arrangement.setStartTime(startTime);
        arrangement.setEndTime(endTime);
        arrangement.setPrice(price);
        System.out.println("price = " + price);
        Integer result = arrangementService.addArrangement(arrangement);
        if (result > 0) {
            return true;
        }
        return false;
    }
}
