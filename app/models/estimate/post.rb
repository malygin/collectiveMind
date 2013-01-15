class Estimate::Post < ActiveRecord::Base
  attr_accessible :content, :nepr, :nepr1, :nepr2, :nepr3, :nepr4, :onpsh, :onpsh1, :onpsh2, :onpsh3, :oppsh, :oppsh1, :oppsh2, :oppsh3, :ozpshf, :ozpshf1, :ozpshf2, :ozpshf3, :ozpshs, :ozpshs1, :ozpshs2, :ozpshs3
  belongs_to :user
  belongs_to :post, :class_name => "Plan::Post"

end
