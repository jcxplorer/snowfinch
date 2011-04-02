module ApplicationHelper

  def navigation(&block)
    content_tag(:nav) do
      content_tag(:ul, &block)
    end
  end

  def navigate_to(identifier, body, url, html_options={})
    classes = html_options[:class] || []
    classes = classes.split(" ") unless classes.is_a?(Array)
    classes << "active" if @navigation_id == identifier
    classes.uniq!
    html_options[:class] = classes.empty? ? nil : classes

    content_tag(:li) do
      link_to(body, url, html_options)
    end
  end

  def header(heading=nil, &block)
    content_for(:header) do
      content_tag(:header) do
        if block_given? && heading
          content_tag(:h1, heading) + content_tag(:span, &block)
        elsif block_given?
          block.call
        elsif heading
          content_tag(:h1, heading)
        end
      end
    end
  end

  def body_id
    "#{controller_name}_#{action_name}"
  end

end
