require 'spec_helper'

describe 'CollectInfo::Voting', type: :model do
  it 'default factory - valid' do
    expect(build(:collect_info_voting)).to be_valid
  end

  context 'invalid without' do
    it 'user' do
      expect(build(:collect_info_voting, user: nil)).to be_invalid
    end

    it 'aspect' do
      expect(build(:collect_info_voting, aspect: nil)).to be_invalid
    end
  end
end
