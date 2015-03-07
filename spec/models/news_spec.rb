require 'spec_helper'

describe 'News', type: :model do
  it 'default factory - valid' do
    expect(build(:news)).to be_valid
  end

  xit 'for_last_day' do
    old_news = create :news, created_at: 2.days.ago
    today_news = create :news, created_at: Date.today
    news = create :news
    expect(News.for_last_day).to match_array [today_news, news]
  end
end
