package cinema.controller.admin;

import cinema.entities.Order;
import cinema.service.OrderService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author Mango
 * @Date: 2021/6/1 15:15:06
 */
@Controller
@RequestMapping("/admin/order")
public class OrderController {

    @Resource
    private OrderService orderService;

    /**
     * 跳转到order界面
     * @return
     */
    @RequestMapping
    public String toOrder() {
        return "admin/order";
    }

    /**
     * 获取指定用户所有的订单
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping("/getAllOrder")
    public List<Order> getAllOrder(@RequestParam("id") Long id){
        return orderService.getAllOrder(id);
    }

    /**
     * 取消订单
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping("/cancelOrder")
    public boolean cancelOrder(@RequestParam("id") Long id) {
        Integer result = orderService.cancelOrder(id);
        if (result > 0) {
            return true;
        }
        return false;
    }

    /**
     * 添加查询所有的订单
     * @param key
     * @return
     */
    @ResponseBody
    @RequestMapping("/queryByCondition")
    public List<Order> query(@RequestParam(value = "key", required = false) String key) {
        return orderService.getAllOrders(key);
    }
}
