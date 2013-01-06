class TaiciisController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  
  # GET /taiciis
  # GET /taiciis.json
  def index
    @taiciis = Taicii.paginate(:page => params[:page], :per_page => 11, :order => 'yes desc')
    
    # 台词id列表
    t_ids = []
    topicIds = []
    @taiciis.each do |t|
      t_ids << t.id
      topicIds << t.topics[0].id
    end
    
    @shoucang_ids = []# 被当前用户收藏列表
    @feel_ids = []
    @no_feel_ids = []

    # 登录用户才需要
    if current_user
      
      @shoucang_ids = Stand.getShoucang(current_user.id, t_ids)
      @feel_ids = Stand.getFeel(current_user.id, topicIds)
      @no_feel_ids = Stand.getNoFeel(current_user.id, topicIds)
    end

    @top_taicii = @taiciis[0]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @taiciis | @top_taicii | @shoucangIds | @feel_ids | @no_feel_ids }
    end
  end

  # GET /taiciis/1
  # GET /taiciis/1.json
  def show
    @taicii = Taicii.find(params[:id])
    
    topicIds = []
    t_ids = []
    t_ids << @taicii.id
    @taicii.topics.each do |t|
      topicIds << t.id
    end

    @shoucang_ids = []# 被当前用户收藏列表
    @feel_ids = []
    @no_feel_ids = []
    # 登录用户才需要
    if current_user

      @shoucang_ids = Stand.getShoucang(current_user.id, t_ids)
      @feel_ids = Stand.getFeel(current_user.id, topicIds)
      @no_feel_ids = Stand.getNoFeel(current_user.id, topicIds)
      
    end

    @commentHash ={}
    @taicii.topics.each do |t|
      comments = Comment.find_on_page(t.id, 0, 100)
      @commentHash[t.id] = comments
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

  # GET /taiciis/1/edit
  def edit
    @taicii = Taicii.find(params[:id])
  end

  # POST /taiciis
  # POST /taiciis.json
  def create

    taicii_content = params[:taicii_content]
    t_type = params[:t_type]
    source = params[:source]
    topic_content = params[:topic_content]

    if taicii_content.blank? || t_type.blank? || source.blank? || topic_content.blank?
      respond_to do |format|
        flash.now[:message] = "Empty!"
        format.html { render action: "new" }
      end

    elsif
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

      #topic init
      @topic = Topic.new()
      @topic.content = topic_content
      @topic.creator_id = current_user.id
      @topic.creator_name = current_user.nick_name
      @topic.yes = 0
      @topic.no = 0
      #@topic.tag = 

      respond_to do |format|
        if @taicii.save
          @topic.taicii_id = @taicii.id
          @topic.save

          format.html { redirect_to @taicii, notice: 'Taicii was successfully created.' }
          #format.json { render json: @taicii, status: :created, location: @taicii }
        else
          format.html { render action: "new" }
          #format.json { render json: @taicii.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /taiciis/1
  # PUT /taiciis/1.json
  def update
    @taicii = Taicii.find(params[:id])

    respond_to do |format|
      if @taicii.update_attributes(params[:taicii])
        format.html { redirect_to @taicii, notice: 'Taicii was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @taicii.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /taiciis/1
  # DELETE /taiciis/1.json
  def destroy
    @taicii = Taicii.find(params[:id])
    @taicii.destroy

    respond_to do |format|
      format.html { redirect_to taiciis_url }
      format.json { head :no_content }
    end
  end
end
