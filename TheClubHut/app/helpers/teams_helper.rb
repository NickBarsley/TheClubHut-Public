module TeamsHelper
  
  def sumdigits(str)
    sum = 0
    for i in 0..str.length-1
      sum += str[i, 1].to_i
    end
  
    if sum.to_s.length > 1
      sumdigits(sum.to_s)
    else
      return sum
    end
  end

  
  def add_formteammember_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, :teammembers, :partial => 'teams/formteammember', :object => Teammember.new
    end
  end






end
