package cinema.util;

import cinema.constant.SeatConstant;
import cinema.entities.ext.Row;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * @author Mango
 * @Date: 2021/5/26 11:58:04
 */
public class SeatUtil {

    public static List<Row> getSeats(String content) {
        JSONArray array = JSON.parseArray(JSONObject.parseObject(content).get(SeatConstant.ROW).toString());
        List<Row> result = new ArrayList<>();
        AtomicInteger index = new AtomicInteger(1);
        array.forEach(arr -> {
            Row row = new Row();
            row.setIndex(index.get());
            List<Row.Seat> seatArrayList = new ArrayList<>();
            JSONArray seats = JSONArray.parseArray(JSONObject.parseObject(arr.toString()).get(index.get()).toString());
            seats.forEach(seat -> {
                Row.Seat rowSeat = new Row.Seat();
                rowSeat.setIndex(JSONObject.parseObject(seat.toString()).getString(SeatConstant.INDEX));
                rowSeat.setShow(JSONObject.parseObject(seat.toString()).getBoolean(SeatConstant.IS_SHOW));
                rowSeat.setOccupied(JSONObject.parseObject(seat.toString()).getBoolean(SeatConstant.IS_OCCUPIED));
                seatArrayList.add(rowSeat);
            });
            row.setSeats(seatArrayList);
            result.add(row);
            index.getAndIncrement();
        });
        return result;
    }

}
