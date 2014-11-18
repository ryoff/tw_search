class CreateTweet < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.column   :since_id,    'BIGINT UNSIGNED', null: false, default: 0
      t.string   :search_word, limit: 100
      t.string   :name,        limit: 100
      t.string   :full_text,   limit: 500
      t.string   :uri,         limit: 1000
      t.datetime :tweet_time

      t.timestamps
    end

    add_index "tweets", ["search_word", "since_id"]
  end

  def down
    drop_table :tweets
  end
end
