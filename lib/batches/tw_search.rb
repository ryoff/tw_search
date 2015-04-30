module Batches
  class TwSearch < Batches::Base
    class << self

      def execute(word = '', options = {})
        super
      end

      def run(word = '', options = {})
        client = generate_twitter_client

        since_id = Tweet.last_since_id(word)

        client.search("#{word} -rt", lang: "ja", result_type: 'recent', since_id: since_id).take(10).reverse.collect do |tweet|
          # すでにdbにあればskip
          next if Tweet.find_by_word_and_since_id(word, tweet.id)

          # 別tweetだけど、全く同じ本文なら、skip (非公式RTなど、大量に同じtweetでチャットが溢れる対策)
          # urlが含まれると、短縮urlが毎回ユニークになってしまうので、先頭〜20文字で比較している
          next if Tweet.where(search_word: word).where("full_text like '#{tweet.full_text[0,20]}%'").size > 0

          Tweet.new(
            since_id:    tweet.id,
            search_word: word,
            name:        tweet.user.screen_name,
            full_text:   tweet.full_text,
            uri:         tweet.uri.to_s,
            tweet_time:  tweet.created_at
          ).save!

          comment = "[info][title]検索ワード【#{word}】[/title]#{tweet.full_text} [hr]@#{tweet.user.screen_name}\n#{tweet.uri.to_s} / #{tweet.created_at}[/info]"

          chatwork = Apis::Chatwork::Comment.new(options[:room_id])
          chatwork.comment(comment)
        end
      end

      def generate_twitter_client
        Twitter::REST::Client.new do |config|
          config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
          config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
          config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
          config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
        end
      end

      def usage
        puts "特定のワードを検索して、chatwork等のチャットシステムにpostする"
        puts "tokenやデフォルトのroom_id等は、.envファイルに記述する"
        puts ""
        puts "通常の検索             : rails runner -e production \"Batches::TwSearch.execute('search_word')\""
        puts "Chatworkの部屋idを指定 : rails runner -e production \"Batches::TwSearch.execute('search_word', { room_id: xxx })\""
        exit
      end
    end
  end
end
