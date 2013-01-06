class Comment < ActiveRecord::Base
  attr_accessible :body, :creator_id, :creator_name, :no, :subject, :target_id, :target_type, :title, :yes


	def self.find_on_page(target_id,page_num, page_size)

		target_type = 'TOPIC_COMMENT'
		find(:all,
			:conditions => ["target_id = ? and target_type = ?",target_id, target_type],
			:order => "id",
			:limit => page_size,
			:offset => page_num*page_size)

	end

	def self.create_topic_comment(topic_id, body, creator_id, creator_name)
		comment = Comment.new
		comment.target_id = topic_id.to_i
		comment.target_type = 'TOPIC_COMMENT'
		comment.title = ''
		comment.body = body
		comment.subject = ''
		comment.creator_id = creator_id
		comment.creator_name = creator_name
		comment.yes = 0
		comment.no = 0
		comment
	end
end
