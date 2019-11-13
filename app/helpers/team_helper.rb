module TeamHelper
  def default_img(image)
    image.presence || 'default.jpg'
  end

  # def 
  #   if current_user.presence?
  #     if  current_user == Team.friendly.find(params[:team_id]).assign.team.owner
  #       retern true
  #     else
  #       retern false
  #     end
  # end

end
