module Jekyll
  class UserGuideFor < Liquid::For
    def render(context)
      sort_by = @attributes['sort_by']
      subcategory = @attributes['subcategory']

      sorted_collection = context[@collection_name].dup
      sorted_collection = sorted_collection.sort_by { |i| (i && i.to_liquid[@attributes['sort_by']]) || 0 }
 
      new_collection = []
      sorted_collection.each do |item|
        if item.data['category'] == "guide" and          # Match guide
           item.data['subcategory'] == subcategory and   # Match the given subcategory
           context['page']['url'].start_with?(item.dir)  # Make sure it's in the same directory
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

  class Page
    def version
      return "1.0"
    end
  end
end
 
Liquid::Template.register_tag('userguide_for', Jekyll::UserGuideFor)