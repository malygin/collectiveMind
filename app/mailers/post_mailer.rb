class PostMailer < ActionMailer::Base
  include Resque::Mailer

  default from: "mass-decision@yandex.ru"#, content_type: "text/html"

  def add_comment (post, comment)
    # @user = post.user
    # @comment  = comment
    # @post = post
    #@todo тему нельзя писать кириллицей
    # mail(to: @user.email, subject: 'Massdecision ')
    # mail(to: 'mass-decision@yandex.ru', subject: 'Massdecision ')
    mail(to: 'irivertime@list.ru', subject: 'Massdecision ')
  end

  def feed_moderator(user,arr)
    @user = User.find(user)
    @projects_count = arr
    mail(to: @user.email, subject: 'Massdecision ')
  end
end