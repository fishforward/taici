class Stand < ActiveRecord::Base
  attr_accessible :a, :b, :creator_id, :creator_name, :status, :s_type

  ####################### 获取列表 #####################################################################
  # 获取收藏ID列表
  def self.getShoucang(creator_id, taicii_ids)
   	shoucang_ids = getStands(creator_id, taicii_ids, 'SHOUCANG')
  end

  # 获取应景ID列表
  def self.getFeel(creator_id, topic_ids)
   	feel_ids = getStands(creator_id, topic_ids, 'FEEL')
  end

  # 获取没感觉ID列表
  def self.getNoFeel(creator_id, topic_ids)
   	no_feel_ids = getStands(creator_id, topic_ids, 'NO_FEEL')
  end

  
  # 获取taicii顶 列表
  def self.getTaiciiDing(creator_id, topic_ids)
    ids = getStands(creator_id, topic_ids, 'TAICII_DING')
  end

  # 获取taicii踩 列表
  def self.getTaiciiCai(creator_id, topic_ids)
    ids = getStands(creator_id, topic_ids, 'TAICII_CAI')
  end


  # 公共查询方法
  def self.getStands(creator_id, a_ids, s_type)
  	stands = Stand.find_by_sql("select * from stands where s_type='" + s_type  +"' and b="+creator_id.to_s + " and a in("+a_ids.join(',')+")")      
    stand_ids = []
    stands.each do |s|
	    stand_ids << s.a
    end
    return stand_ids
  end

  ####################### 单个判断 #####################################################################
  # 判断是否有收藏、应景、没感觉等 返回对象
  def self.isStand(creator_id, a, s_type)
  	stands = Stand.find_by_sql("select * from stands where s_type='" + s_type  +"' and b="+creator_id.to_s + " and a = " + a.to_s)      
    
    if stands && stands[0]
	    return stands[0]
    else
    	return nil
    end
  end

end
