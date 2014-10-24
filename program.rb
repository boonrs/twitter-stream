require 'active_support/core_ext'
require 'twitter'
require 'dotenv'

Dotenv.load

class Twitters
  TOP_X = 10
  attr_accessor :header_text

  def self.execute
    @minutes = get_minutes
    current_tweets = Array.new

    client.sample do |object|
      is_tweet = object.is_a?(Twitter::Tweet)
      if(is_tweet)
        current_tweets << process_tweet(object)
        current_tweets = remove_old_tweets(current_tweets)
        top_tweets = top(current_tweets)
        if top_tweets.length >= 10
          display_top_tweets(top_tweets)
        end
      end
    end
  end

  private
  def self.process_tweet(object)
    text = (object.retweeted_status?)? object.retweeted_status.text : object.text
    time = (object.created?)? object.created_at : DateTime.now
    {:text => text, :time => time}
  end

  def self.display_top_tweets(tweets)
    puts "*"*20
    puts @header_text
    puts "*"*20
    tweets.each_with_index do |t, index| 
      puts "##{index + 1}, #{t[:count]} retweets:"
      puts t[:text]
      puts "-"*10
    end
  end

  def self.remove_old_tweets(tweets)
    now = DateTime.now
    start_time = now.advance(:minutes => - @minutes)
    @header_text = "Tweets between #{start_time} and #{now}"
    tweets.select{|t| t[:time] >= start_time}
  end

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

  def self.top(arry)
    arry.group_by{|t| t[:text]}.map{|key, array| {:text=>array[0][:text], :count=>array.length}}.sort_by{|t| t[:count]}.reverse.take(TOP_X)
  end
end

Twitters::execute