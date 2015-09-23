require 'spec_helper'

describe 'Discontent::Voting', type: :model do
  it 'default factory - valid' do
    expect(build(:discontent_voting)).to be_valid
  end

  context 'invalid without' do
    it 'user' do
      expect(build(:discontent_voting, user: nil)).to be_invalid
    end

    it 'post' do
      expect(build(:discontent_voting, discontent_post_id: nil)).to be_invalid
    end
  end

  it 'by_positive' do
    dv = create :discontent_voting, against: true
    create :discontent_voting, against: false
    expect(Discontent::Voting.by_positive).to match_array [dv]
  end

  it 'by_negative' do
    create :discontent_voting, against: true
    dv2 = create :discontent_voting, against: false
    expect(Discontent::Voting.by_negative).to match_array [dv2]
  end

  # it 'not_admins' do
  #   create :discontent_voting, user: create(:moderator)
  #   dv = create :discontent_voting
  #   expect(Discontent::Voting.not_admins).to match_array [dv]
  # end
end
