require 'rubygems'
gem 'twitter4r'
require 'twitter'

client=Twitter::Client.new(:login => 'twitter_user_name', :password=>'twitter_password')
client.status(:post, ARGV[0])

