require 'spec_helper'

describe 'Discontent::Post', type: :model do
  it 'default factory - valid' do
    expect(build(:discontent)).to be_valid
  end

  context 'invalid without' do
    it 'content' do
      expect(build(:discontent, content: '')).to be_invalid
    end

    it 'whend' do
      expect(build(:discontent, whend: '')).to be_invalid
    end

    it 'whered' do
      expect(build(:discontent, whered: '')).to be_invalid
    end

    it 'project' do
      expect(build(:discontent, project: nil)).to be_invalid
    end
  end

  it 'by project' do
    create :discontent
    post2 = create :discontent
    post3 = create :discontent, project: post2.project
    expect(Discontent::Post.by_project(post2.project.id)).to match_array([post2, post3])
  end

  it 'for union' do
    create :discontent
    post2 = create :discontent, status: 1
    post3 = create :discontent, project: post2.project
    expect(Discontent::Post.for_union(post2.project.id)).to match_array([post3])
  end

  it 'united_for_vote'

  context 'by_status_for_discontent' do
  end
end
