require 'redcarpet'

module Jekyll
  class UserGuideFor < Liquid::For
    def render(context)
      sort_by = @attributes['sort_by']
      category = @attributes['category']

      sorted_collection = context[@collection_name].dup
      sorted_collection = sorted_collection.sort_by { |i| (i && i.to_liquid[@attributes['sort_by']]) || 0 }
 
      parts = context['page']['url'].split('/')
      page_url = parts[0..2].join('/')

      new_collection = []
      sorted_collection.each do |item|

        if item.data['category'] == category and   # Match the category
           page_url == item.dir                    # Make sure it's in the same directory
          new_collection.push(item)
        else  
        end
      end

      sorted_collection_name = "#{@collection_name}_sorted".sub('.', '_')
      context[sorted_collection_name] = new_collection
      @collection_name = sorted_collection_name
 
      super
    end
 
    def end_tag
      'endsorted_for'
    end
  end

  module Converters
    class APILink < Redcarpet::Render::HTML
      @@NamespacePattern = /noda-ns:\/\/([A-Za-z0-9_.]*)/
      @@TypePattern      = /noda-type:\/\/([A-Za-z0-9_.]*)/
      @@IssueUrlPattern  = /(\[[^\]]*\])\[issue (\d+)\]/
      @@IssueLinkPattern = /\[issue (\d+)\]\[\]/
      @@ApiUrlPrefix     = "../api/html/"

      def preprocess(text)
        text.gsub! @@NamespacePattern, @@ApiUrlPrefix+'\1'
        text.gsub! @@TypePattern, @@ApiUrlPrefix+'\1'
        text.gsub! @@IssueUrlPattern, '\1(http://code.google.com/p/noda-time/issues/detail?id=\2)'
        text.gsub! @@IssueLinkPattern, '[issue \1](http://code.google.com/p/noda-time/issues/detail?id=\1)'
        text
      end

      def postprocess(text)
        text.gsub! /<pre><code>(.*?)<\/code><\/pre>/m, '<div class="example"><pre class="prettyprint code">\1</pre></div>'
        text
      end
    end

    class Markdown < Converter
      def markdown
        @markdown ||= Redcarpet::Markdown.new(APILink.new())
      end

      def convert(content)
        markdown.render(content)
      end
    end
  end
end
 
Liquid::Template.register_tag('userguide_for', Jekyll::UserGuideFor)






