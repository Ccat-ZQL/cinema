package cinema.constant;

/**
 * @author Mango
 * @Date: 2021/5/28 16:14:42
 */
public class FileConstant {

    /**
     * 文件名
     */
    public static final String FILE_NAME = "fileName";

    /**
     * 文件状态码
     */
    public static final String CODE = "code";

    /**
     * 图片存储路径
     */
    public static final String PIC_PATH = "/pic";

    /**
     * 文件提示信息
     */
    public enum Tips {
        /**
         * 文件删除成功
         */
        FILE_DELETE_SUCCESS(2, "文件删除成功"),

        /**
         * 文件上传成功
         */
        FILE_UPLOAD_SUCCESS(1, "文件上传成功"),

        /**
         * 文件不存在
         */
        FILE_NOT_EXIST(0, "文件不存在"),

        /**
         * 文件上传失败
         */
        FILE_UPLOAD_FAIL(-1, "文件上传失败"),

        /**
         * 文件删除失败
         */
        FILE_DELETE_FAIL(-2, "文件删除失败")
        ;
        private Integer code;
        private String info;

        Tips(Integer code, String info) {
            this.code = code;
            this.info = info;
        }

        public Integer getCode() {
            return code;
        }

        public String getInfo() {
            return info;
        }
    }
}
