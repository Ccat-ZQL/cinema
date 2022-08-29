package cinema.service;

import cinema.entities.Arrangement;
import cinema.entities.Movie;
import cinema.entities.Order;
import cinema.entities.ScreeningRoom;
import cinema.entities.ext.Row;
import cinema.mapper.ArrangementMapper;
import cinema.mapper.MovieMapper;
import cinema.mapper.OrderMapper;
import cinema.mapper.ScreeningRoomMapper;
import cinema.util.MathUtil;
import cinema.util.SeatUtil;
import cinema.util.SnowflakeIdUtil;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import org.aspectj.weaver.ast.Or;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.*;

@Service
@Transactional(rollbackFor = Exception.class)
public class OrderService {
    @Resource
    private OrderMapper orderMapper;
    @Resource
    private ArrangementMapper arrangementMapper;
    @Resource
    private MovieMapper movieMapper;
    @Resource
    private ScreeningRoomMapper screeningRoomMapper;

    private static Integer PAGE_SIZE = 10;

    /**
     * 分页获取订单详情
     * 每页10条记录
     */
    public List<Map<String,Object>> getOrderListByPage(Integer currentPage, Long userId){
        List<Map<String,Object>> list = new ArrayList<>();
        List<Order> orderList = orderMapper.getOrderListByPage(currentPage*PAGE_SIZE, userId,PAGE_SIZE);
        for (Order order:orderList){
            Map<String,Object> map = new HashMap<>();
            Arrangement arrangement = arrangementMapper.getById(order.getArrangementId());
            arrangement.setRoomChinese(MathUtil.format(screeningRoomMapper.getById(arrangement.getRoomId()).getNumber()) + "号厅");
            Movie movie = movieMapper.detail(arrangement.getMovieId());
            String[] seatStrings = order.getSeat().split("\\,");
            String seatChinese = "";
            for (String str : seatStrings){
                str = str.replace("-","排") + "座 ";
                seatChinese +=str;
            }
            order.setSeat(seatChinese);
            map.put("movie",movie);
            map.put("arrangement",arrangement);
            map.put("order",order);
            list.add(map);
        }
        return list;
    }

    public Integer getOrderPageNumber(Long userId){
        return (orderMapper.getOrderNumberById(userId)/PAGE_SIZE);
    }

    /**
     * 提交订单
     */
    public Integer addOrder(String seats,Long arrangementId,Long userId){
        String[] seatStrings = seats.split("\\,");
        Integer number = seatStrings.length;
        Arrangement arrangement = arrangementMapper.getById(arrangementId);
        //更新座位
        updateSeatJson(seatStrings,arrangement.getSeat(),arrangementId,true);
        //生成订单实体类
        Order order = new Order();
        order.setArrangementId(arrangementId);
        order.setTicketNumber(number);
        order.setSeat(seats);
        order.setMoney(arrangement.getPrice()*number);
        order.setTime(new Date());
        order.setNumber(String.valueOf(SnowflakeIdUtil.getSnowflakeId()));
        order.setUserId(userId);
        order.setStatus(0);

        return orderMapper.addOrder(order);
    }

    /**
     * 更新订单状态
     */
    public void updateOrderStatus(Long orderId,Integer action){
        orderMapper.updateStatus(orderId,action);
        //取消订单，空出座位
        if (action == 2){
            Order order = orderMapper.getById(orderId);
            Arrangement arrangement = arrangementMapper.getById(order.getArrangementId());
            updateSeatJson(order.getSeat().split("\\,"),arrangement.getSeat(),arrangement.getId(),false);
        }
    }

    /**
     * 安排表中座位状态更新
     * action: true 占座  false:取消订单后空出座位
     */
    private void updateSeatJson(String[] seats,String json,Long id,Boolean action){
        List<Row> rowList = SeatUtil.getSeats(json);
        List<Map<Integer, List<Row.Seat>>> result = new ArrayList<>();
        for (Row row : rowList){
            List<Row.Seat> list = new ArrayList<>();
            for (Row.Seat seat : row.getSeats()){
                for (String index : seats){
                    if (index.equals(seat.getIndex())){
                        seat.setOccupied(action);
                        break;
                    }
                }
                list.add(seat);
            }
            Map<Integer, List<Row.Seat>> map = new HashMap<>();
            map.put(row.getIndex(), list);
            result.add(map);
        }

        Map<String,Object> map = new HashMap<>();

        map.put("row",JSONObject.toJSON(result));
        //将list改成json格式字符串 更新数据库
        arrangementMapper.updateSeats(JSONObject.toJSON(map).toString(),id);
    }

    /**
     * 获取该用户的所有的订单
     * @param userID
     * @return
     */
    public List<Order> getAllOrder(Long userID) {
        List<Order> result = orderMapper.getUserOrder(userID);
        for (Order order : result) {
            Arrangement arrangement = arrangementMapper.getById(order.getArrangementId());
            ScreeningRoom screeningRoom = screeningRoomMapper.getById(arrangement.getRoomId());
            order.setPrice(arrangement.getPrice());
            order.setScreeningRoom(MathUtil.format(screeningRoom.getNumber()) + "号厅");
        }
        return result;
    }

    /**
     * 管理员取消订单
     * @param id
     * @return
     */
    public Integer cancelOrder(Long id) {
        return orderMapper.updateStatus(id, 2);
    }

    /**
     * 条件查询所有的订单
     * @param key
     * @return
     */
    public List<Order> getAllOrders(String key) {
        List<Order> result = orderMapper.getAllOrders(key);
        for (Order order : result) {
            Arrangement arrangement = arrangementMapper.getById(order.getArrangementId());
            ScreeningRoom screeningRoom = screeningRoomMapper.getOne(arrangement.getRoomId());
            order.setScreeningRoom(MathUtil.format(screeningRoom.getNumber()) + "号厅");
            order.setPrice(arrangement.getPrice());
        }
        return result;
    }
}
