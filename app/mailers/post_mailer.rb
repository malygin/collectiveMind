class PostMailer < ActionMailer::Base
  include Resque::Mailer

  default from: 'mass-decision@yandex.ru'

  def add_comment(post, comment)
    @user = post.user
    @comment = comment
    @post = post
    # @todo тему нельзя писать кириллицей
    mail(to: @user.email, subject: 'Massdecision ')
  end

  def feed_mailer(user, feed)
    @user = User.find(user)
    @projects_feed = feed
    mail(to: @user.email, from: 'massdecision@gmail.com', subject: 'Massdecision ')
  end

  def moderator_mailer(user, mail)
    @user = User.find(user)
    @mail = JournalMailer.find(mail)
    title = (@mail && @mail.title.present?) ? @mail.title : 'Massdecision '
    mail(to: @user.email, from: 'massdecision@gmail.com', subject: title)
  end

  def stages_mailer(user, project)
    @user = User.find(user)
    @project = Core::Project.find(project)
    mail(to: @user.email, from: 'massdecision@gmail.com', subject: 'Massdecision ')
  end
end
