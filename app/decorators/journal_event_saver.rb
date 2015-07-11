class JournalEventSaver
  # attr_reader journal
  #
  # def initialize(journal)
  #   @journal = journal
  # end
  def self.post_save_event(h = {})
    h[:user].journals.build(type_event: h[:post].class_name + '_save', project: h[:project], body: h[:post].field_for_journal, first_id: h[:post].id).save!
  end

  def self.post_update_event(h = {})
    h[:user].journals.build(type_event: h[:post].class_name + '_update', project: h[:project], body: h[:post].field_for_journal, first_id: h[:post].id).save!
  end

  def self.comment_event(h = {})
    # @todo новости и информирование авторов
    h[:user].journals.build(type_event: h[:comment].class_name + '_save', project: h[:project], body: h[:comment].field_for_journal,
                            body2: h[:post].field_for_journal, first_id: h[:post].id, second_id: h[:comment].id).save!

    if h[:post].user != h[:user]
      h[:user].journals.build(type_event: 'my_' + h[:comment].class_name, user_informed: h[:post].user, project: h[:project], body: h[:comment].field_for_journal,
                              body2: h[:post].field_for_journal, first_id: h[:post].id, second_id: h[:comment].id, personal: true, viewed: false).save!
    end

    if h[:answer] && h[:answer].user != h[:user]
      h[:user].journals.build(type_event: 'reply_' + h[:comment].class_name, user_informed: h[:answer].user, project: h[:project], body: h[:comment].field_for_journal,
                              body2: h[:post].field_for_journal, first_id: h[:post].id, second_id: h[:comment].id, personal: true, viewed: false).save!
    end
  end

  def self.like_event(h = {})
    if h[:post].user != h[:user]
      h[:user].journals.build(type_event: 'my_' + h[:post].class_name + (h[:against] == 'false' ? '_like' : '_dislike'), user_informed: h[:post].user,
                              project: h[:project], body: h[:post].field_for_journal, first_id: h[:post].id, personal: true, viewed: false).save!
    end
  end

  def self.like_comment_event(h = {})
    if h[:comment].user != h[:user]
      h[:user].journals.build(type_event: 'my_' + h[:comment].class_name + (h[:against] == 'false' ? '_like' : '_dislike'), user_informed: h[:comment].user,
                              project: h[:project], body: h[:comment].field_for_journal, body2: h[:comment].post.field_for_journal,
                              first_id: h[:comment].post.id, second_id: h[:comment].id, personal: true, viewed: false).save!
    end
  end

  def self.change_comment_status_event(h = {})
    h[:user].journals.build(type_event: h[:comment].class_name + '_' + h[:type], project: h[:project],
                            body: h[:comment].field_for_journal, body2: h[:comment].post.field_for_journal,
                            first_id: h[:comment].post.id, second_id: h[:comment].id).save!

    if h[:comment].user != h[:user]
      h[:user].journals.build(type_event: 'my_' + [:comment].class_name + '_' + type, user_informed: [:comment].user, project: h[:project],
                              body: [:comment].field_for_journal, body2: h[:comment].post.field_for_journal,
                              first_id: h[:comment].post.id, second_id: h[:comment].id,
                              personal: true, viewed: false).save!
    end
  end
end
