package cinema.controller;

import cinema.entities.Arrangement;
import cinema.entities.Movie;
import cinema.entities.Notice;
import cinema.entities.ext.Row;
import cinema.service.*;
import cinema.util.SeatUtil;
import cinema.entities.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

/**
 * @author ：ZQL
 * @date ：Created in 2021/5/25 23:32
 */
@Controller
@RequestMapping("/user")
public class UserController {
    @Autowired
    private UserService userService;
    @Autowired
    private MovieService movieService;
    @Autowired
    private ArrangementService arrangementService;
    @Autowired
    private OrderService orderService;
    @Autowired
    private NoticeService noticeService;


    @Resource
    private ScreeningRoomService screeningRoomService;


    //跳转至登录页面
    @RequestMapping("/login")
    public String toLogin() {
        return "../../login";
    }

    //跳转至注册页面
    @RequestMapping("/register")
    public String toRegister() {
        return "register";
    }

    //跳转至修改密码页面
    @RequestMapping("/changepassword")
    public String toChangePassword() {
        return "changePassword";
    }

    /**
     * 跳转至首页
     * @return
     */
    @RequestMapping("/toIndex")
    public String toIndex(@RequestParam(value = "page",defaultValue = "0")Integer currentPage,
                          Model model) {
        List<Movie> movies = movieService.getMovies(currentPage);
        model.addAttribute("movies",movies);
        Map<String,Object> pageMap = new HashMap<>();
        pageMap.put("currentPage",currentPage);
        pageMap.put("total",movieService.getMovieNumber()/6);
        model.addAttribute("page",pageMap);
        return "index";
    }

    /**
     * 用户注册
     */
    @RequestMapping(value = "/registerUser")
    @ResponseBody
    public Map<String, Object> registerUser(@RequestParam("name")String name,
                                            @RequestParam("phone")String phone,
                                            @RequestParam("password")String password) {
        User user = new User();
        user.setName(name);
        user.setPhone(phone);
        user.setPassword(password);
        //普通用户 role值为0
        user.setRole(0);
        Map<String, Object> map = new HashMap<>();
        map.put("code", 0);
        if (!userService.userUnique(user.getPhone())) {
            map.put("message", "该手机号已被注册");
            return map;
        }
        if (userService.createUser(user)) {
            map.put("code", 1);
            return map;
        }
        map.put("message", "注册失败");
        return map;
    }

    /**
     * 用户登录
     */
    @RequestMapping("/userLogin")
    @ResponseBody
    public Map<String, Object> userLogin(@RequestParam("phone") String phone,
                                         @RequestParam("password") String password,
                                         HttpSession session) {
        Map<String, Object> map = new HashMap<>();
        map.put("code", 0);
        User user = userService.login(phone, password);
        if (user != null) {
            System.out.println(user.toString());
            session.setAttribute("user", user);
            map.put("code", 1);
            return map;
        }
        map.put("message", "用户名或密码不正确");
        return map;
    }

    /**
     * 修改密码
     */
    @RequestMapping("/changePwd")
    @ResponseBody
    public Map<String,Object> changePwd(@RequestParam("phone")String phone,
                                        @RequestParam("password")String password,
                                        HttpSession session) {
        Map<String,Object> map = new HashMap<>();
        map.put("code",0);
        map.put("message","修改失败");
        User user = (User) session.getAttribute("user");
        if (!user.getPhone().equals(phone)){
            map.put("message","手机号不正确");
            return map;
        }
        if (userService.changePassword(phone, password)) {
            map.put("code",1);
            session.removeAttribute("user");
        }
        return map;
    }

    /**
     * 退出登录
     */
    @RequestMapping("/logout")
    public String logout(HttpSession session){
        //清除保存的用户session
        session.removeAttribute("user");
        return "redirect:login";
    }

    /**
     * 获取电影安排
     * @param movieId 电影id
     * @return
     */
    @RequestMapping("/getArrangement")
    @ResponseBody
    public Map<String,Object> getArrangement(@RequestParam("movieId")Long movieId){
        Map<String,Object> map = new HashMap<>();
        map.put("data",arrangementService.getArrangementByDate(movieId));
        return map;
    }

    /**
     * 跳转到订单列表
     */
    @RequestMapping("/toOrderList")
    public String toOrderList(HttpSession session,
                               @RequestParam(value = "currentPage",defaultValue = "0")Integer currentPage,
                               Model model){
        User user =(User)session.getAttribute("user");
        if (user == null){
            return "redirect:/user/login";
        }
        Map<String,Object> pageMap = new HashMap<>();
        pageMap.put("currentPage",currentPage);
        pageMap.put("total",orderService.getOrderPageNumber(user.getId()));
        model.addAttribute("page",pageMap);
        model.addAttribute("orderList",orderService.getOrderListByPage(currentPage,user.getId()));
        return "order";
    }

    /**
     * 跳转到选座
     * @param
     * @return
     */
    @RequestMapping("/seat/{arrangementId}")
    public String seat(Model model,
                       HttpSession session,
                       @PathVariable("arrangementId") Long arrangementId) {
        if (session.getAttribute("user") == null){
            return "redirect:/user/login";
        }
        List<Row> result = screeningRoomService.getSeats(arrangementId);
        model.addAttribute("seat", result);
        System.out.println(result);
        model.addAttribute("arrangementId",arrangementId);
        return "seat";
    }

    /**
     * 提交订单
     */
    @ResponseBody
    @RequestMapping("/order")
    public Map<String, Object> order(@RequestParam("seats")String seats,
                                     @RequestParam("arrangementId")Long arrangementId,
                                     HttpSession session) {
        User user = (User)session.getAttribute("user");
        Integer result = orderService.addOrder(seats, arrangementId, user.getId());
        Map<String, Object> map = new HashMap<>();
        map.put("result",result);
        return map;
    }

    /**
     * 修改订单状态
     * @param
     * action : 1:支付订单  2：取消订单
     */
    @RequestMapping("/updateOrder")
    public String updateOrder(@RequestParam("orderId")Long orderId,
                              @RequestParam("action")Integer action){
        orderService.updateOrderStatus(orderId, action);
        return "redirect:/user/toOrderList";
    }

    /**
     * 跳转到公告 后端分页
     */
    @RequestMapping("/notice")
    public String notice(@RequestParam(value = "currentPage",defaultValue = "0")Integer currentPage,
                         Model model){
        List<Notice> noticeList = noticeService.getNoticeByPage(currentPage);
        Map<String,Object> pageMap = new HashMap<>();
        pageMap.put("currentPage",currentPage);
        pageMap.put("total",noticeService.getNoticeNumber());
        model.addAttribute("page",pageMap);
        model.addAttribute("noticeList",noticeList);
        return "notice";
    }
}
