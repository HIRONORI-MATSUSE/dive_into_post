class NewOwnerMailer < ApplicationMailer
  def new_owner_mail(email, team)
    @email = email
    @team = team
    mail to: @email, subject: "新しいオーナーの確認メール"
  end
end
