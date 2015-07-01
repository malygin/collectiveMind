require 'spec_helper'

describe 'Aspect::Voting', type: :model do
  it 'default factory - valid' do
    expect(build(:aspect_voting)).to be_valid
  end

  context 'invalid without' do
    it 'user' do
      expect(build(:aspect_voting, user: nil)).to be_invalid
    end

    it 'aspect' do
      expect(build(:aspect_voting, aspect: nil)).to be_invalid
    end
  end
end
