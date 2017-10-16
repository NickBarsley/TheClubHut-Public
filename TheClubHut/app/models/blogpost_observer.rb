class BlogpostObserver < ActiveRecord::Observer

  def after_create(blogpost)
    text=html2text(blogpost.body)
    data = {  "club_id" => blogpost.blog.club_id, 
              "blogpost_id" => blogpost.id,
              "user_id" => blogpost.user_id,
              "title" => blogpost.title[0, 25],
              "body" => text[0,50] + "...",
              "event_type" => "News" }
    @whatson = Whatshappening.new(data)
    @whatson.save
  end

  def after_update(blogpost)
  end

  def html2text(html)
    text = html.
    gsub(/(&nbsp;|\n|\s)+/im, ' ').squeeze(' ').strip.
    gsub(/<([^\s]+)[^>]*(src|href)=\s*(.?)([^>\s]*)\3[^>]*>\4<\/\1>/i, '\4')
    links = []
    linkregex = /<[^>]*(src|href)=\s*(.?)([^>\s]*)\2[^>]*>\s*/i
    while linkregex.match(text)
      links << $~[3]
      text.sub!(linkregex, "[#{links.size}]")
    end
  
    text = CGI.unescapeHTML(
      text.
        gsub(/<(script|style)[^>]*>.*<\/\1>/im, '').
        gsub(/<!--.*-->/m, '').
        gsub(/<hr(| [^>]*)>/i, "___\n").
        gsub(/<li(| [^>]*)>/i, "\n* ").
        gsub(/<blockquote(| [^>]*)>/i, '> ').
        gsub(/<(br)(| [^>]*)>/i, "\n").
        gsub(/<(\/h[\d]+|p)(| [^>]*)>/i, "\n\n").
        gsub(/<[^>]*>/, '')
    ).lstrip.gsub(/\n[ ]+/, "\n") + "\n"
  
    for i in (0...links.size).to_a
      text = text + "\n  [#{i+1}] <#{CGI.unescapeHTML(links[i])}>" unless
      links[i].nil?
    end
    
    links = nil
    text
  end

end
