class Award < ActiveRecord::Base
  attr_accessible :desc, :name, :url, :position
  has_many :user_awards
  has_many :users, :through => :user_awards
  scope :for_project, lambda  {|project| where('user_awards.project_id' => project) }

  def self.reward(h={})
    if h[:type] == 'like'
      awk = UserAwardClick.where(user_id: h[:user], project_id: h[:project]).first_or_create
      awk.update_attributes(clicks: awk.clicks+1)
      if awk.clicks == 1
        a = Award.find_by_url('1like')
        UserAward.create!(user: h[:user], award: a, project: h[:project])
        h[:user].journals.build(:type_event=>'award_1like', :project => h[:project], :body=> a.name).save!
        h[:user].journals.build(:type_event=>'my_award_1like',  :user_informed => h[:user], :project => h[:project], :body=> a.name, :viewed=> false, :personal=> true).save!

      elsif awk.clicks == 3
        a = Award.find_by_url('3likes')
        UserAward.create!(user: h[:user], award: a, project: h[:project])
        h[:user].journals.build(:type_event=>'award_3likes', :project => h[:project], :body=> a.name).save!
        h[:user].journals.build(:type_event=>'my_award_3likes',  :user_informed => h[:user], :project => h[:project], :body=> a.name, :viewed=> false, :personal=> true).save!

      elsif awk.clicks == 5
        a = Award.find_by_url('5likes')
        UserAward.create!(user: h[:user], award: a, project: h[:project])
        h[:user].journals.build(:type_event=>'award_5likes', :project => h[:project], :body=> a.name).save!
        h[:user].journals.build(:type_event=>'my_award_5likes',  :user_informed => h[:user], :project => h[:project], :body=> a.name, :viewed=> false, :personal=> true).save!

      elsif awk.clicks == 15
        a = Award.find_by_url('15likes')
        UserAward.create!(user: h[:user], award: a, project: h[:project])
        h[:user].journals.build(:type_event=>'award_15likes', :project => h[:project], :body=> a.name).save!
        h[:user].journals.build(:type_event=>'my_award_15likes',  :user_informed => h[:user], :project => h[:project], :body=> a.name, :viewed=> false, :personal=> true).save!

      elsif awk.clicks == 50
        a = Award.find_by_url('50likes')
        UserAward.create!(user: h[:user], award: a, project: h[:project])
        h[:user].journals.build(:type_event=>'award_50likes', :project => h[:project], :body=> a.name).save!
        h[:user].journals.build(:type_event=>'my_award_50likes',  :user_informed => h[:user], :project => h[:project], :body=> a.name, :viewed=> false, :personal=> true).save!

      end

    elsif h[:type] == 'add'
      if h[:post].instance_of? Discontent::Post
        count_d = h[:user].discontent_posts.by_project(h[:project]).with_votes.count
        if count_d == 1
          a = Award.find_by_url('1imperfection')
          UserAward.create!(user: h[:user], award: a, project: h[:project])
          h[:user].journals.build(:type_event=>'award_1imperfection', :project => h[:project], :body=> a.name).save!
          h[:user].journals.build(:type_event=>'my_award_1imperfection',  :user_informed => h[:user], :project => h[:project], :body=> a.name, :viewed=> false, :personal=> true).save!
        elsif count_d == 3
          a = Award.find_by_url('3imperfection')
          UserAward.create!(user: h[:user], award: a, project: h[:project])
          h[:user].journals.build(:type_event=>'award_3imperfection', :project => h[:project], :body=> a.name).save!
          h[:user].journals.build(:type_event=>'my_award_3imperfection',  :user_informed => h[:user], :project => h[:project], :body=> a.name, :viewed=> false, :personal=> true).save!
        elsif count_d == 5
          a = Award.find_by_url('5imperfection')
          UserAward.create!(user: h[:user], award: a, project: h[:project])
          h[:user].journals.build(:type_event=>'award_5imperfection', :project => h[:project], :body=> a.name).save!
          h[:user].journals.build(:type_event=>'my_award_5imperfection',  :user_informed => h[:user], :project => h[:project], :body=> a.name, :viewed=> false, :personal=> true).save!
        elsif count_d == 15
          a = Award.find_by_url('15imperfection')
          UserAward.create!(user: h[:user], award: a, project: h[:project])
          h[:user].journals.build(:type_event=>'award_15imperfection', :project => h[:project], :body=> a.name).save!
          h[:user].journals.build(:type_event=>'my_award_15imperfection',  :user_informed => h[:user], :project => h[:project], :body=> a.name, :viewed=> false, :personal=> true).save!
        end

      end

    end

  end
end
