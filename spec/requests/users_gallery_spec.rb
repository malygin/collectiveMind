require 'spec_helper'

describe 'Users Gallery' do
  subject { page }

  before :all do
    @user = FactoryGirl.create :user
    @project = FactoryGirl.create :core_project
    #@user.confirm!
    #@top_category = FactoryGirl.create :top_category
    #@products = []
    #5.times do
    #  @products << FactoryGirl.create(:catalog_product, category_id: @top_category.id)
    #end
  end

  before :each do
    sign_in @user
    visit life_tape_posts_path(@project)
  end

  describe 'view' do
    it 'link to gallery from profile' do
      visit user_path(@project, @user)

    end

    it 'types of list product' do
      visit "/users/#{@user.id}/stuff/achievements"
      within(:css, 'div#gallery') do
        should have_link "#{@user.id}_stuffmash_list"
        should have_link "#{@user.id}_achievements_list"
        should have_link "#{@user.id}_dreams_list"
        should have_link "#{@user.id}_target_list"
      end
    end
  end

  describe 'lists of product' do
    it 'stuffmash'

    it 'achievement'

    it 'dream'

    it 'target'
  end

  describe 'set dream as a target'
end