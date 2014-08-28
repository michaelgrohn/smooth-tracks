module ApplicationHelper

  # TODO: Für Gem behalten oder löschen?
  def markdown_renderer
    Redcarpet::Markdown.new( Redcarpet::Render::XHTML.new( with_toc_data: true ),
                             autolink: true,
                             tables: true,
                             strikethrough: true,
                             quote: true,
                             footnotes: true                                        )
  end

  # TODO: Behalten?
  def paragraphs ( n, content )
    Nokogiri::HTML( content ).css( 'p' ).first( n ).map( &:to_s ).join.html_safe
  end

  # TODO: BEhalten? Auslagern????
  def preview ( content, length: 2 )
    paragraphs( length, content )
  end

  # TODO: Behalten?
  def render_markdown( text, linkables: [], assets: [], preview: nil, read_more: '' )
    linkables += LawField.all + Page.all

    link_placeholders   = linkables.map( &:to_s ).map( &:to_sym )
    link_tags           = linkables.map { |linkable| link_to( linkable ) }

    image_placeholders  = assets.map( &:image_file_name ).map( &:to_sym )
    image_tags          = assets.map { |asset| render( asset ) }

    link_substitutions  = link_placeholders.zip( link_tags )
    image_substitutions = image_placeholders.zip( image_tags )
    substitutions       = image_substitutions + link_substitutions

    truncated = false

    if preview
      truncated = text.length >= preview
      text = truncate( text, length: preview, separator: ' ', omission: '…' )
      # remove half cut subtitutions
      text.gsub!( /%{([^}]*)\z/, '\1' )
    end

    begin
      text = "#{text}" % Hash[ substitutions ]
    rescue KeyError
    end

    html = markdown_renderer.render( text ).html_safe
    html += read_more if truncated
    return html 

  end

  # Easyly set the page title from a view.
  #
  # This is merely a convenience wrapper for content_for( :title ) { ... }
  # Remember that you still need to apply the title in layouts/application.rb
  # with %title= yield( :title )
  # 
  # Examples:
  #
  #   - title = "#{@person.name}'s profile"
  #   %h1= @person.name
  #   ...

  def title=( title )
    content_for( :title ) { title }
    page_title
  end

  # Returns an html list, containing the given items.
  # The <li>'s content will be whatever the item's to_s method returns.
  # You can give a block to specify something else to put in for each item.
  # If you want the items to be rendered (i. e. rendering the items partial)
  # you can use #render_list.
  #
  # type - The element to wrap the items with. :ul, :ol, ... (:ul is default).
  # Additional args are passed to the content_tag method that creates the wrapping element.
  #
  # Examples:
  #
  #   .people= list @people
  #   .emails= list @people, &:email
  #   .tweets= list( @tweets ) { |tweet| "#{tweet.author} tweets: #{tweet.content}" }
  #   .nav=    list( @navigation_links, type: :menu )
  #
  # See also #items for a non-wrapped naked list of <li>'s.

  def list ( items, type: :ul, *args )
    non_empty_content_tag( type, *args ) { items( items ) }
  end

  # Returns a set of html <li>'s, containing the given items.
  # The <li>'s content will be whatever the item's to_s method returns.
  # You can give a block to specify something else to put in for each item.
  # If you want the items to be rendered (i. e. rendering the items partial)
  # you can use #render_items.
  #
  # Additional args are passed to the content_tag method that creates the <li>'s.
  #
  # Examples:
  #
  #   %ul.people= items @people
  #   %ol.emails= items @people, &:email
  #   %ol.tweets= items( @tweets ) { |tweet| "#{tweet.author} tweets: #{tweet.content}" }
  #   %nav=       items( @navigation_links )
  #
  # See also #list for a list already wrapped with <ul>, <ol>, ...
  #
  # See also #render_items if 

  def items( items, *args )
    items.map do |item|
      item = yield( item ) if block_given?
      content_tag( :li, item, *args )
    end
    items.join.html_safe
  end

  # Returns an html list, containing the rendered items (i. e. rendering the items partial).
  #
  # type - The element to wrap the items with. :ul, :ol, ... (:ul is default).
  # Additional args are passed to the content_tag method that creates the wrapping element.
  #
  # Examples:
  #
  #   .tweets= render_list( @tweets )
  #   .nav=    render_list( @navigation_links, type: :nav )
  #
  # See also #render_items for a non-wrapped naked list of <li>'s.

  def render_list( items, type: :ul, *args )
    non_empty_content_tag( type, *args ) { render_items( items }
  end

  # Returns a set of html <li>'s, containing the rendered items (i. e. rendering the items partial).
  #
  # Additional args are passed to the content_tag method that creates the <li>'s.
  #
  # Examples:
  #
  #   %ol.tweets= render_items( @tweets )
  #
  # See also #render_items for a non-wrapped naked list of <li>'s.

  def render_items items, *args
    items.map do |item|
      non_empty_content_tag( :li, *args ) { render( item, *args ) }
    end
    items.join.html_safe
  end

  # TODO: Include?

  def render_form_for (object)
    form_for object do |form|
      render partial: "#{object.to_controller_name}/form_fields", locals: { form: form }
    end
  end

  # 
  # 
  # 

  def non_empty_content_tag( *args, &block )
    container = content_tag( *args, &block )
    container unless Nokogiri::HTML( container ).root.content.blank?
  end

  def render_if_present( object )
    render object if object.present?
  end

end
