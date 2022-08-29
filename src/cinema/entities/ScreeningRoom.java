package cinema.entities;

/**
 * @author Mango
 * @Date: 2021/5/26 12:20:49
 */
public class ScreeningRoom {

    private Long id;

    private Integer number;

    private String seat;

    private String chineseNumber;

    public String getChineseNumber() {
        return chineseNumber;
    }

    public void setChineseNumber(String chineseNumber) {
        this.chineseNumber = chineseNumber;
    }

    public ScreeningRoom() {

    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Integer getNumber() {
        return number;
    }

    public void setNumber(Integer number) {
        this.number = number;
    }

    public String getSeat() {
        return seat;
    }

    public void setSeat(String seat) {
        this.seat = seat;
    }
}
