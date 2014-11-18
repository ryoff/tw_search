module Batches
  class Base < ActionController::Base

    class << self
      def execute(*args)
        # [debug] 開発時に、SQLを標準出力に出す
        ActiveRecord::Base.logger = Logger.new(STDOUT) if ENV['RAILS_ENV'] === 'development'

        run(*args)
      end
    end

    # base.rb で共通の例外処理を行うために、run methodを定義し、こいつをbegin ~ rescue する形にする
    # subclassでは、runを定義してもらう
    def run
      abort("please override me")
    end
  end
end
