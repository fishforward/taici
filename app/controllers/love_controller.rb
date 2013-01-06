class LoveController < ApplicationController
  before_filter :authenticate_user!

  # POST /love/ding.json
  def ding  # ding
    a = params[:a] # 台词id
    #b = params[:b] # 用户id
    s_type = params[:s_type] # 类型：收藏，评论
    comment = params[:comment] # 文字

    @stand = Stand.new()
    @stand.a = a
    @stand.b = current_user.id
    @stand.s_type = s_type
    @stand.comment = comment
    @stand.status = 'Y'
    @stand.creator_id = current_user.id
    @stand.creator_name = current_user.nick_name

    already_feel = Stand.find(:first, :conditions => ["a=? and b=? and s_type=?", @stand.a,@stand.b,s_type ])
    already_no_feel = Stand.find(:first, :conditions => ["a=? and b=? and s_type=?", @stand.a,@stand.b, 'TAICII_CAI' ])
    
    @taicci = Taicii.find(@stand.a)

    # 删除”没感觉“
    if already_no_feel
        Stand.delete(already_no_feel.id)
        @taicci.no = @taicci.no - 1
    end
    if already_feel == nil
        @stand.save
        @taicci.yes = @taicci.yes + 1
    end

    @taicci.save
    map = {"taicci" => @taicci, "stand" => @stand}
    respond_to do |format|
        format.json { render json: map }
    end
  end

  # POST /love/cai.json
  def cai  # 没感觉
    a = params[:a] # 台词id
    #b = params[:b] # 用户id
    s_type = params[:s_type] # 类型：收藏，评论
    comment = params[:comment] # 文字

    @stand = Stand.new()
    @stand.a = a
    @stand.b = current_user.id
    @stand.s_type = s_type
    @stand.comment = comment
    @stand.status = 'Y'
    @stand.creator_id = current_user.id
    @stand.creator_name = current_user.nick_name

    already_no_feel = Stand.find(:first, :conditions => ["a=? and b=? and s_type=?", @stand.a,@stand.b,s_type ])
    already_feel = Stand.find(:first, :conditions => ["a=? and b=? and s_type=?", @stand.a,@stand.b, 'TAICII_DING'])
    
    @taicci = Taicii.find(@stand.a)

    # 删除”应景“
    if already_feel
        Stand.delete(already_feel.id)
        @taicci.yes = @taicci.yes - 1
    end
    if already_no_feel == nil
        @stand.save
        @taicci.no = @taicci.no + 1
    end

    @taicci.save
    map = {"taicci" => @taicci, "stand" => @stand}
    respond_to do |format|
        format.json { render json: map }
    end
  end

  # POST /love/feel.json
  def feel  # 应景
    a = params[:a] # 台词id
    #b = params[:b] # 用户id
    s_type = 'FEEL' # 类型：收藏，评论
    comment = params[:comment] # 文字

    @stand = Stand.new()
    @stand.a = a
    @stand.b = current_user.id
    @stand.s_type = s_type
    @stand.comment = comment
    @stand.status = 'Y'
    @stand.creator_id = current_user.id
    @stand.creator_name = current_user.nick_name

    already_feel = Stand.find(:first, :conditions => ["a=? and b=? and s_type=?", @stand.a,@stand.b,s_type ])
    already_no_feel = Stand.find(:first, :conditions => ["a=? and b=? and s_type=?", @stand.a,@stand.b,'NO_FEEL' ])
    
    @topic = Topic.find(@stand.a)

    # 删除”没感觉“
    if already_no_feel
    	Stand.delete(already_no_feel.id)
    	@topic.no = @topic.no - 1
    end
    if already_feel == nil
    	@stand.save
    	@topic.yes = @topic.yes + 1
    end

    @topic.save
    map = {"topic" => @topic, "stand" => @stand}
    respond_to do |format|
        format.json { render json: map }
    end
  end

  # POST /love/no_feel.json
  def no_feel  # 没感觉
    a = params[:a] # 台词id
    #b = params[:b] # 用户id
    s_type = 'NO_FEEL' # 类型：收藏，评论
    comment = params[:comment] # 文字

    @stand = Stand.new()
    @stand.a = a
    @stand.b = current_user.id
    @stand.s_type = s_type
    @stand.comment = comment
    @stand.status = 'Y'
    @stand.creator_id = current_user.id
    @stand.creator_name = current_user.nick_name

    already_no_feel = Stand.find(:first, :conditions => ["a=? and b=? and s_type=?", @stand.a,@stand.b,s_type ])
    already_feel = Stand.find(:first, :conditions => ["a=? and b=? and s_type=?", @stand.a,@stand.b,'FEEL' ])
    
    @topic = Topic.find(@stand.a)

    # 删除”应景“
    if already_feel
    	Stand.delete(already_feel.id)
    	@topic.yes = @topic.yes - 1
    end
    if already_no_feel == nil
    	@stand.save
    	@topic.no = @topic.no + 1
    end

    @topic.save
    map = {"topic" => @topic, "stand" => @stand}
    respond_to do |format|
        format.json { render json: map }
    end
  end

end