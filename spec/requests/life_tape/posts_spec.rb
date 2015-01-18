require 'spec_helper'

describe 'Life Tape ' do
  subject { page }

  let!(:user) { @user = create :user }
  let (:user_data) { create :user }
  let (:prime_admin) { create :prime_admin }
  let!(:moderator) { @moderator = create :moderator }
  let (:project) { create :core_project, status: 1 }

  before do
    @post1 = create :life_tape_post, project: project
    @post2 = create :life_tape_post, project: project
    @aspect1 = @post1.aspect
    @aspect2 = @post2.aspect
  end

  context 'ordinary user sign in ' do
    before do
      sign_in user
    end

    context 'life tape list ' do
      before do
        visit life_tape_posts_path(project)
      end

      it_behaves_like 'content with comments'
    end

    context 'success go to project ' do
      before do
        click_link "go_to_opened_project_#{project.id}"
      end

      it 'have content' do
        expect(page).to have_content @aspect1.content
        expect(page).to have_content @aspect2.content
        expect(page).to have_selector 'textarea#comment_text_area'

        validate_default_links_and_sidebar(project, user)
        validate_not_have_admin_links_for_user(project)
        validate_not_have_moderator_links_for_user(project)

        validation_visit_links_for_user(project, user)
        validation_visit_not_have_links_for_user(project, user)
      end
    end

    context 'vote life tape ' do
      before do
        project.update_attributes(status: 2)
        visit life_tape_posts_path(project)
      end

      it 'have content ', js: true do
        expect(page).to have_content I18n.t('voting.lifetape.title')
        expect(page).to have_content I18n.t('voting.lifetape.name')
        expect(page).to have_content I18n.t('voting.lifetape.select', num: project.stage1_count)
        expect(page).to have_content "Осталось голосов: #{project.stage1_count}"
        expect(page).to have_content @aspect1.content
        expect(page).to have_content @aspect2.content
        click_link "vote_#{@aspect1.id}"
        expect(page).to have_content "Осталось голосов: #{project.stage1_count - 1}"
        click_link "vote_#{@aspect2.id}"
        expect(page).to have_content "Осталось голосов: 0"
        expect(page).to have_content 'Спасибо за участие в голосовании!'
        expect(page).to have_selector 'a', I18n.t('voting.go_reflection')
        expect(page).to have_selector 'a', I18n.t('voting.lifetape.go_list')
        click_link I18n.t('voting.go_reflection')
        expect(page).to have_content "#{I18n.t('show.essay.title')} #{I18n.t('stages.life_tape')}"
      end
    end

    context 'show help' do

    end
  end

  context 'moderator sign in' do
    before do
      sign_in moderator
    end

    context 'success go to project ' do
      before do
        click_link "go_to_opened_project_#{project.id}"
      end

      it 'have content for moderator ' do
        expect(page).to have_content @aspect1.content
        expect(page).to have_content @aspect2.content
        expect(page).to have_selector 'textarea#comment_text_area'

        validate_default_links_and_sidebar(project, moderator)
        validate_not_have_admin_links_for_moderator(project)
        validate_have_moderator_links(project)

        validation_visit_links_for_user(project, moderator)
        validation_visit_links_for_moderator(project)
        validation_visit_not_have_links_for_moderator(project, moderator)
      end
    end

    context 'life tape list ' do
      before do
        visit life_tape_posts_path(project)
      end

      it_behaves_like 'content with comments', 2, true

    end

    context 'vote life tape ' do
      before do
        project.update_attributes(status: 2)
        visit life_tape_posts_path(project)
      end

      it 'have content ', js: true do
        expect(page).to have_content I18n.t('voting.lifetape.title')
        expect(page).to have_content I18n.t('voting.lifetape.name')
        expect(page).to have_content I18n.t('voting.lifetape.select', num: project.stage1_count)
        expect(page).to have_content "Осталось голосов: #{project.stage1_count}"
        expect(page).to have_content @aspect1.content
        expect(page).to have_content @aspect2.content
        expect(page).to have_selector 'a', I18n.t('voting.go_reflection')
        expect(page).to have_link("set_vote_#{@aspect1.id}", text: 'Удалить', href: set_aspect_status_life_tape_post_path(project, @aspect1))
        click_link "set_vote_#{@aspect1.id}"
        expect(page).to have_link("set_vote_#{@aspect1.id}", text: 'Вернуть', href: set_aspect_status_life_tape_post_path(project, @aspect1))
        click_link "set_vote_#{@aspect1.id}"
        expect(page).to have_link("set_vote_#{@aspect1.id}", text: 'Удалить', href: set_aspect_status_life_tape_post_path(project, @aspect1))
        click_link "vote_#{@aspect1.id}"
        expect(page).to have_content "Осталось голосов: #{project.stage1_count - 1}"
        click_link "vote_#{@aspect2.id}"
        expect(page).to have_content "Осталось голосов: 0"
        expect(page).to have_content 'Спасибо за участие в голосовании!'
        expect(page).to have_selector 'a', I18n.t('voting.go_reflection')
        expect(page).to have_selector 'a', I18n.t('voting.lifetape.go_list')
        click_link I18n.t('voting.go_reflection')
        expect(page).to have_content "#{I18n.t('show.essay.title')} #{I18n.t('stages.life_tape')}"
      end
    end
  end
end
