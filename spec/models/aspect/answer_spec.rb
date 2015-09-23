require 'spec_helper'

describe 'Aspect::Answer', type: :model do
  it 'default factory - valid' do
    expect(build(:aspect_answer)).to be_valid
  end

  context 'invalid without' do
    it 'content' do
      expect(build(:aspect_answer, content: nil)).to be_invalid
    end

    it 'project' do
      expect(build(:aspect_answer, question: nil)).to be_invalid
    end
  end
end
