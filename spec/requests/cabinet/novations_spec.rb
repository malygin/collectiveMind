require 'spec_helper'

describe 'Cabinet Novations' do
  subject { page }
  let(:cabinet_stage_url) { Rails.application.routes.url_helpers.send("new_#{@current_stage_type_for_cabinet_url}_path", @project, type_mechanic: 'simple') }

  before do
    create_project_and_user_for '4:0'

    @novation = create :novation, user: @user, project: @project
    @concept = create :concept_with_discontent, user: @user, project: @project
    sign_in @user
    visit cabinet_stage_url
  end

  it_behaves_like 'base cabinet'

  context 'create with simple form', js: true do
    before do
      @user.user_checks.create(project_id: @project.id, check_field: 'novation_posts_cabinet_sticker', status: true).save!
      click_link 'new_novation_posts_simple'
    end

    context 'correct' do
      it 'save novation' do
        fill_in 'novation_post_title', with: 'new novation'
        # screenshot_and_open_image
        # find('#cabinet_close_sticker').click
        find('#select_concept').click
        within :css, '#modal-cabinet4-1' do
          find("a#open_discontent_#{@concept.concept_disposts.first.id}").click
          execute_script("$('#check_#{@concept.id}').click()")
          find('.close').click
        end
        find('a#open_project').click
        fill_in 'novation_post_project_change', with: 'sss'
        find('a#open_members').click
        choose 'novation_post_members_new_bool_true'
        fill_in 'novation_post_members_new', with: 'ss'
        find('a#open_resource').click
        choose 'novation_post_resource_support_bool_false'
        fill_in 'novation_post_resource_support', with: 'ss'
        find('a#open_confidence').click
        choose 'novation_post_confidence_remove_discontent_bool_false'
        fill_in 'novation_post_confidence_remove_discontent', with: 'ss'
        click_button 'send_post_novation'
        expect(page).to have_content t('form.novation.new_success')
      end
    end
    it 'empty fields - error' do
      expect do
        click_button 'send_post_novation'
        within :css, 'div.notice_messages' do
          expect(page).to have_css 'div#error_explanation'
        end
      end.not_to change(Novation::Post, :count)
    end
  end

  it 'edit', js: true do
    new_content = 'new cool content'
    visit user_content_novation_posts_path(@project)
    click_link "edit_novation_#{@novation.id}"
    expect do
      fill_in 'novation_post_title', with: new_content
      click_button 'send_post_novation'
      expect(page).to have_content t('form.novation.edit_success')
    end.not_to change(Novation::Post, :count)
    visit user_content_novation_posts_path(@project)
    expect(page).to have_content new_content
  end

  context 'destroy' do
    it 'author - ok', js: true do
      visit user_content_novation_posts_path(@project)
      expect do
        click_link "destroy_novation_#{@novation.id}"
        page.driver.browser.accept_js_confirms
        expect(current_path) == user_content_novation_posts_path(@project)
      end.to change(Novation::Post, :count).by(-1)
    end
  end

  it 'created by current user' do
    click_link 'user_content_novation_posts'
    expect(page).to have_content @novation.content
    # @todoLena этот кусок проверяет есть ли в кабинете для пакетов в плитках идей ссылки на идеи,
    # @novation.novation_concepts.each do |concept|
    #   expect(page).to have_content concept.title
    # end
  end

  it 'publish', js: true do
    visit edit_novation_post_path(@project, @novation)
    expect do
      click_button "publish_#{@novation.id}"
      refresh_page
      expect(page).not_to have_link "publish_#{@novation.id}"
    end.to change(Novation::Post.published, :count).by(1)
  end
end
