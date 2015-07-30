require 'spec_helper'

describe 'Cabinet Discontents' do
  subject { page }
  let(:cabinet_stage_url) { Rails.application.routes.url_helpers.send("new_#{@current_stage_type_for_cabinet_url}_path", @project, type_mechanic: 'simple') }

  before do
    create_project_and_user_for '2:0'
    @project.techniques << Technique::List.create(stage: 'discontent_posts', code: 'detailed')
    @discontent = create :discontent_with_aspects, user: @user, project: @project
    sign_in @user
    visit cabinet_stage_url
  end

  it_behaves_like 'base cabinet'

  describe 'create with simple form', js: true do
    before do
      @aspect_1 = create :aspect, user: @user, project: @project
      @aspect_2 = create :aspect, user: @user, project: @project
      visit cabinet_stage_url
    end

    it 'open example of discontents', js: true do
      click_link 'open_example_discontent'
      within :css, '#imperfs1' do
        expect(page).to have_content t('activerecord.attributes.discontent/post.content')
      end
    end

    context 'correct', js: true  do
      before do
        find('#select_aspect').click
        # @todo не выбирается аспект
        # execute_script("$('#discontent_post_aspects_#{@aspect_1.id}').show()")
        # execute_script("$('#discontent_post_aspects_#{@aspect_2.id}').show()")
        execute_script("$('#discontent_post_aspects_#{@aspect_1.id}').click()")
        execute_script("$('#discontent_post_aspects_#{@aspect_1.id}').click()")

        fill_in 'discontent_post_content', with: 'new discontent'
        fill_in 'discontent_post_what', with: 'because'
        fill_in 'discontent_post_whered', with: 'because'
        # fill_in 'discontent_post_whend', with: 'because'
        execute_script("$('#send_post').click()")
      end

      it { expect(page).to have_content t('form.discontent.new_success') }
    end

    it 'empty fields - error' do
      expect do
        click_button 'send_post'
        within :css, 'div.notice_messages' do
          expect(page).to have_css 'div#error_explanation'
        end
      end.not_to change(Discontent::Post, :count)
    end
  end

  it 'not example of discontents for detailed form', js: true do
    click_link 'new_discontent_posts_detailed'
    expect(page).not_to have_link 'open_example_discontent'
  end

  context 'create with detailed form', js: true do
    before do
      click_link 'new_discontent_posts_detailed'
      find('#first').click
    end

    it 'correct' do
      expect do
        fill_in 'discontent_post_content', with: 'new discontent'
        fill_in 'discontent_post_what', with: 'because'
        fill_in 'discontent_post_whered', with: 'because'
        # fill_in 'discontent_post_whend', with: 'because'
        click_button 'send_post'
        expect(page).to have_content t('form.discontent.new_success')
      end.to change(Discontent::Post, :count).by(1)
    end
  end

  it 'edit', js: true do
    new_content = 'new cool content'
    visit user_content_discontent_posts_path(@project)
    click_link "edit_discontent_#{@discontent.id}"
    expect do
      fill_in 'discontent_post_content', with: new_content
      click_button 'send_post'
      expect(page).to have_content t('form.discontent.edit_success')
    end.not_to change(Discontent::Post, :count)
    visit user_content_discontent_posts_path(@project)
    expect(page).to have_content new_content
  end

  context 'destroy', js: true do
    it 'from user content page' do
      visit user_content_discontent_posts_path(@project)
      expect do
        click_link "destroy_discontent_#{@discontent.id}"
        page.driver.browser.accept_js_confirms
        expect(current_path) == user_content_discontent_posts_path(@project)
      end.to change(Discontent::Post, :count).by(-1)
    end

    it 'from edit form' do
      visit edit_discontent_post_path(@project, @discontent)
      expect do
        click_link "destroy_discontent_#{@discontent.id}"
        page.driver.browser.accept_js_confirms
        expect(current_path) == user_content_discontent_posts_path(@project)
      end.to change(Discontent::Post, :count).by(-1)
    end
  end

  it 'created by current user' do
    click_link 'user_content_discontent_posts'
    expect(page).to have_content @discontent.content
    @discontent.post_aspects.each do |aspect|
      expect(page).to have_content aspect.content
    end
  end

  xit 'publish', js: true do
    visit edit_discontent_post_path(@project, @discontent)
    expect do
      click_link "publish_#{@discontent.id}"
      refresh_page
      expect(page).not_to have_link "publish_#{@discontent.id}"
    end.to change(Discontent::Post.published, :count).by(1)
  end

  it 'go to correct url' do
    visit new_concept_post_path(@project)
    expect(current_path).to eq(new_discontent_post_path(@project))
  end
end
