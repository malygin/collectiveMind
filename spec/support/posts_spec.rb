shared_examples 'content with comments' do |comment_model = 'CollectInfo::Comment', moderator = false, count = 2|
  let(:text_comment) { attributes_for(:life_tape_comment)[:content] }

  before do
    refresh_page
  end

  if moderator
    it ' like comment', js: true do
      prepare_awards
      expect(page).to have_link("plus_comment_#{@comment_1.id}", text: 'Выдать баллы', href: plus_comment_life_tape_post_path(project, @comment_1))

      click_link "plus_comment_#{@comment_1.id}"

      expect(page).to have_link("plus_comment_#{@comment_1.id}", text: 'Забрать баллы', href: plus_comment_life_tape_post_path(project, @comment_1))
      click_link "plus_comment_#{@comment_1.id}"

      expect(page).to have_link("plus_comment_#{@comment_1.id}", text: 'Забрать баллы', href: plus_comment_life_tape_post_path(project, @comment_1))
    end
  else
    it ' not button like' do
      expect(page).not_to have_link("plus_comment_#{@comment_1.id}")
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
    attach_file('life_tape_comment_image', "#{Rails.root}/spec/support/images/1.jpg")
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

    it { expect change(comment_model.constantize, :count).by(1) }

    it { expect change(Journal.events_for_my_feed(project, user_data), :count).by(1) }
  end

  context 'add new answer to answer comment', js: true do
    before do
      click_button "reply_comment_#{@comment_2.id}"
      find("#form_reply_comment_#{@comment_2.id}").find('.comment-textarea').set text_comment
      find("#form_reply_comment_#{@comment_2.id}").find('.send-comment').click
    end

    it { expect(page).to have_content text_comment }

    it { expect change(comment_model.constantize, :count).by(1) }

    it { expect change(Journal.events_for_my_feed(project, user_data), :count).by(1) }
  end

  it 'paginate comments' do
    create_list :life_tape_comment, 11, post: @comment_1.post
    refresh_page
    expect(page).to have_css 'div.pagination'
    expect(page).to have_css 'a.previous_page'
  end

  context 'mark comment as', js: true do
    it 'discontent' do
      within :css, "a#discontent_comment_#{@comment_1.id}" do
        expect(page).to have_css 'span.label-default'
      end
      click_link "discontent_comment_#{@comment_1.id}"
      within :css, "a#discontent_comment_#{@comment_1.id}" do
        expect(page).to have_css 'span.label-danger'
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

  context 'destroy comment', js: true do
    # @todo добавить тесты контроллера на прямую отправку пост запроса
    it 'i owner - ok' do
      expect {
        click_link "destroy_comment_#{@comment_1.id}"
        sleep 5
        expect(page).not_to have_content @comment_1.content
      }.to change(comment_model.constantize, :count).by(-1)
    end

    it 'from other users - error' do
      unless moderator
        expect(page).not_to have_link "destroy_comment_#{@comment_2.id}"
      end
    end
  end

  it 'choose aspect'
end
