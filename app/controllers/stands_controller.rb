class StandsController < ApplicationController
  before_filter :authenticate_user!, :only => :create

  # POST /stands
  # POST /stands.json
  def create   # 收藏专用
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

    already_stand = Stand.find(:first, :conditions => ["a=? and b=? and s_type=?", @stand.a,@stand.b,s_type ])
    
    if already_stand == nil
      tai = Taicii.find(a) 
      tai.yes = tai.yes + 1
      tai.save
    end

    respond_to do |format|
      if already_stand || @stand.save
        format.html { redirect_to @stand, notice: 'Stand was successfully created.' }
        format.json { render json: @stand, status: :created, location: @stand }
      else
        format.html { render action: "new" }
        format.json { render json: @stand.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # GET /stands
  # GET /stands.json
  def index
    @stands = Stand.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stands }
    end
  end

  # GET /stands/1
  # GET /stands/1.json
  def show
    @stand = Stand.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @stand }
    end
  end

  # GET /stands/new
  # GET /stands/new.json
  def new
    @stand = Stand.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @stand }
    end
  end

  # GET /stands/1/edit
  def edit
    @stand = Stand.find(params[:id])
  end

  # PUT /stands/1
  # PUT /stands/1.json
  def update
    @stand = Stand.find(params[:id])

    respond_to do |format|
      if @stand.update_attributes(params[:stand])
        format.html { redirect_to @stand, notice: 'Stand was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @stand.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stands/1
  # DELETE /stands/1.json
  def destroy
    @stand = Stand.find(params[:id])
    @stand.destroy

    respond_to do |format|
      format.html { redirect_to stands_url }
      format.json { head :no_content }
    end
  end
end
