require 'spec_helper'

describe 'LifeTape::Post', type: :model do
  it 'default factory - valid' do
    expect(build(:life_tape_post)).to be_valid
  end

  context 'invalid without' do
    it 'user' do
      expect(build(:life_tape_post, user: nil)).to be_invalid
    end

    it 'project' do
      expect(build(:life_tape_post, project: nil)).to be_invalid
    end
  end

  it 'by project' do
    post1 = create :life_tape_post
    post2 = create :life_tape_post
    post3 = create :life_tape_post, project: post2.project

    expect(LifeTape::Post.by_project(post2.project.id)).to match_array([post2, post3])
  end
end
