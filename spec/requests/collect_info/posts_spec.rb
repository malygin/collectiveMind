require 'spec_helper'

describe 'Collect info', skip: true do
  subject { page }

  let!(:user) { @user = create :user }
  let!(:moderator) { @moderator = create :moderator }
  let (:project) { @project = create :closed_project }

  before do
    create :core_project_user, user: user, core_project: project
    create :core_project_user, user: moderator, core_project: project

    @user_check = create :user_check, user: user, project: project, check_field: 'collect_info_intro'
    @moderator_check = create :user_check, user: moderator, project: project, check_field: 'collect_info_intro'

    @aspect1 = create :aspect, project: project
    @aspect2 = create :aspect, project: project

    @knowbase_post1 = create :core_knowbase_post, project: project, core_aspect: @aspect1
    @knowbase_post2 = create :core_knowbase_post, project: project, core_aspect: @aspect2

    @question_0_1 = create :collect_info_question, project: project, core_aspect: @aspect1
    @question_0_2 = create :collect_info_question, project: project, core_aspect: @aspect2

    @question_1_1 = create :collect_info_question, project: project, core_aspect: @aspect1, type_stage: 1
    @question_1_2 = create :collect_info_question, project: project, core_aspect: @aspect2, type_stage: 1

    @answer_0_1 = create :collect_info_answer, question: @question_0_1
    @answer_0_2 = create :collect_info_answer, question: @question_0_1
    @answer_0_3 = create :collect_info_answer, question: @question_0_2
    @answer_0_4 = create :collect_info_answer, question: @question_0_2

    @answer_1_1 = create :collect_info_answer, question: @question_1_1
    @answer_1_2 = create :collect_info_answer, question: @question_1_1, correct: false
    @answer_1_3 = create :collect_info_answer, question: @question_1_2
    @answer_1_4 = create :collect_info_answer, question: @question_1_2, correct: false

    @post1 = @aspect1
    @post2 = @aspect2
    @comment_1 = create :aspect_comment, post: @post1, user: user
    @comment_2 = create :aspect_comment, post: @post1, comment: @comment_1
  end


  shared_examples 'show list aspects' do
    before do
      visit collect_info_posts_path(project)
    end

    it 'have content', js: true do
      expect(page).to have_content 'Введение в процедуру'
      expect(page).to have_content @aspect1.content
      expect(page).to have_content @aspect2.content
      find(:css, "#li_aspect_#{@aspect1.id}").trigger('click')
      expect(page).to have_content @knowbase_post1.content
      expect(page).to have_content @question_0_1.content
      expect(page).to have_content @answer_0_1.content
      expect(page).to have_content @answer_0_2.content
      find(:css, "#li_aspect_#{@aspect2.id}").trigger('click')
      expect(page).to have_content @knowbase_post2.content
      expect(page).to have_content @question_0_2.content
      expect(page).to have_content @answer_0_3.content
      expect(page).to have_content @answer_0_4.content
    end

    it_behaves_like 'likes posts'
  end

  shared_examples 'answers the first questions' do
    before do
      visit collect_info_posts_path(project)
    end

    it 'answer to question', js: true do
      find(:css, "#li_aspect_#{@aspect1.id}").trigger('click')
      expect(page).to have_content @question_0_1.content
      expect(page).to have_content @answer_0_1.content
      expect(page).to have_content @answer_0_2.content
      within :css, "#question_#{@question_0_1.id}" do
        fill_in 'content', with: 'desc answer'
        click_button "answer_#{@answer_0_1.id}"
        click_button 'send_answers'
      end
      expect(page).to have_content @question_0_2.content
      expect(page).to have_content @answer_0_3.content
      expect(page).to have_content @answer_0_4.content
    end
  end

  shared_examples 'discuss first aspects' do |moder = false|
    before do
      create :collect_info_user_answer, user: moder ? @moderator : @user, project: project, aspect: @aspect1, question: @question_0_1
      create :collect_info_user_answer, user: moder ? @moderator : @user, project: project, aspect: @aspect2, question: @question_0_2
      visit collect_info_posts_path(project)
    end

    it 'have content' do
      expect(page).to have_content 'Обсуждение аспектов'
      expect(page).to have_content 'Аспекты из базы знаний (2)'
      expect(page).to have_content 'Аспекты, предложенные участниками (0)'
      expect(page).to have_content @aspect1.content
      expect(page).to have_content @aspect2.content
      expect(page).to have_link 'new_aspect_posts'
    end

    context 'show popup aspect ', js: true do
      before do
        find(:css, "#show_record_#{@post1.id}").trigger('click')
      end

      it { expect(page).to have_content @post1.content }

      it_behaves_like 'content with comments'
    end
  end

  shared_examples 'answers the second questions' do
    before do
      project.update_attributes(status: 1)
      visit collect_info_posts_path(project)
    end

    it 'success answer to question', js: true do
      find(:css, "#li_aspect_#{@aspect1.id}").trigger('click')
      expect(page).to have_content @question_1_1.content
      expect(page).to have_content @answer_1_1.content
      expect(page).to have_content @answer_1_2.content
      within :css, "#question_#{@question_1_1.id}" do
        click_button "answer_#{@answer_1_1.id}"
        click_button 'send_answers'
      end
      expect(page).to have_content @question_1_2.content
      expect(page).to have_content @answer_1_3.content
      expect(page).to have_content @answer_1_4.content
    end

    it 'failed answer to question', js: true do
      find(:css, "#li_aspect_#{@aspect1.id}").trigger('click')
      expect(page).to have_content @question_1_1.content
      expect(page).to have_content @answer_1_1.content
      expect(page).to have_content @answer_1_2.content
      within :css, "#question_#{@question_1_1.id}" do
        click_button "answer_#{@answer_1_2.id}"
        click_button 'send_answers'
      end
      expect(page).not_to have_content @question_1_2.content
      expect(page).to have_content 'Ответ неправильный, воспользуйтесь подсказкой'
      expect(page).to have_link "notice_question_#{@question_1_1.id}"
      find(:css, "#notice_question_#{@question_1_1.id}").trigger('click')
      expect(page).to have_content @question_1_1.hint
    end
  end

  shared_examples 'discuss second aspects' do |moder = false|
    before do
      project.update_attributes(status: 1)
      create :collect_info_user_answer, user: moder ? @moderator : @user, project: project, aspect: @aspect1, question: @question_1_1
      create :collect_info_user_answer, user: moder ? @moderator : @user, project: project, aspect: @aspect2, question: @question_1_2
      visit collect_info_posts_path(project)
    end

    it 'have content' do
      expect(page).to have_content 'Обсуждение аспектов'
      expect(page).to have_content 'Аспекты из базы знаний (2)'
      expect(page).to have_content 'Аспекты, предложенные участниками (0)'
      expect(page).to have_content @aspect1.content
      expect(page).to have_content @aspect2.content
      expect(page).to have_link 'new_aspect_posts'
    end

    context 'show popup aspect ', js: true do
      before do
        find(:css, "#show_record_#{@post1.id}").trigger('click')
      end

      it { expect(page).to have_content @post1.content }

      it_behaves_like 'content with comments'
    end
  end

  context 'ordinary user sign in ' do
    before do
      sign_in user
    end

    it_behaves_like 'welcome popup', 'collect_info'

    it_behaves_like 'show list aspects'

    it_behaves_like 'answers the first questions'

    it_behaves_like 'discuss first aspects'

    it_behaves_like 'answers the second questions'

    it_behaves_like 'discuss second aspects'

    it_behaves_like 'vote popup', 2, 'Голосование по аспектам'
  end

  # context 'moderator sign in ' do
  #   before do
  #     sign_in moderator
  #   end
  #
  #   it_behaves_like 'welcome popup', 'collect_info'
  #
  #   it_behaves_like 'show list aspects'
  #
  #   it_behaves_like 'answers the first questions'
  #
  #   it_behaves_like 'discuss first aspects', true
  #
  #   it_behaves_like 'answers the second questions'
  #
  #   it_behaves_like 'discuss second aspects', true
  #
  #   it_behaves_like 'vote popup', 2, 'Голосование по аспектам'
  # end
end
