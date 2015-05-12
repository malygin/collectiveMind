require 'spec_helper'

describe 'Discontent::Post', type: :model do
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
  end

  it 'for union' do
    create :discontent
    post2 = create :discontent, status: 1
    post3 = create :discontent, project: post2.project
    expect(Discontent::Post.for_union(post2.project.id)).to match_array([post3])
  end

  it_behaves_like 'base post', :discontent, Discontent::Post
end
