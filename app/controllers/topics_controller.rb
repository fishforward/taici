class TopicsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create] 

  # GET /topics
  # GET /topics.json
  def index
    @topics = Topic.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @topics }
    end
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
    @topic = Topic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @topic }
    end
  end

  # GET /topics/new
  # GET /topics/new.json
  def new
    @topic = Topic.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @topic }
    end
  end

  # GET /topics/1/edit
  def edit
    @topic = Topic.find(params[:id])
  end

  # POST /topics
  # POST /topics.json
  def create

    taicii_id = params[:taicii_id]
    topic_content = params[:topic_content]

    if taicii_id.blank? || topic_content.blank? 
      respond_to do |format|
        flash.now[:message] = "Empty!"
        format.html { render action: "new" }
      end
    elsif

      @topic = Topic.new
      @topic.taicii_id = taicii_id
      @topic.content = topic_content
      @topic.creator_id = current_user.id
      @topic.creator_name = current_user.nick_name
      @topic.tag = ''
      @topic.yes = 0
      @topic.no = 0

      retMap={}
      retMap['topic'] = @topic
      retMap['user'] = current_user

      respond_to do |format|
        if @topic.save
          format.html { redirect_to @topic, notice: 'Topic was successfully created.' }
          format.json { render json: retMap, status: :created }
        else
          format.html { render action: "new" }
          format.json { render json: @topic.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /topics/1
  # PUT /topics/1.json
  def update
    @topic = Topic.find(params[:id])

    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        format.html { redirect_to @topic, notice: 'Topic was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to topics_url }
      format.json { head :no_content }
    end
  end
end
