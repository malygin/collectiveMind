require 'spec_helper'

describe 'Aspect::UserAnswer', type: :model do
  it 'default factory - valid' do
    expect(build(:aspect_user_answer)).to be_valid
  end

  context 'invalid without' do
    it 'user' do
      expect(build(:aspect_user_answer, user: nil)).to be_invalid
    end

    it 'project' do
      expect(build(:aspect_user_answer, project: nil)).to be_invalid
    end

    it 'question' do
      expect(build(:aspect_user_answer, question: nil)).to be_invalid
    end

    it 'aspect' do
      expect(build(:aspect_user_answer, aspect: nil)).to be_invalid
    end
  end
end
