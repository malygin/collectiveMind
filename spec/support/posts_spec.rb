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
  let(:text_comment) { attributes_for(comment_model.gsub('core/','').to_sym)[:content] }


  it ' user likes comment', js: true do
    like_comment_path = Rails.application.routes.url_helpers.send("like_comment_#{comment_post_model.gsub('core/','')}_path", project, @comment_1)

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

  # context 'mark comment as', js: true do
  #   deprecated
  #   if project_status < 7
  #     it 'discontent' do
  #       within :css, "a#discontent_comment_#{@comment_1.id}" do
  #         expect(page).to have_css 'span.label-default'
  #       end
  #       find(:css, "a#discontent_comment_#{@comment_1.id} span").trigger('click')
  #
  #       within :css, "a#discontent_comment_#{@comment_1.id}" do
  #         expect(page).to have_css 'span.label-danger'
  #       end
  #     end
  #   end
  #
  #   it 'concept' do
  #     within :css, "a#concept_comment_#{@comment_1.id}" do
  #       expect(page).to have_css 'span.label-default'
  #     end
  #     find(:css, "a#concept_comment_#{@comment_1.id} span").trigger('click')
  #     # click_link "concept_comment_#{@comment_1.id}"
  #     within :css, "a#concept_comment_#{@comment_1.id}" do
  #       expect(page).to have_css 'span.label-warning'
  #     end
  #   end
  #
  #   not functional now
  #   if moderator
  #     it 'discuss' do
  #       within :css, "a#discuss_stat_comment_#{@comment_1.id}" do
  #         expect(page).to have_css 'span.label-default'
  #       end
  #       find(:css, "a#discuss_stat_comment_#{@comment_1.id} span").trigger('click')
  #
  #       # click_link "discuss_stat_comment_#{@comment_1.id}"
  #       within :css, "a#discuss_stat_comment_#{@comment_1.id}" do
  #         expect(page).to have_css 'span.label-danger'
  #       end
  #     end
  #
  #     it 'approve' do
  #       within :css, "a#approve_stat_comment_#{@comment_1.id}" do
  #         expect(page).to have_css 'span.label-default'
  #       end
  #       find(:css, "a#approve_stat_comment_#{@comment_1.id} span").trigger('click')
  #
  #       # click_link "approve_stat_comment_#{@comment_1.id}"
  #       within :css, "a#approve_stat_comment_#{@comment_1.id}" do
  #         expect(page).to have_css 'span.label-success'
  #       end
  #     end
  #   else
  #     it 'show discuss label' do
  #       @comment_1.update_attributes(discuss_status: true)
  #       refresh_page
  #       expect(page).to have_css "span.label-danger#discuss_stat_comment_#{@comment_1.id}"
  #     end
  #
  #     it 'show approve label' do
  #       @comment_1.update_attributes(approve_status: true)
  #       refresh_page
  #       expect(page).to have_css "span.label-success#approve_stat_comment_#{@comment_1.id}"
  #     end
  #   end
  # end
end

shared_examples 'likes posts' do |moderator = false|
  let(:post_model) { @post1.class.name.underscore.gsub('/post', '_post') }

  # not functional now
  # if moderator
  #   it ' like post', js: true do
  #     prepare_awards
  #     # plus_post_path = Rails.application.routes.url_helpers.send("plus_#{post_model}_path", project, @post1)
  #     expect(page).to have_css("a#plus_post_#{@comment_1.id} span", text: 'Выдать баллы')
  #     find(:css, "a#plus_post_#{@post1.id} span").trigger('click')
  #     sleep(5)
  #     expect(page).to have_css("a#plus_post_#{@comment_1.id} span", text: 'Забрать баллы')
  #     sleep(5)
  #     find(:css, "a#plus_post_#{@post1.id} span").trigger('click')
  #     expect(page).to have_css("a#plus_post_#{@comment_1.id} span", text: 'Выдать баллы')
  #   end
  # else
  #   it ' not button like' do
  #     expect(page).not_to have_link("plus_post_#{@post1.id}")
  #   end
  # end

  it ' user likes post', js: true do
    like_post_path = Rails.application.routes.url_helpers.send("like_#{post_model.gsub('core/','')}_path", project, @post1)

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
    user_check_path = Rails.application.routes.url_helpers.send("#{stage}_posts_check_field_path", project, check_field: "#{stage}_intro", status: true)

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

shared_examples 'vote popup' do |status, title, stage|
  before do
    project.update_attributes(stage: status)
    if status == '2:1'
      @post1.update_attributes(status: 2)
      @post2.update_attributes(status: 2)
    end
    stage_path = Rails.application.routes.url_helpers.send("#{stage}_posts_path", project)
    visit stage_path
  end

  it 'correct voted', js: true do
    tab = 1
    # @todo title popup
    expect(page).to have_content title
    expect(page).to have_content @post1.content
    expect(page).to have_content @post2.content
    within :css, ".poll-2-1 span.vote_counter" do
      expect(page).to have_content '2'
    end
    find(:css, "#post_vote_#{@post1.id} .v_btn_#{1+tab}").trigger('click')
    within :css, ".poll-2-1 span.vote_counter" do
      expect(page).to have_content '1'
    end
    within :css, ".poll-2-#{2+tab} span.vote_counter" do
      expect(page).to have_content '1'
    end
    within :css, ".poll-2-#{3+tab} span.vote_counter" do
      expect(page).to have_content '0'
    end
    find(:css, "#post_vote_#{@post2.id} .v_btn_#{2+tab}").trigger('click')
    within :css, ".poll-2-1 span.vote_counter" do
      expect(page).to have_content '0'
    end
    within :css, ".poll-2-#{3+tab} span.vote_counter" do
      expect(page).to have_content '1'
    end
  end
end
