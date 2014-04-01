shared_examples 'with mini help'   do |stage_name|

  it 'first time show help' , js: true  do
    should have_selector("h4#helpModalLabel.modal-title", visible: true)
    should have_selector("button.disabled#send", visible: true)
  end

  it 'answer on mini help question ', js: true do
    post = Help::Post.where(stage: stage, mini: true).first
    quest= post.help_questions.first
    answer = quest.help_answers.first
    choose("question[#{quest.id}][#{answer.id}]")
    click_button 'send'
    #first('span.label-info')
    should have_selector("h4#helpModalLabel.modal-title", visible: false)
  end

  it 'did not show mini help  after answering', js: true do
    should_not have_selector("h4#myModalLabel.modal-title")
  end

end

shared_examples 'add and like comment'   do |voting|

  it 'add comment', js: true do
    should have_selector("input.disabled#send_post")
    fill_in 'comment_text_area', with: 'some text for comment'
    should_not have_selector("input.disabled#send_post")
    click_button 'send_post'
    should have_content 'some text for comment'
  end

  it 'like comment only one time', js:true do
    comment = @post.comments.first
    expect {
      click_link "plus_comment_#{comment.id}"
      should  have_selector("span#plus_counter_comment_#{comment.id}")
      should have_selector("a#plus_comment_#{comment.id}.disabled")
    }.to change(voting_model, :count).by(1)
    visit model_path
    should_not have_selector("a#plus_comment_#{comment.id}")
    should_not have_selector("a#minus_comment_#{comment.id}")
  end

end

shared_examples 'likable post'   do |voting|

  it 'click like on post', js: true do
    expect {
      click_link "plus_post_#{@post.id}"
      should  have_content '1'
      should have_selector("a#plus_post_#{@post.id}.disabled")
    }.to change(voting_model, :count).by(1)
    visit model_path
    should_not have_selector("a#plus_post_#{@post.id}")
    should_not have_selector("a#minus_post_#{@post.id}")
  end
end

shared_examples 'filterable post'   do

  it 'show  only one aspect', js: true do
    check("aspect_#{@aspect1.id}")
    #click_button('filter-aspect')
    #@todo - bad code ajax response waiting
    #first('span.label-info')
    should_not have_selector('span.label-info', text:'aspect 2')
  end

end




