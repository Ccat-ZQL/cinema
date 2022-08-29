package cinema.util;

/**
 * @author Mango
 * @Date: 2021/5/29 8:54:32
 */
public class MathUtil {

    public static final String[] chinese = {"零", "一", "二", "三", "四", "五", "六", "七", "八", "九"};

    /**
     * 个位
     * 数字转化成汉字
     * @param number
     * @return
     */
    public static String format(Integer number) {
        return chinese[number];
    }
}
