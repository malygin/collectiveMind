require 'spec_helper'

describe 'News', type: :model do
  it 'default factory - valid' do
    expect(build(:news)).to be_valid
  end

  it 'for_last_day' do
    create :news, created_at: 2.days.ago
    create :news, created_at: 1.day.ago
    today_news = create :news, created_at: Date.today
    news = create :news
    expect(News.for_last_day).to match_array [news]
  end
end
