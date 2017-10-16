class UserMailer < ActionMailer::Base
  
  def reminder(user, newpassword)
    @subject      = 'Your Login Information for TheClubHut.com'
    @body         = {}
    # Give body access to the user information.
    @body["user"] = user
    @body["newpassword"] = newpassword
    @recipients   = user.email
    @from         = 'TheClubHut.com <do-not-reply@TheClubHut.com>'
  end
  
  def invitation(user, newpassword, club, inviter)
    @subject      = 'You have been invited to join ' + club + ' at TheClubHut.com'
    @body         = {}
    # Give body access to the user information.
    @body["user"] = user
    @body["newpassword"] = newpassword
    @body["club"] = club
    @body["inviter"] = inviter
    @recipients   = user.email
    @from         = 'TheClubHut.com <do-not-reply@TheClubHut.com>'  
  end
  
  def membershiprequest(requester, user, membershiptype, club)
    @subject      = requester.full_name + ' has requested ' + club.name + ' membership.'
    @body         = {}
    # Give body access to the user information.
    @body["user"] = user
    @body["club"] = club
    @body["requester"] = requester
    @body["membershiptype"] = membershiptype
    @recipients   = user.email
    @from         = 'TheClubHut.com <do-not-reply@TheClubHut.com>'  
  end
  
  def teamemail(user, sender, team, emailbody, emailsubject, numrecipients)
    @subject      = emailsubject
    @body         = {}
    # Give body access to the user information.
    @body["user"] = user
    @body["emailbody"] = emailbody
    @body["sender"] = sender
    @body["team"] = team
    @body["numrecipients"] = numrecipients
    @recipients   = user.email
    @from         = sender.full_name + '<' + sender.email + '>'
  end

  def clubemail(user, club, sender, emailbody, emailsubject)
    @subject      = emailsubject
    @body         = {}
    # Give body access to the user information.
    @body["user"] = user
    @body["emailbody"] = emailbody
    @body["club"] = club
    @body["sender"] = sender
    @recipients   = user.email
    @from         = sender.full_name + '<' + sender.email + '>'
  end

  def clubnewsemail(user, club, sender, emailbody, emailsubject)
    @subject      = emailsubject
    @body         = {}
    # Give body access to the user information.
    @body["user"] = user
    @body["emailbody"] = emailbody
    @body["club"] = club
    @body["sender"] = sender
    @recipients   = user.email
    @from         = sender.full_name + '<' + sender.email + '>'
  end
  
  def message(mail)
    subject     mail[:message].subject
    from        'RailsSpace <do-not-reply@railsspace.com>'
    recipients  mail[:recipient].email
    body        mail
  end

  def friend_request(mail)
    subject     'New friend request at RailsSpace.com'
    from        'RailsSpace <do-not-reply@railsspace.com>'
    recipients  mail[:friend].email
    body        mail
  end

end