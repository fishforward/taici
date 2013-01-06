# encoding: utf-8
class SymbolsController < ApplicationController
	before_filter :authenticate_user!, :except => [:index, :show, :top]

  def top
  	 @taiciis = Taicii.paginate(:conditions => ["t_type=? ","YEAR_SYMBOL_LETTER" ], :page => params[:page], :per_page => 10, :order => '(yes-no) desc')
    
    # 台词id列表
    t_ids = []
    @taiciis.each do |t|
      t_ids << t.id
    end
    
    @feel_ids = []
    @no_feel_ids = []

    if t_ids.empty?
    	respond_to do |format|
	      format.html # index.html.erb
	      format.json { render json: nil }
	    end
    else

	    # 登录用户才需要
	    if current_user
	      
	      @feel_ids = Stand.getTaiciiDing(current_user.id, t_ids)
	      @no_feel_ids = Stand.getTaiciiCai(current_user.id, t_ids)
	    end
	    
	    # topic 优化查询
	    @topicMap = {}
	    topics = Topic.find_all_by_taicii_id(t_ids)
	    topics.each do |topic|
	    	@topicMap[topic.taicii_id] = topic
	    end

	    map = {"taiciis" => @taiciis, "topicMap" => @topicMap, "feel_ids" => @feel_ids, "no_feel_ids" => @no_feel_ids}
	    respond_to do |format|
	      format.html # index.html.erb
	      format.json { render json: map }
	    end
	end
  end

  # GET /symbols
  # GET /symbols.json
  def index
    taiciis = Taicii.paginate(:conditions => ["t_type=? ","YEAR_SYMBOL_LETTER" ], :page => params[:page], :per_page => 1, :order => '(yes-no) desc')
    @top_taicii = taiciis[0]

    @topics = Topic.paginate( :page => params[:page], :per_page => 20, :order => 'updated_at desc')
    
    # 台词id列表
    t_ids = []
    t_ids << @top_taicii.id
    @topics.each do |t|
      t_ids << t.taicii_id
    end
    
    @feel_ids = []
    @no_feel_ids = []

    # 登录用户才需要
    if current_user
      
      @feel_ids = Stand.getTaiciiDing(current_user.id, t_ids)
      @no_feel_ids = Stand.getTaiciiCai(current_user.id, t_ids)
    end

    #组装台词map
    @taiciiMap = {}
    taiciis = Taicii.find_all_by_id(t_ids)
    taiciis.each do |tc|
    	@taiciiMap[tc.id]=tc
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @taiciiMap | @topics | @top_taicii | @feel_ids | @no_feel_ids }
    end
  end

  # GET /symbols/1
  # GET /symbols/1.json
  def show
    @taicii = Taicii.find(params[:id])
    
    t_ids = []
    t_ids << @taicii.id

    @shoucang_ids = []# 被当前用户收藏列表
    @feel_ids = []
    @no_feel_ids = []
    # 登录用户才需要
    if current_user

      @feel_ids = Stand.getTaiciiDing(current_user.id, t_ids)
      @no_feel_ids = Stand.getTaiciiCai(current_user.id, t_ids)
      
    end

    respond_to do |format|
      format.html # show.html.erb
      #format.json { render json: @taicii }
    end
  end

  # GET /taiciis/new
  # GET /taiciis/new.json
  def new
    @taicii = Taicii.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @taicii }
    end
  end

  # POST /symbols
  # POST /symbols.json
  def create

    taicii_content = params[:taicii_content]
    t_type = 'YEAR_SYMBOL_LETTER'
    source = 'SYMBOL_IN'
    topic_content = params[:topic_content]

    puts 'xxxxxxxxx'
    if taicii_content.blank? || t_type.blank? || source.blank? || topic_content.blank?
      respond_to do |format|
        flash.now[:message] = "请选择年度字及原因!"
        format.html { render action: "new" }
      end

    elsif taicii_content.size()>1
      respond_to do |format|
        flash.now[:message] = "请输入一个汉字!"
        format.html { render action: "new" }
      end

    else
	    oldTaiciis = Taicii.find_all_by_content_and_t_type(taicii_content,t_type)

	    if !oldTaiciis.empty? 
	    	@taicii=oldTaiciis[0]
	    else
		      #taicii init
		      @taicii = Taicii.new()
		      @taicii.content = taicii_content
		      @taicii.t_type = t_type
		      @taicii.source = source
		      @taicii.creator_id = current_user.id
		      @taicii.creator_name = current_user.nick_name
		      @taicii.yes = 0
		      @taicii.no = 0
		      #@taicii.tag = 
		end

	    #topic init
	    @topic = Topic.new()
	    @topic.content = topic_content
	    @topic.creator_id = current_user.id
	    @topic.creator_name = current_user.nick_name
	    @topic.yes = 0
	    @topic.no = 0
	    #@topic.tag = 

	    puts 'save'
	    respond_to do |format|
	        if @taicii.save
	          @topic.taicii_id = @taicii.id
	          @topic.save

	          format.html { redirect_to '/symbols/'+@taicii.id.to_s, notice: 'Taicii was successfully created.' }
	          #format.json { render json: @taicii, status: :created, location: @taicii }
	        else
	          format.html { render action: "new" }
	          #format.json { render json: @taicii.errors, status: :unprocessable_entity }
	        end
	    end
    end
  end

  protected
  
  # GET /taiciis/1/edit
  def edit
    @taicii = Taicii.find(params[:id])
  end

end