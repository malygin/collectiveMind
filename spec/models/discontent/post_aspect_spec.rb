require 'spec_helper'

describe 'Discontent::PostAspect', type: :model do
  it 'default factory - valid' do
    expect(build(:discontent_post_aspect)).to be_valid
  end

  context 'invalid without' do
    it 'aspect' do
      expect(build(:discontent_post_aspect, core_aspect: nil)).to be_invalid
    end
  end
end
