package cinema.entities.ext;

import com.alibaba.fastjson.annotation.JSONField;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

/**
 * @author Mango
 * @Date: 2021/5/26 2:27:46
 */
public class Row {

    private Integer index;

    private List<Seat> seats;

    public Row() {

    }

    public List<Seat> getSeats() {
        return seats;
    }

    public void setSeats(List<Seat> seats) {
        this.seats = seats;
    }

    public Integer getIndex() {
        return index;
    }

    public void setIndex(Integer index) {
        this.index = index;
    }

    @Override
    public String toString() {
        return "Row{" +
                "index=" + index +
                ", seats=" + seats +
                '}';
    }

    public static class Seat {

        private String index;

        private Boolean isOccupied;

        private Boolean isShow;

        public Seat() {

        }

        public String getIndex() {
            return index;
        }

        public void setIndex(String index) {
            this.index = index;
        }

        public Boolean getIsOccupied() {
            return isOccupied;
        }

        public void setOccupied(Boolean occupied) {
            isOccupied = occupied;
        }

        public Boolean getIsShow() {
            return isShow;
        }

        public void setShow(Boolean show) {
            isShow = show;
        }

        @Override
        public String toString() {
            return "Seat{" +
                    "index='" + index + '\'' +
                    ", isOccupied=" + isOccupied +
                    ", isShow=" + isShow +
                    '}';
        }
    }
}
