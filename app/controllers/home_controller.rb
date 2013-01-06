# encoding: utf-8
class HomeController < ApplicationController
	before_filter :authenticate_user!, :only => [:me]

  def me
    if current_user
      @user = current_user
    end
  end

  def about_symbol

  end
	
  protected
  
  def index

  	## 1.最近动态
  	page = params[:page]&&params[:page].to_i>0 ? params[:page] : 1
  	@topics = Topic.paginate(:page => page, :per_page => 10, :order => 'updated_at desc')

  	if @topics.empty?
  		@topics = Topic.paginate(:page => 1, :per_page => 10, :order => 'updated_at desc')
  	end 

  	## 2.推荐
  	## select * from topics where created_at >now()- interval  '7 day' order by (yes-no) desc,updated_at desc;
  	if page || page==1
  		week_topics = Topic.getWeekTop(1,1)
    end

    # 台词id列表
    t_ids = []
    topicIds = []

    @topics.each do |t|
  		t_ids << t.taicii_id
  		topicIds << t.id
  	end

  	@top_topics = []
  	if !week_topics.empty?
	    @top_topics = week_topics
	  	t_ids << week_topics[0].taicii_id
	  	topicIds << week_topics[0].id
  	end
    
    @shoucang_ids = []# 被当前用户收藏列表
    @feel_ids = []
    @no_feel_ids = []

    # 登录用户才需要
    if current_user && topicIds.size >0 
      
      @shoucang_ids = Stand.getShoucang(current_user.id, t_ids)
      @feel_ids = Stand.getFeel(current_user.id, topicIds)
      @no_feel_ids = Stand.getNoFeel(current_user.id, topicIds)
    end

    ## 评论数
    @commentHash = {}
    @top_topics.each do |t|
      comments = Comment.find_on_page(t.id, 0, 100)
      @commentHash[t.id] = comments
    end
    @topics.each do |t|
      comments = Comment.find_on_page(t.id, 0, 100)
      @commentHash[t.id] = comments
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @topics | @top_topics | @shoucangIds | @feel_ids | @no_feel_ids }
    end
  end

  def week
  	## 1.最近动态
  	page = params[:page]&&params[:page].to_i>0 ? params[:page] : 1
  	@topics = Topic.getWeekTop(page,10)

  	if @topics.empty?
  		page = 1
		@topics = Topic.getWeekTop(page,10)
  	end 

    # 台词id列表
    t_ids = []
    topicIds = []

    @topics.each do |t|
  		t_ids << t.taicii_id
  		topicIds << t.id
  	end
    
    @shoucang_ids = []# 被当前用户收藏列表
    @feel_ids = []
    @no_feel_ids = []

    # 登录用户才需要
    if current_user && topicIds.size >1 
      
      @shoucang_ids = Stand.getShoucang(current_user.id, t_ids)
      @feel_ids = Stand.getFeel(current_user.id, topicIds)
      @no_feel_ids = Stand.getNoFeel(current_user.id, topicIds)
    end

    ## 评论数
    @commentHash = {}
    @topics.each do |t|
      comments = Comment.find_on_page(t.id, 0, 100)
      @commentHash[t.id] = comments
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @topics | @shoucangIds | @feel_ids | @no_feel_ids }
    end
  end

end
