require 'spec_helper'

describe 'Collect info', skip: true do
  subject { page }

  let!(:user) { @user = create :user }
  # let (:user_data) { create :user }
  let!(:moderator) { @moderator = create :moderator }
  let (:project) { create :core_project }

  before do
    @aspect1 = create :aspect, project: project
    @aspect2 = create :aspect, project: project
    @knowbase_post1 = create :core_knowbase_post, project: project, aspect: @aspect1
    @knowbase_post2 = create :core_knowbase_post, project: project, aspect: @aspect1
    @question1 = create :collect_info_question, project: project, aspect: @aspect1
    @question2 = create :collect_info_question, project: project, aspect: @aspect1
    @answer1 = create :collect_info_answer, question: @question1
    @answer2 = create :collect_info_answer, question: @question1, correct: false
  end


  shared_examples 'collect info list' do
    before do
      visit collect_info_posts_path(project)
    end

    it 'have content' do
      expect(page).to have_content @aspect1.content
      expect(page).to have_content @aspect2.content
      expect(page).to have_content @knowbase_post1.content
      expect(page).to have_content @question1.content
      expect(page).to have_content @answer1.content
      expect(page).to have_content @answer2.content
      find(:css, "#li_aspect_#{@aspect2.id} span").trigger('click')
      expect(page).to have_content @knowbase_post2.content
    end
  end

  shared_examples 'collect info answers' do
    before do
      visit collect_info_posts_path(project)
    end

    it 'success answer to question' do
      expect(page).to have_content @question1.content
      expect(page).to have_content @answer1.content
      expect(page).to have_content @answer2.content
      find(:css, "#answer_#{@answer1.id}").trigger('click')
      expect(page).to have_content @question2.content
    end

    it 'failed answer to question' do
      expect(page).to have_content @question1.content
      expect(page).to have_content @answer1.content
      expect(page).to have_content @answer2.content
      find(:css, "#answer_#{@answer2.id}").trigger('click')
      expect(page).not_to have_content @question2.content
    end
  end

  context 'ordinary user sign in ' do
    before do
      sign_in user
    end

    it_behaves_like 'collect info list'

    it_behaves_like 'collect info answers'
  end

  context 'moderator sign in' do
    before do
      sign_in moderator
    end

    it_behaves_like 'collect info list'

    it_behaves_like 'collect info answers'
  end
end
