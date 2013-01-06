class Topic < ActiveRecord::Base
  attr_accessible :content, :creator_id, :creator_name, :no, :tag, :taicii_id, :yes

  belongs_to :taicii

  # 获取最新分页记录 更新时间倒序
  def self.getNew(pageNum, pageSize)
  	@topics = Topic.paginate(:page => pageNum, :per_page => pageSize, :order => 'updated_at desc')
  	return @topics
  end

  # 获取一周内推荐分页记录 7天内，yes-no倒序
  def self.getWeekTop(pageNum, pageSize)

  	@topics = Topic.paginate(:page => pageNum, :per_page => pageSize, :conditions => ["created_at > now()- interval '7 day' "],:order => "(yes-no) desc,updated_at desc")
  	return @topics
  end
end
