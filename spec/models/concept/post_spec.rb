require 'spec_helper'

describe 'Concept::Post', type: :model do
  it 'default factory - valid' do
    expect(build(:concept)).to be_valid
  end

  context 'invalid without' do
    it 'status' do
      expect(build(:concept, status: nil)).to be_invalid
    end

    it 'user' do
      expect(build(:concept, user: nil)).to be_invalid
    end

    it 'project' do
      expect(build(:concept, project: nil)).to be_invalid
    end
  end

  it 'by project' do
    create :concept
    post2 = create :concept
    post3 = create :concept, project: post2.project
    expect(Concept::Post.by_project(post2.project.id)).to match_array([post2, post3])
  end
end
