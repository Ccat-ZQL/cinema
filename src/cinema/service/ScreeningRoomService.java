package cinema.service;

import cinema.entities.Arrangement;
import cinema.entities.ScreeningRoom;
import cinema.entities.ext.Row;
import cinema.mapper.ArrangementMapper;
import cinema.mapper.ScreeningRoomMapper;
import cinema.util.MathUtil;
import cinema.util.SeatUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

/**
 * @author Mango
 * @Date: 2021/5/26 12:31:15
 */
@Service
@Transactional
public class ScreeningRoomService {

    @Resource
    private ScreeningRoomMapper screeningRoomMapper;
    @Resource
    private ArrangementMapper arrangementMapper;

    public List<Row> getSeats(Long id) {
        Arrangement arrangement = arrangementMapper.getById(id);
        List<Row> seats = SeatUtil.getSeats(arrangement.getSeat());
        return seats;
    }

    public List<ScreeningRoom> getAllNumberToChinese() {
        List<ScreeningRoom> result = screeningRoomMapper.getAll();
        for (int i = 0; i < result.size(); i++) {
            result.get(i).setChineseNumber(MathUtil.format(result.get(i).getNumber()));
            result.get(i).setSeat(null);
        }
        return result;
    }
}
