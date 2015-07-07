shared_examples 'base post' do |factory_name, class_name|
  it 'default factory - valid' do
    expect(build(factory_name)).to be_valid
  end

  context 'invalid without' do
    it 'user' do
      expect(build(factory_name, user: nil)).to be_invalid
    end

    it 'project' do
      expect(build(factory_name, project: nil)).to be_invalid
    end
  end

  it 'by project' do
    create factory_name
    post2 = create factory_name
    post3 = create factory_name, project: post2.project
    expect(class_name.by_project(post2.project)).to match_array([post2, post3])
  end

  it 'by status' do
    post2 = create factory_name, status: BasePost::STATUSES[:published]
    post3 = create factory_name, project: post2.project, status: BasePost::STATUSES[:approved]
    expect(class_name.by_status(2)).to match_array([post3])
  end

  it 'by user' do
    post1 = create factory_name
    post2 = create factory_name
    post3 = create factory_name, project: post2.project, user: post1.user
    expect(class_name.by_user(post1.user)).to match_array([post1, post3])
  end

  it { expect(build(factory_name, status: -1)).not_to be_valid }

  it { expect(build(factory_name, status: 1)).to be_valid }

  it { expect(build(factory_name, status: 4)).not_to be_valid }
end

shared_examples 'content with comments' do |moderator = false, count = 2, project_status = 1|
  let(:comment_model) { @comment_2.class.name.underscore.gsub('/comment', '_comment') }
  let(:comment_model_name) { @comment_2.class.name.constantize }
  let(:comment_post_model) { @comment_2.class.name.underscore.gsub('/comment', '_post') }
  let(:text_comment) { attributes_for(comment_model.to_sym)[:content] }


  it ' user likes comment', js: true do
    like_comment_path = Rails.application.routes.url_helpers.send("like_comment_#{comment_post_model}_path", project, @comment_1)

    expect(page).to have_link("like_comment_#{@comment_1.id}", href: like_comment_path + '?against=false')
    expect(page).to have_link("dislike_comment_#{@comment_1.id}", href: like_comment_path + '?against=true')
    click_link "like_comment_#{@comment_1.id}"
    within :css, "span#lk_comment_#{@comment_1.id}" do
      expect(page).to have_content '1'
    end

    click_link "like_comment_#{@comment_1.id}"
    within :css, "span#lk_comment_#{@comment_1.id}" do
      expect(page).to have_content '1'
    end

    click_link "dislike_comment_#{@comment_1.id}"
    within :css, "span#dlk_comment_#{@comment_1.id}" do
      expect(page).to have_content '0'
    end
  end

  it 'view comments ' do
    expect(page).to have_content @comment_1.content
  end

  context 'add new comment', js: true do
    before do
      fill_in 'comment_text_area', with: text_comment
      find('#comment_form.main_add .send-comment').click
    end

    it { expect(page).to have_content text_comment }

    it { expect change(Journal, :count).by(count) }
  end

  context ' add new answer comment', js: true do
    before do
      click_button "reply_comment_#{@comment_1.id}"
      find("#reply_form_#{@comment_1.id}").find('textarea').set text_comment
      find("#reply_form_#{@comment_1.id}").find('.send-comment').click
    end

    it { expect(page).to have_content text_comment }

    it { expect change(comment_model_name, :count).by(1) }

    # it { expect change(Journal.events_for_my_feed(project, user_data), :count).by(1) }
  end

  # @todo edit and destroy settings missed
  # context 'edit comment', js: true do
  #   it 'i owner - ok' do
  #     find(:css, "#redactor_comment_#{@comment_1.id}").trigger('click')
  #     find(:css, "#edit_comment_#{@comment_1.id}").trigger('click')
  #     find("#form_edit_comment_#{@comment_1.id}").find('textarea').set text_comment
  #     find("#form_edit_comment_#{@comment_1.id}").find('.send-comment').click
  #     expect(page).to have_content text_comment
  #   end
  #
  #   unless moderator
  #     it 'from other users - error' do
  #       expect(page).not_to have_css "#redactor_comment_#{@comment_2.id}"
  #     end
  #   end
  # end
  #
  # context 'destroy comment' do
  #   it 'i owner - ok', js: true do
  #     expect {
  #       find(:css, "#redactor_comment_#{@comment_1.id}").trigger('click')
  #       click_link "destroy_comment_#{@comment_1.id}"
  #       page.driver.browser.accept_js_confirms
  #       expect(page).not_to have_content @comment_1.content
  #     }.to change(comment_model_name, :count).by(-1)
  #   end
  #
  #   unless moderator
  #     it 'from other users - error' do
  #       expect(page).not_to have_css "#redactor_comment_#{@comment_2.id}"
  #     end
  #
  #     # it 'post request - error' do
  #     #   expect {
  #     #     page.driver.submit :put,
  #     #                        Rails.application.routes.url_helpers.send(
  #     #                            "destroy_comment_#{comment_post_model.gsub('core/','')}_path", @comment_2.post.project, @comment_2), {}
  #     #     expect(current_path).to eq root_path
  #     #   }.not_to change(comment_model_name, :count)
  #     # end
  #   end
  # end

  # not functional now

  # if moderator
  #   it ' like comment', js: true do
  #     prepare_awards
  #     plus_comment_path = Rails.application.routes.url_helpers.send("plus_comment_#{comment_post_model}_path", project, @comment_1)
  #
  #     expect(page).to have_css("a#plus_comment_#{@comment_1.id} span", text: 'Выдать баллы')
  #     click_link("plus_comment_#{@comment_1.id}")
  #     sleep 5
  #     expect(page).to have_css("a#plus_comment_#{@comment_1.id} span", text: 'Забрать баллы')
  #
  #   end
  # else
  #   it ' not button like' do
  #     expect(page).not_to have_link("plus_comment_#{@comment_1.id}")
  #   end
  # end

  # it 'add new comment with image', js: true do
  #   fill_in 'comment_text_area', with: text_comment
  #   attach_file("#{comment_model}_image", "#{Rails.root}/spec/support/images/1.jpg")
  #   sleep(5)
  #   # find('input.send-comment').click
  #   find('#comment_form .send-comment').click
  #   sleep(5)
  #   expect(page).to have_content text_comment
  #   expect(page).to have_selector 'a.image-popup-vertical-fit img'
  #
  #   Cloudinary::Api.delete_resources('comments/'+ page.first('a.image-popup-vertical-fit img')['alt'].downcase)
  # end

  # context 'add new answer to answer comment', js: true do
  #   before do
  #     click_button "reply_comment_#{@comment_2.id}"
  #     find("#form_reply_comment_#{@comment_2.id}").find('.comment-textarea').set text_comment
  #     find("#form_reply_comment_#{@comment_2.id}").find('.send-comment').click
  #   end
  #
  #   it { expect(page).to have_content text_comment }
  #
  #   it { expect change(comment_model_name, :count).by(1) }
  #
  #   it { expect change(Journal.events_for_my_feed(project, user_data), :count).by(1) }
  # end

  # it 'paginate comments' do
  #   create_list comment_model.to_sym, 11, post: @comment_1.post
  #   refresh_page
  #   expect(page).to have_css 'div.pagination'
  #   expect(page).to have_css 'a.previous_page'
  # end


end

shared_examples 'likes posts' do |moderator = false|
  let(:post_model) { @post1.class.name.underscore.gsub('/post', '_post') }


  it ' user likes post', js: true do
    like_post_path = Rails.application.routes.url_helpers.send("like_#{post_model}_path", project, @post1)

    expect(page).to have_link("like_post_#{@post1.id}", href: like_post_path + '?against=false')
    expect(page).to have_link("dislike_post_#{@post1.id}", href: like_post_path + '?against=true')
    click_link "like_post_#{@post1.id}"
    within :css, "#lk_post_#{@post1.id}" do
      expect(page).to have_content '1'
    end

    click_link "like_post_#{@post1.id}"
    within :css, "#lk_post_#{@post1.id}" do
      expect(page).to have_content '1'
    end

    click_link "dislike_post_#{@post1.id}"
    within :css, "#dlk_post_#{@post1.id}" do
      expect(page).to have_content '0'
    end
  end
end

shared_examples 'admin panel post' do |moderator = false|
  let(:post_model) { @post1.class.name.underscore.gsub('/post', '_post') }
  let(:stage_model) { @post1.class.name.underscore.pluralize.gsub('/posts', '_posts') }
  let(:comment_model_name) { @post1.class.name.constantize }

  before do
    if stage_model == 'aspect_posts'
      create :aspect_user_answer, user: moderator ? @moderator : @user, project: project, aspect: @aspect1, question: @question_0_1
      create :aspect_user_answer, user: moderator ? @moderator : @user, project: project, aspect: @aspect2, question: @question_0_2
    end
    stage_post_path = Rails.application.routes.url_helpers.send("#{stage_model}_path", project)

    visit stage_post_path
  end

  if moderator
    it ' score post ', js: true do
      plus_post_path = Rails.application.routes.url_helpers.send("add_score_#{post_model}_path", project, @post1)
      stage_post_path = Rails.application.routes.url_helpers.send("#{stage_model}_path", project)

      expect(page).to have_link("add_score_post_#{@post1.id}", href: plus_post_path)
      expect {
        find(:css, "a#add_score_post_#{@post1.id}").trigger('click')
        sleep(5)
        expect(page).to have_css("a.theme_font_color#add_score_post_#{@post1.id}")
      }.to change(Journal, :count).by(1)
      visit  users_path(project)
      expect(page).to have_selector('span.rating_cell', text: @post1.class::SCORE )
      visit stage_post_path
      expect {
        find(:css, "a#add_score_post_#{@post1.id}").trigger('click')
        sleep(5)
        expect(page).to have_css("a:not(.theme_font_color)#add_score_post_#{@post1.id}")
      }.to change(Journal, :count).by(-1)
      visit  users_path(project)
      expect(page).not_to have_selector('span.rating_cell', text: @post1.class::SCORE )
    end

    it ' score comment ', js: true do
      stage_post_path = Rails.application.routes.url_helpers.send("#{stage_model}_path", project)
      find(:css, "#show_record_#{@post1.id}").trigger('click')
      find(:css, "#add_score_for_comment_#{@comment_1.id}").trigger('click')
      visit  users_path(project)
      expect(page).to have_selector('span.rating_cell', text: 5 )
      visit stage_post_path
      find(:css, "#show_record_#{@post1.id}").trigger('click')
      find(:css, "#add_score_for_comment_#{@comment_1.id}").trigger('click')
      visit  users_path(project)
      expect(page).to have_selector('span.rating_cell', text: 0 )

    end

    it ' approve post ', js: true do
      discuss_post_path = Rails.application.routes.url_helpers.send("change_status_#{post_model}_path", project, @post1, status: :approve_status)

      expect(page).to have_link("approve_status_post_#{@post1.id}", href: discuss_post_path)

      expect {
        find(:css, "a#approve_status_post_#{@post1.id}").trigger('click')
        sleep(5)
        expect(page).to have_css("a.theme_font_color#approve_status_post_#{@post1.id}")
        # expect(page).to have_css("div:not(.hide)[data-important='#{@post1.id}']")
      }.to change(Journal, :count).by(1)
      find(:css, "a#approve_status_post_#{@post1.id}").trigger('click')
      sleep(5)
      expect(page).to have_css("a:not(.theme_font_color)#approve_status_post_#{@post1.id}")
      # expect(page).to have_css("div.hide[data-important='#{@post1.id}']")
    end
  else
    it ' not button ' do
      expect(page).not_to have_link("add_score_post_#{@post1.id}")
      expect(page).not_to have_link("approve_status_post_#{@post1.id}")
    end
  end
end

shared_examples 'welcome popup' do |stage|
  before do
    @user_check.destroy
    @moderator_check.destroy
    @user_check_popover.destroy if @user_check_popover
    @moderator_check_popover.destroy if @moderator_check_popover
    stage_path = Rails.application.routes.url_helpers.send("#{stage}_posts_path", project)
    visit stage_path
  end

  it 'have welcome popup', js: true do
    user_check_path = Rails.application.routes.url_helpers.send("check_field_#{stage}_posts_path", project, check_field: "#{stage}_intro", status: true)

    expect(page).to have_content 'Цель стадии'
    expect(page).to have_link("#{stage}_intro", href: user_check_path, text: 'Начать работу')
    click_link "#{stage}_intro"
    expect(page).not_to have_content 'Цель стадии'
  end

  it 'have welcome popover', js: true do
    click_link "#{stage}_intro"
    expect(page).to have_css(".help_popover_content")
    expect(page).to have_link("close_help_popover")
    # @todo position element out page
    # click_link "close_help_popover"
    # expect(page).not_to have_css(".help_popover_content")
  end
end

shared_examples 'vote popup' do |status, stage|
  before do
    project.update_attributes(stage: status)
    stage_path = Rails.application.routes.url_helpers.send("#{stage}_posts_path", project)
    visit stage_path
  end

  it 'correct voted', js: true do
    expect(page).to have_content t("vote.#{stage}_posts.header")
    expect(page).to have_content @post1.content
    expect(page).to have_content @post2.content
    within :css, "[data-vote-folder-role='all'] span.vote_counter" do
      expect(page).to have_content '2'
    end
    find(:css, "#post_vote_#{@post1.id} > a").trigger('click') if stage == 'concept'
    find(:css, "#vote_button_#{@post1.id}_1").trigger('click')
    within :css, "[data-vote-folder-role='all'] span.vote_counter" do
      expect(page).to have_content '1'
    end
    find(:css, "#post_vote_#{@post2.id} > a").trigger('click') if stage == 'concept'
    find(:css, "#vote_button_#{@post2.id}_2").trigger('click')
    sleep(5)
    expect(page).to_not have_content t("vote.#{stage}_posts.header")
    expect(page).to have_content @post1.content
    expect(page).to have_content @post2.content
  end
end

