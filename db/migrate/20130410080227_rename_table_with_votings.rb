class RenameTableWithVotings < ActiveRecord::Migration
  def up
  	rename_table :life_tape_post_voitings, :life_tape_post_votings
  	rename_table :life_tape_comment_voitings, :life_comment_votings
	rename_table :discontent_post_voitings, :discontent_post_votings
  	rename_table :discontent_comment_voitings, :discontent_comment_votings
	rename_table :essay_post_voitings, :essay_post_votings
  	rename_table :essay_comment_voitings, :essay_comment_votings
  	rename_table :expert_news_comment_voitings, :expert_news_comment_votings

  end

  def down
  	rename_table :life_tape_post_votings, :life_tape_post_voitings
  	rename_table :life_tape_comment_votings, :life_comment_voitings
	rename_table :discontent_post_votings, :discontent_post_voitings
  	rename_table :discontent_comment_votings, :discontent_comment_voitings
	rename_table :essay_post_votings, :essay_post_voitings
  	rename_table :essay_comment_votings, :essay_comment_voitings
  	rename_table :expert_news_comment_votings, :expert_news_comment_voitings

  end
end
