# encoding: utf-8
shared_examples 'content with comments' do |project,user_data,moderator = false|

  if moderator == true
    it ' like comment', js: true do
      prepare_awards
      expect(page).to have_link("plus_comment_#{@comment1.id}", :text => 'Выдать баллы', :href => plus_comment_life_tape_post_path(project,@comment1))
      click_link "plus_comment_#{@comment1.id}"
      expect(page).to have_link("plus_comment_#{@comment1.id}", :text => 'Забрать баллы', :href => plus_comment_life_tape_post_path(project,@comment1))
      click_link "plus_comment_#{@comment1.id}"
      expect(page).to have_content 'Выдать баллы'
    end
  end

  it 'view comments ' do
    expect(page).to have_content @comment1.content
    expect(page).to have_selector '#new_aspect'
    expect(page).to have_selector 'textarea#comment_text_area'
    # expect(page).to have_link("plus_comment_#{@comment1.id}", :text => 'Выдать баллы', :href => plus_comment_life_tape_post_path(project,@comment1))
  end

  it 'add new comment in aspect ', js: true do
    fill_in 'comment_text_area', with: 'new comment'
    expect {
      find('input.send-comment').click
      expect(page).to have_content 'new comment'
    }.to change(Journal, :count).by(1)
  end

  it 'add new comment in aspect with images ', js: true do
    fill_in 'comment_text_area', with: 'new comment'
    attach_file('life_tape_comment_image', "#{Rails.root}/spec/support/images/1.jpg")
    sleep(5)
    find('input.send-comment').click
    sleep(5)
    expect(page).to have_content 'new comment'
    expect(page).to have_selector 'a.image-popup-vertical-fit img'

    Cloudinary::Api.delete_resources('comments/'+ page.first( 'a.image-popup-vertical-fit img')['alt'].downcase)
  end

  it ' add new answer comment', js: true do
    click_button "reply_comment_#{@comment1.id}"
    find("#form_reply_comment_#{@comment1.id}").find('.comment-textarea').set "new child comment"
    expect {
      find("#form_reply_comment_#{@comment1.id}").find('.send-comment').click
      expect(page).to have_content 'new child comment'
    }.to change(Journal.events_for_my_feed(project, user_data), :count).by(1)
  end

  context 'answer to answer comment' do
    before do
      @comment2 = FactoryGirl.create :life_tape_comment, post: @post1, user: user_data, comment_id: @comment1.id, content: 'comment 2'
      visit life_tape_posts_path(project)
    end
    it ' add new answer to answer comment', js: true do
      click_button "reply_comment_#{@comment2.id}"
      find("#form_reply_comment_#{@comment2.id}").find('.comment-textarea').set "new child to answer comment"
      expect {
        find("#form_reply_comment_#{@comment2.id}").find('.send-comment').click
        expect(page).to have_content "new child to answer comment"
      }.to change(Journal.events_for_my_feed(project, user_data), :count).by(1)
    end
  end

end


#shared_examples 'validation links' do
#  it ' validate journal' do
#    visit journals_path(project)
#    expect(page).to have_content 'События'
#  end
#  it ' validate knowbase' do
#    visit knowbase_posts_path(project)
#    expect(page).to have_selector "a", 'вернуться к процедуре'
#  end
#  #it ' validate help' do
#  #  visit help_posts_path(project)
#  #  expect(page).to have_selector "a", 'вернуться к процедуре'
#  #end
#  it ' validate reiting' do
#    visit users_path(project)
#    expect(page).to have_content 'Рейтинг участников'
#  end
#  it ' validate profile' do
#    visit user_path(project,user)
#    expect(page).to have_content user.to_s
#    expect(page).to have_content 'Достижения'
#  end
#end


#shared_examples 'with mini help'   do |stage_name|
#
#  it 'first time show help' , js: true  do
#    should have_selector("h4#helpModalLabel.modal-title", visible: true)
#    should have_selector("button.disabled#send", visible: true)
#  end
#
#  it 'answer on mini help question ', js: true do
#    post = Help::Post.where(stage: stage, mini: true).first
#    quest= post.help_questions.first
#    answer = quest.help_answers.first
#    choose("question_#{quest.id}_#{answer.id}")
#    click_button 'send'
#    #first('span.label-info')
#    should have_selector("h4#helpModalLabel.modal-title", visible: false)
#  end
#
#  it 'did not show mini help  after answering', js: true do
#    should_not have_selector("h4#myModalLabel.modal-title")
#  end
#
#end
#
#shared_examples 'add and like comment'   do |voting|
#
#  it 'add comment', js: true do
#    should have_selector("input.disabled#send_post")
#    fill_in 'comment_text_area', with: 'some text for comment'
#    should_not have_selector("input.disabled#send_post")
#    click_button 'send_post'
#    should have_content 'some text for comment'
#  end
#
#  #it 'like comment only one time', js:true do
#  #  comment = @post.comments.first
#  #  expect {
#  #    click_link "plus_comment_#{comment.id}"
#  #    should  have_selector("span#plus_counter_comment_#{comment.id}")
#  #    should have_selector("a#plus_comment_#{comment.id}.disabled")
#  #  }.to change(voting_model, :count).by(1)
#  #  visit model_path
#  #  should_not have_selector("a#plus_comment_#{comment.id}")
#  #  should_not have_selector("a#minus_comment_#{comment.id}")
#  #end
#
#end
#
#shared_examples 'likable post'   do |voting|
#
#  it 'click like on post', js: true do
#    expect {
#      click_link "plus_post_#{@post.id}"
#      should  have_content '1'
#      should have_selector("a#plus_post_#{@post.id}.disabled")
#    }.to change(voting_model, :count).by(1)
#    visit model_path
#    should_not have_selector("a#plus_post_#{@post.id}")
#    should_not have_selector("a#minus_post_#{@post.id}")
#  end
#end
#
#shared_examples 'filterable post'   do
#
#  it 'show  only one aspect', js: true do
#    check("aspect_#{@aspect1.id}")
#    #click_button('filter-aspect')
#    #@todo - bad code ajax response waiting
#    first('span.label-info')
#    should_not have_selector('span.label-info', text:'aspect 2')
#  end
#
#end

