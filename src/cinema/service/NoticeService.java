package cinema.service;

import cinema.entities.Notice;
import cinema.mapper.NoticeMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

/**
 * @author ：ZQL
 * @date ：Created in 2021/6/1 3:05
 */
@Service
@Transactional(rollbackFor = Exception.class)
public class NoticeService {
    @Resource
    private NoticeMapper noticeMapper;

    private static Integer PAGE_SIZE = 10;

    /**
     * 创建公告
     */
    public Integer createNotice(String title,String content){
        Notice notice = new Notice();
        notice.setTitle(title);
        notice.setContent(content);
        notice.setPublishTime(new Date());

        return noticeMapper.createNotice(notice);
    }

    /**
     * 获取所有公告
     */
    public List<Notice> getAllNotice(){
        return noticeMapper.getAllNotice();
    }

    /**
     * 删出公告
     */
    public Integer deleteByIds(String ids){
        String[] split = ids.split("\\,");
        for (String id : split){
            noticeMapper.deleteById(Long.parseLong(id));
        }
        return 1;
    }

    /**
     * 单个删除
     * @param id
     * @return
     */
    public Integer delOne(Long id) {
        return noticeMapper.deleteById(id);
    }

    /**
     * 分页获取公告
     */
    public List<Notice> getNoticeByPage(Integer currentPage){
        return noticeMapper.getNoticeByPage((currentPage*PAGE_SIZE),PAGE_SIZE);
    }

    /**
     * 查询公告页数
     */
    public Integer getNoticeNumber(){
        return noticeMapper.getNoticeNumber()/PAGE_SIZE;
    }
}
