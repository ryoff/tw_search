module Apis
  module Chatwork
    # logger などを利用するために、ActionController::Baseを継承
    class Base < ActionController::Base
      attr_accessor :body, :room_id

      CHATWORK_API_TOKEN   = ENV['CHATWORK_API_TOKEN']
      CHATWORK_ROOM_ID     = ENV['CHATWORK_ROOM_ID']
      CHATWORK_DEV_ROOM_ID = ENV['CHATWORK_DEV_ROOM_ID'] # env=development の場合に利用するroom_id

      def comment(msg = nil)
        set_body(msg)
        send_comment
      rescue => e
        logger.error({
          class_name: self.class.name,
          message:    e.message,
          backtrace:  e.backtrace
        })
      end

      def set_body
        abort("please override me")
      end

      def send_comment
        return unless @body

        @room_id = CHATWORK_DEV_ROOM_ID unless ENV['RAILS_ENV'] === 'production'
        ChatWork.api_key = CHATWORK_API_TOKEN
        ChatWork::Message.create(room_id: @room_id, body: @body)
      end
    end
  end
end
