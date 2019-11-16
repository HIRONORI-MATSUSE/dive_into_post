class AgendaDestroyMailer < ApplicationMailer
  def agenda_destroy_mail(member, agenda)
    @member = member
    @agenda = agenda.title
    mail to: @member.email, subject: "アジェンダ削除メール"
  end
end
