require 'spec_helper'

describe 'Concept ', skip: true do
  subject { page }

  let (:user) { create :user }
  let (:user_data) { create :user }
  let (:prime_admin) { create :prime_admin }
  let (:moderator) { create :moderator }
  let (:project) { create :core_project, status: 7 }
  let!(:project_user) { create :core_project_user, user: user, core_project: project, ready_to_concept: true }

  before do
    prepare_concepts(project, user_data)
    @post1 = @concept1
    @comment_1 = create :concept_comment, post: @post1, user: user
    @comment_2 = create :concept_comment, post: @post1, comment: @comment_1
  end

  shared_examples 'concept list' do
    before do
      visit "/project/#{project.id}/concept/posts?asp=#{@aspect1.id}"
    end

    it ' can see all concepts in aspect' do
      expect(page).to have_content 'Нововведения'
      expect(page).to have_content I18n.t('show.improve.ideas')
      expect(page).to have_content @discontent1.content
      expect(page).to have_content @discontent2.content
      expect(page).to have_content @concept_aspect1.title
      expect(page).to have_content @concept_aspect2.title
      expect(page).to have_selector "#new_concept_#{@discontent1.id}"
      expect(page).to have_selector "#new_concept_#{@discontent2.id}"
    end
  end

  shared_examples 'show concept' do
    before do
      visit concept_post_path(project, @concept1)
    end

    it 'can see right form' do
      expect(page).to have_content @discontent1.content
      expect(page).to have_content @concept_aspect1.title
      expect(page).to have_content @concept_aspect1.name
      expect(page).to have_content @concept_aspect1.positive
      expect(page).to have_content @concept_aspect1.negative
      expect(page).to have_content @concept_aspect1.content
      expect(page).to have_content @concept_aspect1.control
      expect(page).to have_content @concept_aspect1.obstacles
      expect(page).to have_content @concept_aspect1.reality
      expect(page).to have_content @concept_aspect1.problems
      expect(page).to have_selector 'textarea#comment_text_area'
      expect(page).not_to have_link("plus_post_#{@concept1.id}", text: 'Выдать баллы', href: plus_concept_post_path(project, @concept1))
    end

    context 'concept comments' do
      it_behaves_like 'content with comments', false, 2, 7
    end
  end

  shared_examples 'vote discontent' do
    before do
      project.update_attributes(status: 8)
      visit concept_posts_path(project)
    end

    it 'have content ', js: true do
      expect(page).to have_content 'Голосование за нововведения'
      expect(page).to have_content @discontent1.content
      expect(page).to have_content 'Пара: 1 из 1'
      expect(page).to have_content 'Нововведение 1'
      expect(page).to have_content @concept_aspect1.title
      expect(page).to have_content 'Нововведение 2'
      expect(page).to have_content @concept_aspect2.title
      expect(page).to have_selector '#btn_vote_1', 'Нововведение 1'
      expect(page).to have_selector '#btn_vote_2', 'Нововведение 2'
      click_link 'btn_vote_1'
      expect(page).to have_content 'Спасибо за участие в голосовании!'
      expect(page).to have_selector 'a', 'Перейти к рефлексии'
      expect(page).to have_selector 'a', 'Перейти к списку нововведений'
      click_link 'Перейти к списку нововведений'
      expect(page).to have_content 'Нововведения'
      expect(page).to have_content I18n.t('show.improve.ideas')
    end
  end

  context 'ordinary user sign in ' do
    before do
      sign_in user
    end

    it_behaves_like 'concept list'

    it_behaves_like 'show concept'

    it_behaves_like 'vote discontent'
  end

  context 'moderator sign in' do
    before do
      sign_in moderator
    end

    it_behaves_like 'concept list'

    it_behaves_like 'show concept'

    it_behaves_like 'vote discontent'

    context 'note for concept ' do
      before do
        visit concept_post_path(project, @concept1)
      end

      it 'can add note ', js: true do
        find(:css, "a#btn_note_1 div").trigger('click')
        expect(page).to have_selector "form#note_for_post_#{@concept1.id}_1"
        find("#note_for_post_#{@concept1.id}_1").find('#edit_post_note_text_area').set 'new note for first field concept post'
        find("#note_for_post_#{@concept1.id}_1").find("#send_post_1").click
        expect(page).to have_content "new note for first field concept post"
        find("ul#note_form_#{@concept1.id}_1 a").trigger('click')
        sleep 5
        expect(page).not_to have_content 'new note for first field concept post'
      end
    end
  end
end
