class NewOwnerMailer < ApplicationMailer
  def new_owner_mail(team)
    @team = team

    mail to: "自分のメールアドレス", subject: "新しいオーナーの確認メール"
  end
end
