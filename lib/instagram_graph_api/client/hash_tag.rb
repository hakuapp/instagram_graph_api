module InstagramGraphApi
  class Client
    module HashTag

      MEDIA_DEFAULT_FIELDS = "id,caption,comments_count,like_count,media_type,media_url,children{media_url}"

      def get_tag_id(name)
        begin
          accounts = ig_business_accounts
          user_id  = accounts.first['id'] if accounts.any?
          graph_call("ig_hashtag_search?user_id=#{user_id}&q=#{name}").first
        rescue Exception => e
          return nil
        end
      end

      def recent_tag_media(tag_id, fields = nil)
        get_media tag_id, 'recent', fields
      end

      def recent_tag_media_by_name(name, fields = nil)
        tag_id_response = get_tag_id(name)
        tag_id_response ? get_media(tag_id_response["id"], 'recent', fields) : []
      end

      def top_tag_media(tag_id, fields = nil)
        get_media tag_id, 'top', fields
      end

      def top_tag_media_by_name(name, fields = nil)
        tag_id_response = get_tag_id(name)
        tag_id_response ? get_media(tag_id_response["id"], 'top', fields) : []
      end

      private

      def get_media(tag_id, type, fields)
        fields   ||= MEDIA_DEFAULT_FIELDS
        accounts = ig_business_accounts
        user_id  = accounts.first['id'] if accounts.any?
        puts "user_id: #{user_id}, tag_id: #{tag_id}"
        get_connections(tag_id, "#{type}_media?user_id=#{user_id}&fields=#{fields}")
      end

    end
  end
end