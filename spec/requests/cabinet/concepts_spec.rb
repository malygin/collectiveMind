require 'spec_helper'

describe 'Cabinet Concepts' do
  subject { page }
  let(:cabinet_stage_url) { Rails.application.routes.url_helpers.send("new_#{@current_stage_type_for_cabinet_url}_path", @project, type_mechanic: 'simple') }

  before do
    create_project_and_user_for '3:0'
    @discontent = create :discontent, user: @user, project: @project
    @discontent_2 = create :discontent, user: @user, project: @project
    @concept = create :concept_with_discontent, user: @user, project: @project
    sign_in @user
    visit cabinet_stage_url
  end

  it_behaves_like 'base cabinet'

  describe 'create with simple form', js: true do
    before do
      click_link 'new_concept_posts_simple'
    end

    context 'correct' do
      before do
        fill_in 'concept_post_title', with: 'title for concept'
        fill_in 'concept_post_goal', with: 'goal in concept'
        fill_in 'concept_post_content', with: 'content concept'
        fill_in 'concept_post_actors', with: 'actors'
        fill_in 'concept_post_impact_env', with: 'impact environment'
        # find(:xpath, "//a[@id='open_discontents']").click
        within :css, '.unchecked_items' do
          execute_script("$('input#concept_post_discontents_#{@discontent.id}').click()")
          execute_script("$('input#concept_post_discontents_#{@discontent_2.id}').click()")
          # find("input#concept_post_discontents_#{@discontent.id}").click
          # find("input#concept_post_discontents_#{@discontent_2.id}").click
        end
        click_button 'send_post_concept'

      end

      it { expect(page).to have_content t('form.concept.new_success') }



    end

    it 'empty fields - error' do
      expect {
        click_button 'send_post_concept'
        within :css, 'div.notice_messages' do
          expect(page).to have_css 'div#error_explanation'
        end
      }.not_to change(Concept::Post, :count)
    end
  end

  it 'edit', js: true do
    new_content = 'new cool content'
    visit user_content_concept_posts_path(@project)
    find(:css, "#edit_concept_#{@concept.id}").trigger('click')
    within :css, '.checked_items' do
      @concept.concept_disposts.each do |discontent|
        expect(page).to have_content discontent.content
      end
    end
    within :css, '.unchecked_items' do
      expect(page).to have_content @discontent.content
    end
    expect {
      fill_in 'concept_post_title', with: new_content
      click_button 'send_post_concept'
      expect(page).to have_content t('form.concept.edit_success')
    }.not_to change(Concept::Post, :count)
    visit user_content_concept_posts_path(@project)
    expect(page).to have_content new_content
  end

  context 'destroy' do
    it 'author - ok', js: true do
      visit user_content_concept_posts_path(@project)
      expect {
        click_link "destroy_concept_#{@concept.id}"
        page.driver.browser.accept_js_confirms
        expect(current_path) == user_content_concept_posts_path(@project)
      }.to change(Concept::Post, :count).by(-1)
    end
  end

  it 'created by current user' do
    click_link 'user_content_concept_posts'
    expect(page).to have_content @concept.title
    @concept.concept_disposts.each do |discontent|
      expect(page).to have_content discontent.content
    end
  end

  it 'publish', js: true do
    visit edit_concept_post_path(@project, @concept)
    expect {
      click_link "publish_#{@concept.id}"
      refresh_page
      expect(page).not_to have_link "publish_#{@concept.id}"
    }.to change(Concept::Post.published, :count).by(1)
  end
end
