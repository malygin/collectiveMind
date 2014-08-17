module BaseComment  extend ActiveSupport::Concern
  included do
    attr_accessible :content, :user, :censored, :post_id, :comment_id, :discontent_status, :concept_status, :discuss_status
    belongs_to :user
    belongs_to :post

    has_many :comments, :foreign_key => 'comment_id'
    belongs_to :comment, :foreign_key => 'comment_id'

    has_many :comment_votings
    has_many :users, :through => :comment_votings
        default_scope :order => 'created_at ASC'

    has_many :comment_votings_pro,:conditions => ['against = ?',false], :source => :comment_votings, :class_name => 'CommentVoting'
    has_many :users_pro, :through => :comment_votings_pro, :source => :user

    has_many :comment_votings_against,:conditions => ['against = ?',true], :source => :comment_votings, :class_name => 'CommentVoting'
    has_many :users_against, :through => :comment_votings_against, :source => :user

    has_many :improve_disposts,:foreign_key => 'improve_comment', :conditions => {:improve_stage => [1,2]}, :source => :discontent_posts, :class_name => 'Discontent::Post'
    has_many :improve_concepts,:foreign_key => 'improve_comment', :conditions => {:improve_stage => [1,2,3]}, :source => :concept_posts, :class_name => 'Concept::Post'

    def get_class
      self.class.name.deconstantize
    end
  end
end
