class Discontent::Aspect < ActiveRecord::Base
  include BasePost

  attr_accessible :position, :short_desc, :user_add, :status
   has_many :posts
   has_many :positive_posts, :class_name => 'Discontent::Post',
           :conditions => ['discontent_posts.style = ? ',0]
   has_many :negative_posts, :class_name => 'Discontent::Post',
           :conditions => ['discontent_posts.style = ? ',1]
   has_many :accepted_posts, :class_name => 'Discontent::Post',
           :conditions => ['discontent_posts.status = ?',4]

  has_many :life_tape_posts, :class_name => 'LifeTape::Post'
  has_many :discontent_post_aspects, :class_name => 'Discontent::PostAspect'
  has_many :aspect_posts, :through => :discontent_post_aspects, :source => :post, :class_name => 'Discontent::Post'

  has_many :voted_users, :through => :final_votings, :source => :user
  has_many :final_votings,:foreign_key => 'discontent_aspect_id', :class_name => "LifeTape::Voiting"

  has_and_belongs_to_many :life_tape_posts, :class_name => 'LifeTape::Post', join_table: 'discontent_aspects_life_tape_posts', foreign_key: 'discontent_aspect_id', association_foreign_key: 'life_tape_post_id', :conditions => ['status = 0']
  scope :procedurial_only, where(:status, 0)
  scope :by_project, ->(project_id) { where("discontent_aspects.project_id = ?", project_id) }
  scope :minus_view, ->(aspects) { where("discontent_aspects.id NOT IN (#{aspects.join(", ")})") unless aspects.empty? }

  scope :vote_top , ->(revers) {
    if revers == "0"
      order('count("life_tape_voitings"."user_id") DESC')
    elsif revers == "1"
      order('count("life_tape_voitings"."user_id") ASC')
    else
      nil
    end
  }

  def voted(user)
    self.voted_users.where(:id => user)
  end

  def count_concept
   unless  @count_concept
      pr = []
      overpr = {}
      self.aspect_posts.by_status(4).each do |ap|
         if ap.dispost_concepts.size > 1
           pr << 100
           overpr[ap.id] = ( ap.dispost_concepts.size - 2) * 50
         else
           pr << (ap.dispost_concepts.size*50)
         end
      end

      if pr.size == 0
            @count_concept =0
      else
        @count_concept =  pr.inject(0){ |sum,v| sum + v.abs } / pr.size
      end

    end
    return @count_concept
  end

  def self.scope_vote_top(project,revers)
    includes(:final_votings).
    group('"discontent_aspects"."id"').
    where('"discontent_aspects"."project_id" = ? and "discontent_aspects"."status" = 0', project)
    .vote_top(revers)
  end

end
