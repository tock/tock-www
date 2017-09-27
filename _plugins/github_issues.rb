require "jekyll"
require "html/pipeline"
require 'html/pipeline/hashtag/hashtag_filter'

module Jekyll
  class Issues
    ISSUE_PREFIX_URL = "https://github.com/helena-project/tock/issues/%{tag}".freeze
    BODY_START_TAG = "<body".freeze

    InvalidJekyllMentionConfig = Class.new(Jekyll::Errors::FatalException)

    class << self
      def issuify(doc)
        return unless doc.output.include?("@")
        src = ISSUE_PREFIX_URL
        if doc.output.include? BODY_START_TAG
          parsed_doc    = Nokogiri::HTML::Document.parse(doc.output)
          body          = parsed_doc.at_css("body")
          body.children = filter_with_mention(src).call(body.inner_html)[:output].to_s
          doc.output    = parsed_doc.to_html
        else
          doc.output = filter_with_mention(src).call(doc.output)[:output].to_s
        end
      end

      # Public: Create or fetch the filter for the given {{src}} base URL.
      #
      # src - the base URL (e.g. https://github.com)
      #
      # Returns an HTML::Pipeline instance for the given base URL.
      def filter_with_mention(src)
        filters[src] ||= HTML::Pipeline.new([
          HTML::Pipeline::HashtagFilter,
        ], { :tag_url => src })
      end

      # Public: Filters hash where the key is the mention base URL.
      # Effectively a cache.
      def filters
        @filters ||= {}
      end

      # Public: Defines the conditions for a document to be emojiable.
      #
      # doc - the Jekyll::Document or Jekyll::Page
      #
      # Returns true if the doc is written & is HTML.
      def issueable?(doc)
        (doc.is_a?(Jekyll::Page) || doc.write?) &&
          doc.output_ext == ".html" || (doc.permalink && doc.permalink.end_with?("/"))
      end
    end
  end
end

Jekyll::Hooks.register %i[pages documents], :post_render do |doc|
  Jekyll::Issues.issuify(doc) if Jekyll::Issues.issueable?(doc)
end
