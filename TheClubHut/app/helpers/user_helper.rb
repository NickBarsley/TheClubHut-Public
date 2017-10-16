module UserHelper

def renderTopLogInForm
# This form is displayed when the user is not logged on, and its not the login or register page.
  if (controller.controller_name == "user" and (controller.action_name == "login" or controller.action_name == "register")) or (controller.controller_name == "email" and controller.action_name == "remind")
    # User is currently on the login or register page. Don't display the top.
  else
    # Return the HTML for the top login form.
    @html = "<form action=\"/user/login\" method=\"post\" style=\"margin:0;padding:0;display:inline\">
              <input id=\"user_email\" maxlength=\"70\" name=\"user[email]\" size=\"30\" type=\"text\" value=\"Email Address\" onfocus=\"if (this.value=='Email Address') {this.value = '';}\" onblur=\"if(this.value=='') {this.value = 'Email Address';}\" />
              <input id=\"user_password\" maxlength=\"50\" name=\"user[password]\" size=\"20\" type=\"password\" value=\"password\" onfocus=\"if (this.value=='password') {this.value = '';}\" onblur=\"if(this.value=='') {this.value = 'password';}\" />
              Remember Me? <input id=\"user_remember_me\" name=\"user[remember_me]\" type=\"checkbox\" value=\"1\" CHECKED/><input name=\"user[remember_me]\" type=\"hidden\" value=\"0\" />
              <input class=\"submit\" name=\"commit\" type=\"submit\" value=\"Log In\" />
            </form>"
  end
  return @html
end


end
