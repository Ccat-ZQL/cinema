import cinema.constant.SeatConstant;
import cinema.entities.ext.Row;
import cinema.util.FileUtil;
import cinema.util.SeatUtil;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * @author Mango
 * @Date: 2021/5/26 1:32:21
 */
public class Test {

    public static void main(String[] args) {
//        String content = FileUtil.readFileContent("D:\\IDEA-2019.2.3\\cinema\\cinema\\src\\seat.json");
//        JSONArray array = JSON.parseArray(JSONObject.parseObject(content).get("row").toString());
//        List<Map<Integer, List<Map<String, Object>>>> list = new ArrayList<>();
//        AtomicInteger index = new AtomicInteger(1);
//        array.forEach(row -> {
//            Map<Integer, List<Map<String, Object>>> seatsMap = new HashMap<>();
//            List<Map<String, Object>> seatList = new ArrayList<>();
//            JSONArray seats = JSONArray.parseArray(JSONObject.parseObject(row.toString()).get(index.get()).toString());
//            seats.forEach(seat -> {
//                Map<String, Object> seatMap = new HashMap<>();
//                seatMap.put(SeatConstant.INDEX, JSONObject.parseObject(seat.toString()).getString(SeatConstant.INDEX));
//                seatMap.put(SeatConstant.IS_SHOW, JSONObject.parseObject(seat.toString()).getBoolean(SeatConstant.IS_SHOW));
//                seatMap.put(SeatConstant.IS_OCCUPIED, JSONObject.parseObject(seat.toString()).getBoolean(SeatConstant.IS_OCCUPIED));
//                seatList.add(seatMap);
//            });
//            seatsMap.put(index.get(), seatList);
//            list.add(seatsMap);
//            index.getAndIncrement();
//        });
//        System.out.println("list = " + list);
        String[] seats = new String[]{"1-5", "2-5"};
        changeSeatJson(seats, null, 1L);
    }

    private static void changeSeatJson(String[] seats,String json,Long id){
        String content = FileUtil.readFileContent("D:\\IDEA-2019.2.3\\cinema\\cinema\\src\\seat.json");
        List<Row> rowList = SeatUtil.getSeats(content);
        List<Map<Integer, List<Row.Seat>>> result = new ArrayList<>();
        for (Row row : rowList){
            List<Row.Seat> list = new ArrayList<>();
            for (Row.Seat seat : row.getSeats()){
                for (String index : seats){
                    if (index.equals(seat.getIndex())){
                        seat.setOccupied(true);
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
        System.out.println(JSONObject.toJSON(map));

        //将list改成json格式字符串 更新数据库
//        arrangementMapper.updateSeats(JSONObject.toJSON(rowList).toString(),id);
    }
}
