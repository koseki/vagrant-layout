module VagrantPlugins
  module Layout
    #
    # Command Target
    #
    class Target
      DEFAULT_REPOSITORY = %w{koseki vagrant-layout master}

      attr_reader :type, :url

      def initialize(target_str, default_repository = nil)
        @default_repository = default_repository || DEFAULT_REPOSITORY
        if target_str.to_s.strip.empty?
          github_target(@default_repository)
        elsif target_str =~ %r{https://}
          parse_url(target_str)
        else
          parse_repository_name(target_str)
        end
      end

      private

      #
      # * GitHub Tree URL
      #   https://github.com/koseki/vagrant-layout/tree/php
      #   https://github.com/koseki/vagrant-layout/tree/e09768d91387ea4465abb8755a3cd2eb011bee9a
      # * GitHub Commit URL
      #   https://github.com/koseki/vagrant-layout/commit/e09768d91387ea4465abb8755a3cd2eb011bee9a
      # * Gist URL
      #   https://gist.github.com/koseki/37f61d9a02b9a48e6651
      #
      def parse_url(url)
        if url =~ %r{\A(https://gist\.github\.com/[^/]+/[0-9a-f]+)/?\z}
          gist_target(Regexp.last_match[1])
        elsif url =~ %r{\Ahttps://github.com/([^/]+)/([^/]+)/(?:tree|commit)/([^/]+)/?\z}
          github_target(Regexp.last_match[1..3])
        else
          msg = 'Invalid target URL. URL must be Gist URL or GitHub tree URL'
          fail ArgumentError, msg
        end
      end

      def parse_repository_name(name)
        target = name.split('/')
        fail ArgumentError, 'Invalid target' if target.any? { |t| t.strip.empty? }

        if target.length == 1
          target = [@default_repository[0], @default_repository[1], target[0]]
        elsif target.length == 2
          target = [target[0], @default_repository[1], target[1]]
        elsif target.length >= 4
          target = target[0..3]
        end
        github_target(target)
      end

      def github_target(target)
        url = "https://github.com/#{ target[0] }/#{ target[1] }/archive/#{ target[2] }.tar.gz"
        @type = :github
        @url = url
      end

      def gist_target(url)
        @type = :gist
        @url = url + '/download'
      end
    end
  end
end
