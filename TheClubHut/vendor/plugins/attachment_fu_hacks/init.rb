# Include hook code here
klass = Numeric
klass.class_eval do
  def to_human
    units = %w{B KB MB GB TB}
    e = (Math.log(self)/Math.log(1024)).floor
    s = "%.1f" % (to_f / 1024**e)
    s.sub(/\.?0*$/, ' ' + units[e])
  end
end

klass = Technoweenie::AttachmentFu::InstanceMethods
klass.module_eval do
  
  # overrides attachment_fu.rb:342 b/c to provide better error messages
  def attachment_attributes_valid?
   
    attr_name = :size
    enum = attachment_options[attr_name]
    val = send(attr_name)
    if !enum.nil? && !val.nil? && !enum.include?(val)
      err_msg = enum.end.to_human
      errors.add attr_name, "of file is too big (must be less than #{err_msg})"
    end
    
    attr_name = :content_type
    enum = attachment_options[attr_name]
    val = send(attr_name)
    if !enum.nil? && !val.nil? && !enum.include?(val)
      err_msg = enum.join(', ').gsub(/image\//, '.') unless enum.nil?
      errors.add attr_name, "is not supported (must be #{err_msg})"      
    end
  end
end  

klass = Technoweenie::AttachmentFu::ClassMethods
klass.module_eval do
  # overrides attachment_fu.rb:106 b/c i don't think it's necessary 
  # to evaluate size or content_type if there is no file
  def validates_as_attachment
    validates_presence_of :filename
    validate              :attachment_attributes_valid?
  end  
end