require 'spec_helper'

describe 'Knowbase ' do
  subject { page }

  let!(:user) { @user = create :user }
  let!(:moderator) { @moderator = create :moderator }
  let(:project) { @project = create :closed_project }

  before do
    create :core_project_user, user: user, core_project: project
    create :core_project_user, user: moderator, core_project: project

    @user_check = create :user_check, user: user, project: project, check_field: 'aspect_posts_intro'
    @moderator_check = create :user_check, user: moderator, project: project, check_field: 'aspect_posts_intro'

    @aspect1 = create :aspect, project: project
    @aspect2 = create :aspect, project: project

    @knowbase_post1 = create :core_knowbase_post, project: project, aspect: @aspect1
    @knowbase_post2 = create :core_knowbase_post, project: project, aspect: @aspect2
  end

  shared_examples 'show list knowbase posts' do
    before do
      visit aspect_posts_path(project)
    end

    it 'have content', js: true do
      find(:css, '#tooltip_db').trigger('click')
      expect(page).to have_content 'Введение в процедуру'
      expect(page).to have_content @aspect1.content
      expect(page).to have_content @aspect2.content
      find(:css, "#myCarousel ul li.myCarousel-target[data-slide-to='1']").trigger('click')
      expect(page).to have_content @knowbase_post1.content
      find(:css, "#myCarousel ul li.myCarousel-target[data-slide-to='2']").trigger('click')
      expect(page).to have_content @knowbase_post2.content
    end
  end

  context 'ordinary user sign in ' do
    before do
      sign_in user
    end

    it_behaves_like 'show list knowbase posts'
  end

  # context 'moderator sign in ' do
  #   before do
  #     sign_in moderator
  #   end
  #
  #   it_behaves_like 'show list knowbase posts'
  #
  # end
end
