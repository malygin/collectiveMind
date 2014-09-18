# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
#@todo Удалить secret_token после того, как все юзеры зайдут на сайт
CollectiveMind::Application.config.secret_token = 'aa47340cd4336db9fd23f7a9480d04d0ecbfe56ad30b4236f4f02e95f20f2351beec95743ac9d837ffaa642db9c7802756bd598a412ad372581bd17760c4c5d0'
CollectiveMind::Application.config.secret_key_base = 'de8908a487d6fe3df66f70353c55cc432eca4b1748d55fb7e370f63d92d5603a4b6cc75d1b4e8704bc26b1a67effec3bf4d61f4e7d6d938da75f46c83a7c71a5'
