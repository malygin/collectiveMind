require 'spec_helper'

describe 'CollectInfo::Answer', type: :model do
  it 'default factory - valid' do
    expect(build(:collect_info_answer)).to be_valid
  end

  context 'invalid without' do
    it 'content' do
      expect(build(:collect_info_answer, content: nil)).to be_invalid
    end

    it 'project' do
      expect(build(:collect_info_answer, question: nil)).to be_invalid
    end
  end
end
