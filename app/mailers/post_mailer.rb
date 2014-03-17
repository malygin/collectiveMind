class PostMailer < ActionMailer::Base
  #include Resque::Mailer

  default from: "mass-decision@yandex.ru"

  def add_comment (post, comment)
    @user = post.user
    @comment  = comment
    @post = post
    #@todo тему нельзя писать кириллицей
    mail(to: @user.email, subject: 'Massdecision ')
  end
end