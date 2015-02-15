require 'spec_helper'

describe 'CollectInfo::UserAnswers', type: :model do
  it 'default factory - valid' do
    expect(build(:collect_info_answers_user)).to be_valid
  end

  context 'invalid without' do
    it 'user' do
      expect(build(:collect_info_answers_user, user: nil)).to be_invalid
    end

    it 'project' do
      expect(build(:collect_info_answers_user, project: nil)).to be_invalid
    end

    it 'answer' do
      expect(build(:collect_info_answers_user, answer: nil)).to be_invalid
    end

    it 'question' do
      expect(build(:collect_info_answers_user, question: nil)).to be_invalid
    end
  end
end