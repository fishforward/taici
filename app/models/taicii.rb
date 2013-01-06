class Taicii < ActiveRecord::Base
  attr_accessible :content, :creator_id, :creator_name, :no, :source, :tag, :t_type, :yes

  has_many :topics, :order =>'(yes-no) desc,updated_at desc'
end
