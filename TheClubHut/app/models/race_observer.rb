class RaceObserver < ActiveRecord::Observer

def after_update(race)
  text=html2text(race.report)
  data = {  "club_id" => race.team.club_id, 
                      "user_id" => race.user_id,
                      "team_id" => race.team_id,
                      "event_id" => race.event_id,
                      "title" => race.result,
                      "body" => text[0,50] + "...",
                      "event_type" => "Race" }
  @whatson = Whatshappening.new(data)
  @whatson.save
end

def after_create(race)
	if race.event.ind_or_team == "Team"
	  data = {  "club_id" => race.team.club_id, 
	                      "user_id" => race.user_id,
	                      "team_id" => race.team_id,
	                      "event_id" => race.event_id,
	                      "title" => "",
	                      "body" => "",
	                      "event_type" => "Entry" }
	  @whatson = Whatshappening.new(data)
	  @whatson.save
	end
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
