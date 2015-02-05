shared_examples 'content with comments' do |moderator = false, count = 2, project_status = 1|
  let(:comment_model) { @comment_2.class.name.underscore.gsub('/comment', '_comment') }
  let(:comment_model_name) { @comment_2.class.name.constantize }
  let(:comment_post_model) { @comment_2.class.name.underscore.gsub('/comment', '_post') }
  let(:text_comment) { attributes_for(comment_model.to_sym)[:content] }

  before do
    refresh_page
  end

  if moderator
    it ' like comment', js: true do
      prepare_awards
      plus_comment_path = Rails.application.routes.url_helpers.send("plus_comment_#{comment_post_model}_path", project, @comment_1)

      expect(page).to have_link("plus_comment_#{@comment_1.id}", text: 'Выдать баллы', href: plus_comment_path)
      click_link "plus_comment_#{@comment_1.id}"
      sleep(5)
      expect(page).to have_link("plus_comment_#{@comment_1.id}", text: 'Забрать баллы', href: plus_comment_path)
      sleep(5)
      click_link "plus_comment_#{@comment_1.id}"
      expect(page).to have_link("plus_comment_#{@comment_1.id}", text: 'Выдать баллы', href: plus_comment_path)
    end
  else
    it ' not button like' do
      expect(page).not_to have_link("plus_comment_#{@comment_1.id}")
    end
  end

  it ' user likes comment', js: true do
    like_comment_path = Rails.application.routes.url_helpers.send("like_comment_#{comment_post_model}_path", project, @comment_1)

    expect(page).to have_link("like_comment_#{@comment_1.id}", href: like_comment_path + '?against=false')
    expect(page).to have_link("dislike_comment_#{@comment_1.id}", href: like_comment_path + '?against=true')
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
      find('input.send-comment').click
    end

    it { expect(page).to have_content text_comment }

    it { expect change(Journal, :count).by(count) }
  end

  it 'add new comment with image', js: true do
    fill_in 'comment_text_area', with: text_comment
    attach_file("#{comment_model}_image", "#{Rails.root}/spec/support/images/1.jpg")
    sleep(5)
    find('input.send-comment').click
    sleep(5)
    expect(page).to have_content text_comment
    expect(page).to have_selector 'a.image-popup-vertical-fit img'

    Cloudinary::Api.delete_resources('comments/'+ page.first('a.image-popup-vertical-fit img')['alt'].downcase)
  end

  context ' add new answer comment', js: true do
    before do
      click_button "reply_comment_#{@comment_1.id}"
      find("#form_reply_comment_#{@comment_1.id}").find('.comment-textarea').set text_comment
      find("#form_reply_comment_#{@comment_1.id}").find('.send-comment').click
    end

    it { expect(page).to have_content text_comment }

    it { expect change(comment_model_name, :count).by(1) }

    it { expect change(Journal.events_for_my_feed(project, user_data), :count).by(1) }
  end

  context 'add new answer to answer comment', js: true do
    before do
      click_button "reply_comment_#{@comment_2.id}"
      find("#form_reply_comment_#{@comment_2.id}").find('.comment-textarea').set text_comment
      find("#form_reply_comment_#{@comment_2.id}").find('.send-comment').click
    end

    it { expect(page).to have_content text_comment }

    it { expect change(comment_model_name, :count).by(1) }

    it { expect change(Journal.events_for_my_feed(project, user_data), :count).by(1) }
  end

  it 'paginate comments' do
    create_list comment_model.to_sym, 11, post: @comment_1.post
    refresh_page
    expect(page).to have_css 'div.pagination'
    expect(page).to have_css 'a.previous_page'
  end

  context 'mark comment as', js: true do
    if project_status < 7
      it 'discontent' do
        within :css, "a#discontent_comment_#{@comment_1.id}" do
          expect(page).to have_css 'span.label-default'
        end
        click_link "discontent_comment_#{@comment_1.id}"
        within :css, "a#discontent_comment_#{@comment_1.id}" do
          expect(page).to have_css 'span.label-danger'
        end
      end
    end

    it 'concept' do
      within :css, "a#concept_comment_#{@comment_1.id}" do
        expect(page).to have_css 'span.label-default'
      end
      click_link "concept_comment_#{@comment_1.id}"
      within :css, "a#concept_comment_#{@comment_1.id}" do
        expect(page).to have_css 'span.label-warning'
      end
    end

    if moderator
      it 'discuss' do
        within :css, "a#discuss_stat_comment_#{@comment_1.id}" do
          expect(page).to have_css 'span.label-default'
        end
        click_link "discuss_stat_comment_#{@comment_1.id}"
        within :css, "a#discuss_stat_comment_#{@comment_1.id}" do
          expect(page).to have_css 'span.label-danger'
        end
      end

      it 'approve' do
        within :css, "a#approve_stat_comment_#{@comment_1.id}" do
          expect(page).to have_css 'span.label-default'
        end
        click_link "approve_stat_comment_#{@comment_1.id}"
        within :css, "a#approve_stat_comment_#{@comment_1.id}" do
          expect(page).to have_css 'span.label-success'
        end
      end
    else
      it 'show discuss label' do
        @comment_1.update_attributes(discuss_status: true)
        refresh_page
        expect(page).to have_css "span.label-danger#discuss_stat_comment_#{@comment_1.id}"
      end

      it 'show approve label' do
        @comment_1.update_attributes(approve_status: true)
        refresh_page
        expect(page).to have_css "span.label-success#approve_stat_comment_#{@comment_1.id}"
      end
    end
  end

  context 'edit comment', js: true do
    it 'i owner - ok' do
      click_button "edit_comment_#{@comment_1.id}"
      find("#form_edit_comment_#{@comment_1.id}").find('.comment-textarea').set text_comment
      find("#form_edit_comment_#{@comment_1.id}").find('.send-comment').click
    end

    it 'from other users - error' do
      expect(page).not_to have_link "edit_comment_#{@comment_2.id}"
    end
  end

  context 'destroy comment' do
    it 'i owner - ok', js: true do
      expect {
        click_link "destroy_comment_#{@comment_1.id}"
        sleep 5
        expect(page).not_to have_content @comment_1.content
      }.to change(comment_model_name, :count).by(-1)
    end

    unless moderator
      it 'from other users - error' do
        expect(page).not_to have_link "destroy_comment_#{@comment_2.id}"
      end

      it 'post request - error' do
        expect {
          page.driver.submit :put,
                             Rails.application.routes.url_helpers.send(
                                 "destroy_comment_#{comment_post_model}_path", @comment_2.post.project, @comment_2), {}
          expect(current_path).to eq root_path
        }.not_to change(comment_model_name, :count)
      end
    end
  end
end


shared_examples 'likes posts' do |moderator = false|
  let(:post_model) { @post1.class.name.underscore.gsub('/post', '_post') }

  before do
    refresh_page
  end

  if moderator
    it ' like post', js: true do
      prepare_awards
      plus_post_path = Rails.application.routes.url_helpers.send("plus_#{post_model}_path", project, @post1)

      expect(page).to have_link("plus_post_#{@post1.id}", text: 'Выдать баллы', href: plus_post_path)
      click_link "plus_post_#{@post1.id}"
      sleep(5)
      expect(page).to have_link("plus_post_#{@post1.id}", text: 'Забрать баллы', href: plus_post_path)
      sleep(5)
      click_link "plus_post_#{@post1.id}"
      expect(page).to have_link("plus_post_#{@post1.id}", text: 'Выдать баллы', href: plus_post_path)
    end
  else
    it ' not button like' do
      expect(page).not_to have_link("plus_post_#{@post1.id}")
    end
  end

  it ' user likes post', js: true do
    like_post_path = Rails.application.routes.url_helpers.send("like_#{post_model}_path", project, @post1)

    expect(page).to have_link("like_post_#{@post1.id}", href: like_post_path + '?against=false')
    expect(page).to have_link("dislike_post_#{@post1.id}", href: like_post_path + '?against=true')
    click_link "like_post_#{@post1.id}"
    within :css, "span#plus_counter_#{@post1.id}" do
      expect(page).to have_content '1'
    end

    click_link "like_post_#{@post1.id}"
    within :css, "span#plus_counter_#{@post1.id}" do
      expect(page).to have_content '1'
    end

    click_link "dislike_post_#{@post1.id}"
    within :css, "span#minus_counter_#{@post1.id}" do
      expect(page).to have_content '0'
    end
  end
end
