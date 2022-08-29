package cinema.service;

import cinema.entities.Arrangement;
import cinema.entities.ScreeningRoom;
import cinema.entities.ext.Row;
import cinema.mapper.ArrangementMapper;
import cinema.mapper.MovieMapper;
import cinema.mapper.ScreeningRoomMapper;
import cinema.util.MathUtil;
import cinema.util.SeatUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.text.DateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author Mango
 * @Date: 2021/5/29 9:33:50
 */
@Service
@Transactional(rollbackFor = Exception.class)
public class ArrangementService {

    @Resource
    private ArrangementMapper arrangementMapper;

    @Resource
    private ScreeningRoomMapper screeningRoomMapper;

    @Resource
    private MovieMapper movieMapper;

    public List<Arrangement> getByMovieId(Long id) {
        List<Arrangement> list = arrangementMapper.getByMovieId(id);
        for (Arrangement arrangement : list) {
            arrangement.setMovieName(movieMapper.detail(arrangement.getMovieId()).getName());
            arrangement.setRoomChinese(MathUtil.format(screeningRoomMapper.getById(arrangement.getRoomId()).getNumber()) + "号厅");
        }
        return list;
    }

    public List<Row> getById(Long id) {
        Arrangement arrangement = arrangementMapper.getById(id);
        List<Row> seats = SeatUtil.getSeats(arrangement.getSeat());
        return seats;
    }

    public Integer delById(Long id) {
        return arrangementMapper.delById(id);
    }

    public Integer addArrangement(Arrangement arrangement) {
        ScreeningRoom screeningRoom = screeningRoomMapper.getOne(arrangement.getRoomId());
        arrangement.setSeat(screeningRoom.getSeat());
        System.out.println("arrangement = " + arrangement);
        return arrangementMapper.addArrangement(arrangement);
    }


    /**
     *  获取电影安排
     */
    public List<Map<String,Object>> getArrangementByDate(Long movieId){
        List<Map<String,Object>> list = new ArrayList<>();
        List<Arrangement> arrangementList = arrangementMapper.getArrangementByDate(movieId);
        //将电影安排按照日期分组
        String temp = null;
        DateFormat dateFormat = DateFormat.getDateInstance();
        List<Arrangement> tempList = new ArrayList<>();
        for (int i = 0; i < arrangementList.size(); i++) {
            Arrangement arrangement = arrangementList.get(i);
            arrangement.setRoomChinese(MathUtil.format(screeningRoomMapper.getById(arrangement.getRoomId()).getNumber()) + "号厅");
            if (temp == null){
                temp = dateFormat.format(arrangement.getStartTime());
            }
            if (temp.equals(dateFormat.format(arrangement.getStartTime()))){
                tempList.add(arrangement);
            } else {
                Map<String,Object> map = new HashMap<>();

                map.put("date",temp);
                map.put("list",tempList);
                list.add(map);
                tempList = new ArrayList<>();
                temp = dateFormat.format(arrangement.getStartTime());
                tempList.add(arrangement);
            }
        }
        Map<String,Object> map = new HashMap<>();
        map.put("date",temp);
        map.put("list",tempList);
        list.add(map);
        System.out.println(list.size());
        return list;
    }
}
