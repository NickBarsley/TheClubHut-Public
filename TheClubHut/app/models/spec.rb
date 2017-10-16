class Spec < ActiveRecord::Base
  belongs_to :user
  #acts_as_ferret
  
  ALL_FIELDS = %w(gender birthdate occupation city county 
                  country phone_mobile phone_landline display_to)
                  
  STRING_FIELDS = %w(gender occupation city county 
                  country  )
  VALID_GENDERS = ["Male", "Female", ""]
  START_YEAR = 1900
  VALID_DATES = DateTime.new(START_YEAR)..DateTime.now
  _LENGTH = 5
    
  validates_length_of STRING_FIELDS, 
                      :maximum => DB_STRING_MAX_LENGTH
  
  validates_inclusion_of :gender, 
                         :in => VALID_GENDERS,
                         :allow_nil => true,
                         :message => "must be male or female"
  
  validates_inclusion_of :birthdate, 
                         :in => VALID_DATES,
                         :allow_nil => true,
                         :message => "is invalid"

 
#  validates_format_of :, :with => [A-Z]{1,2}[0-9R][0-9A-Z]? [0-9][A-Z-[CIKMOV]]{2},
 #                     :message => "must be a valid UK "

  # Return a sensibly formatted location string
  def location
    [city, state, ].join(" ")
  end

  # Return the age using the birthdate.
  def age
    return if birthdate.nil?
    today = Date.today
    if (today.month > birthdate.month) or 
       (today.month == birthdate.month and today.day >= birthdate.day)
      # Birthday has happened already this year.
      today.year - birthdate.year
    else
      today.year - birthdate.year - 1
    end
  end

  def gender_privacy_public
    gender_privacy.to_s[0,1]
  end
  def gender_privacy_sipbib
    gender_privacy.to_s[1,1]
  end
  def gender_privacy_clubmembers
    gender_privacy.to_s[2,1]
  end
  def gender_privacy_clubcommittee
    gender_privacy.to_s[3,1]
  end
  def gender_privacy_teammates
    gender_privacy.to_s[4,1]
  end
  

end
