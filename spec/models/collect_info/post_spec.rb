require 'spec_helper'

describe 'CollectInfo::Question', type: :model do
  it 'default factory - valid' do
    expect(build(:collect_info_question)).to be_valid
  end

  context 'invalid without' do
    it 'content' do
      expect(build(:collect_info_question, content: nil)).to be_invalid
    end

    it 'post' do
      expect(build(:collect_info_question, post: nil)).to be_invalid
    end

    it 'project' do
      expect(build(:collect_info_question, project: nil)).to be_invalid
    end

  end
end
