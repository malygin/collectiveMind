require 'spec_helper'

describe 'Aspect::Question', type: :model do
  it 'default factory - valid' do
    expect(build(:aspect_question)).to be_valid
  end

  context 'invalid without' do
    it 'content' do
      expect(build(:aspect_question, content: nil)).to be_invalid
    end

    it 'project' do
      expect(build(:aspect_question, project: nil)).to be_invalid
    end
  end
end
