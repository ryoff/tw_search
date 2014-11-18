module Apis
  module Chatwork
    class Comment < Apis::Chatwork::Base

      def initialize(room_id = CHATWORK_ROOM_ID)
        @room_id = room_id
      end

      # comment classは、ただ渡された引数を設定するだけなので何もしていないが、
      # 本来はこのmethod内で、@bodyにメッセージを埋め込む処理を書く
      # ex) KPIデータ取得など
      def set_body(body = nil)
        @body = body
      end
    end
  end
end

