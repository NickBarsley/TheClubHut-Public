module ClubavatarHelper

  # Return an image tag for the club avatar.
  def clubavatar_tag(club)
    image_tag(club.clubavatar.url, :border => 0, :alt => "Home")
  end
  
  # Return an image tag for the club avatar thumbnail.
  def clubthumbnail_tag(club)
    image_tag(club.clubavatar.thumbnail_url, :border => 0)
  end
end