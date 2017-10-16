module TrainingsessionsHelper

  def add_forminterval_link(name)
    link_to_remote interval.rjs
     #name do |page|
    #  #page << "var randomnumber=10000;"
    #  page.insert_html :bottom, :intervals, :partial => 'forminterval', :object => Interval.new
    #end
  end



end
