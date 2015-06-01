require 'spec_helper'

describe 'Users ' do
  subject { page }

  let!(:user) { @user = create :user }
  let!(:user_content) { create :user }
  let!(:moderator) { @moderator = create :moderator }
  let (:project) { @project = create :closed_project, stage: '1:0' }

  before do
    create :core_project_user, user: user, core_project: project
    create :core_project_user, user: moderator, core_project: project

    @user_check = create :user_check, user: user, project: project, check_field: 'collect_info_intro'
    @moderator_check = create :user_check, user: moderator, project: project, check_field: 'collect_info_intro'
  end


  context 'ordinary user sign in ' do
    before do
      sign_in user
      visit collect_info_posts_path(project)
    end

    context 'edit profile', js: true do
      it 'owner - ok' do
        new_name = 'Cool new name'
        new_surname = 'My cool surname'
        click_link 'auth_dropdown'
        click_link 'go_to_profile'
        click_link 'edit_profile'
        fill_in 'user_name', with: new_name
        fill_in 'user_surname', with: new_surname
        click_button 'update_profile'
        # expect(current_path).to eq user_path(project.id, user.id)
        expect(current_path).to eq polymorphic_path(project.current_stage_type, project: project, action: :user_content)
        expect(page).to have_content new_name
        expect(page).to have_content new_surname
      end

      context 'other user' do
        it 'not show link' do
          visit user_path(project, moderator)
          expect(page).not_to have_link 'edit_profile'
        end
      end
    end

    context 'stage content', js: true do
      before do
        @aspect = create :aspect, project: project, user: user_content
        @aspect_comment = create :aspect_comment, post: @aspect, user: user_content

        @discontent = create :discontent, project: project, user: user_content
        @discontent_comment = create :discontent_comment, post: @discontent, user: user_content

        @concept = create :concept, user: user_content, project: project
        @concept_comment = create :concept_comment, post: @concept, user: user_content

        @novation = create :novation, user: user_content, project: project
        @novation_comment = create :novation_comment, post: @novation, user: user_content

        @plan = create :plan, user: user_content, project: project
        @plan_comment = create :plan_comment, post: @plan, user: user_content

        visit user_path(project, user_content)
      end

      it 'have on all stages' do
        expect(page).to have_content @aspect.content
        expect(page).to have_content @aspect_comment.content
        project.update(stage: '2:0')
        refresh_page
        expect(page).to have_content @discontent.content
        expect(page).to have_content @discontent_comment.content
        project.update(stage: '3:0')
        refresh_page
        expect(page).to have_content @concept.title
        expect(page).to have_content @concept_comment.content
        project.update(stage: '4:0')
        refresh_page
        expect(page).to have_content @novation.title
        expect(page).to have_content @novation_comment.content
        project.update(stage: '5:0')
        refresh_page
        expect(page).to have_content @plan.content
        expect(page).to have_content @plan_comment.content
        project.update(stage: '6:0')
        refresh_page
        expect(page).to have_content @plan.content
        expect(page).to have_content @plan_comment.content
      end

    end

    context 'my journal', js: true do
      before do
        @personal_journal = create :personal_journal, project: project, user: user, user_informed: user
        visit "/project/#{project.id}"
      end

      it 'have count' do
        within :css, 'a#clear_my_journals span#my_journals_count' do
          expect(page).to have_content '1'
        end
      end

      it 'have content on click' do
        click_link 'clear_my_journals'
        within :css, '#dd_2' do
          expect(page).to have_content @personal_journal.body
        end
        expect change(Journal.events_for_my_feed(project, user), :count).by(-1)
        sleep(5)
        within :css, 'a#clear_my_journals span#my_journals_count' do
          expect(page).to_not have_content '1'
        end
      end
    end
  end

end
