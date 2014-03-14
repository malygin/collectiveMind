class PostMailer < ActionMailer::Base
  default from: "massdecision@gmail.com"

  def add_comment (post, comment)
    @user = post.user
    @comment  = comment
    @post = post
    #@todo тему нельзя писать кириллицей
    mail(to: @user.email, subject: 'Massdecision ')
  end
end