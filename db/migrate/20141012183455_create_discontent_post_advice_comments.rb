class CreateDiscontentPostAdviceComments < ActiveRecord::Migration
  def change
    create_table :discontent_post_advice_comments do |t|
      t.references :post_advice, index: true
      t.references :user, index: true
      t.string :content
      t.references :post_advice_comment, index: true

      t.timestamps
    end
  end
end
