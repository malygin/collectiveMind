shared_examples 'content with comments' do |count = 2, moderator = false|
  let(:text_comment) { 'new child to answer comment' }

  if moderator
    it ' like comment', js: true do
      prepare_awards
      expect(page).to have_link("plus_comment_#{@comment1.id}", text: 'Выдать баллы', href: plus_comment_life_tape_post_path(project, @comment1))

      click_link "plus_comment_#{@comment1.id}"

      expect(page).to have_link("plus_comment_#{@comment1.id}", text: 'Забрать баллы', href: plus_comment_life_tape_post_path(project, @comment1))
      click_link "plus_comment_#{@comment1.id}"

      expect(page).to have_link("plus_comment_#{@comment1.id}", text: 'Забрать баллы', href: plus_comment_life_tape_post_path(project, @comment1))
    end
  else
    it ' not button like' do
      expect(page).not_to have_link("plus_comment_#{@comment1.id}")
    end
  end

  it 'view comments ' do
    expect(page).to have_content @comment1.content
  end

  it 'paginate comments' do

  end

  context 'add new comment', js: true do
    before do
      fill_in 'comment_text_area', with: text_comment
      find('input.send-comment').click
    end

    it { expect(page).to have_content text_comment }

    it { expect change(Journal, :count).by(count) }
  end

  xit 'add new comment with image', js: true do
    fill_in 'comment_text_area', with: text_comment
    attach_file('life_tape_comment_image', "#{Rails.root}/spec/support/images/1.jpg")
    sleep(5)
    find('input.send-comment').click
    sleep(5)
    expect(page).to have_content text_comment
    expect(page).to have_selector 'a.image-popup-vertical-fit img'

    Cloudinary::Api.delete_resources('comments/'+ page.first('a.image-popup-vertical-fit img')['alt'].downcase)
  end

  it ' add new answer comment', js: true do
    click_button "reply_comment_#{@comment1.id}"
    find("#form_reply_comment_#{@comment1.id}").find('.comment-textarea').set text_comment
    expect {
      find("#form_reply_comment_#{@comment1.id}").find('.send-comment').click
      expect(page).to have_content text_comment
    }.to change(Journal.events_for_my_feed(project, user_data), :count).by(1)
  end

  context 'answer to answer comment' do
    before do
      @comment2 = create :life_tape_comment, post: @post1, comment_id: @comment1.id
      refresh_page
    end

    it ' add new answer to answer comment', js: true do
      click_button "reply_comment_#{@comment2.id}"
      find("#form_reply_comment_#{@comment2.id}").find('.comment-textarea').set text_comment
      expect {
        find("#form_reply_comment_#{@comment2.id}").find('.send-comment').click
        expect(page).to have_content text_comment
      }.to change(Journal.events_for_my_feed(project, user_data), :count).by(1)
    end
  end
end
