require 'spec_helper'

describe 'Concept::Voting', type: :model do
  it 'default factory - valid' do
    expect(build(:concept_voting)).to be_valid
  end

  context 'invalid without' do
    it 'user' do
      expect(build(:concept_voting, user: nil)).to be_invalid
    end

    it 'post_aspect' do
      expect(build(:concept_voting, concept_post_aspect_id: nil)).to be_invalid
    end
  end
end