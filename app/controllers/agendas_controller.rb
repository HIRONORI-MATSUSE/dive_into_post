class AgendasController < ApplicationController
  before_action :set_agenda, only: %i( destroy)

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: I18n.t('views.messages.create_agenda') 
    else
      render :new
    end
  end

  def destroy
    #アジェンダをとくてい
    #メンバーを定義
    #アジェンダとアーティクルを削除
    #メンバー全員に　メールを通知
    #削除できれば、　削除できたと表示
    #削除できなければ　削除出来ないと表示    
      # @agenda = Agenda.find(params[id])
      @team = Team.find(params[:team])
    if @agenda.destroy
      @team.members.each do |member|
        AgendaDestroyMailer.agenda_destroy_mail(member, @agenda).deliver
      end
      redirect_to dashboard_path, notice: 'アジェンダ削除に成功しました'
    else
      redirect_to dashboard_path, notice: '削除に失敗しました。'
    end
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end
end
