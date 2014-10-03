# Be sure to restart your server when you modify this file.

CollectiveMind::Application.config.session_store :active_record_store, key: '_collective_mind_session'
ActiveRecord::SessionStore::Session.attr_accessible :data, :session_id
