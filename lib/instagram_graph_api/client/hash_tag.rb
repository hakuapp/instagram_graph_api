module InstagramGraphApi
  class Client
    module HashTag

      MEDIA_DEFAULT_FIELDS = "id,caption,comments_count,like_count,media_type,media_url,children{media_url}"

      def get_tag_id(name)
        accounts = ig_business_accounts
        user_id  = accounts.first['id'] if accounts.any?
        uri      = "ig_hashtag_search?user_id=#{user_id}&q=#{name}"
        puts "graph call get tags: #{uri}"
        graph_call(uri).first
      rescue Exception => e
        puts e.message
        return nil
      end

      def recent_tag_media(tag_id, fields = nil, limit = 50)
        get_media tag_id, 'recent', fields, limit
      end

      def recent_tag_media_by_name(name, fields = nil, limit = 50)
        tag_id_response = get_tag_id(name)
        tag_id_response ? get_media(tag_id_response["id"], 'recent', fields, limit) : []
      end

      def top_tag_media(tag_id, fields = nil, limit = 50)
        get_media tag_id, 'top', fields, limit
      end

      def top_tag_media_by_name(name, fields = nil, limit = 50)
        tag_id_response = get_tag_id(name)
        tag_id_response ? get_media(tag_id_response["id"], 'top', fields, limit) : []
      end

      private

      def get_media(tag_id, type, fields, limit = 50)
        fields   ||= MEDIA_DEFAULT_FIELDS
        accounts = ig_business_accounts
        user_id  = accounts.first['id'] if accounts.any?
        puts "user_id: #{user_id}, tag_id: #{tag_id}"
        get_connections(tag_id, "#{type}_media?user_id=#{user_id}&fields=#{fields}&limit=#{limit}")
      end

    end
  end
end