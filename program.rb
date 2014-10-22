require 'active_support/core_ext'
require 'twitter'
require 'dotenv'

Dotenv.load

class Twitters
  def self.execute
    minutes = get_minutes
    current_tweets = Array.new
    # Look at tweets from the whole world
    client.filter(:locations => "-180,-90,180,90") do |tweet|
      puts "Retweet count: #{tweet.retweet_count}"
      current_tweets << tweet
      current_tweets = top_ten(current_tweets, minutes)
      current_tweets.each {|t| puts "#{t.text} (Retweets: #{t.retweet_count})"}
    end
  end

  private
  def self.get_minutes
    puts "Enter number of minutes to look at tweets:"
    minutes = gets.chomp.to_i
    while minutes == 0
      puts "Please enter a non zero integer:"
      minutes = gets.chomp.to_i
    end
    minutes
  end

  def self.client
    Twitter::Streaming::Client.new do |config|
      begin
        config.consumer_key = ENV.fetch('consumer_key')
        config.consumer_secret = ENV.fetch('consumer_secret')
        config.access_token = ENV.fetch('access_token')
        config.access_token_secret = ENV.fetch('access_token_secret')
      rescue KeyError
        raise "Missing twitter keys"
      end
    end
  end

  def self.top_ten(arry, minutes)
    now = DateTime.now
    start_time = now.advance(:minutes => - minutes)
    puts "*"*20
    puts "Top 10 Tweets from #{start_time} to #{now}"
    arry.select{|t| t.created_at >= start_time}.sort_by{|t| t.retweet_count}.reverse.take(10)
  end
end

Twitters::execute