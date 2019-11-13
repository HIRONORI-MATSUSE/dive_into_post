class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: %i[show edit update destroy]

  def index
    @teams = Team.all
  end

  def show
    @working_team = @team
    change_keep_team(current_user, @team)
  end

  def new
    @team = Team.new
  end

  def edit
    if @team.owner != current_user
        redirect_to@team, notice: '編集できる権限はありません' 
    end
  end

  def create
    @team = Team.new(team_params)
    @team.owner = current_user
    if @team.save
      @team.invite_member(@team.owner)
      redirect_to @team, notice: I18n.t('views.messages.create_team')#チーム作成に成功しました
    else
      flash.now[:error] = I18n.t('views.messages.failed_to_save_team')#保存に失敗しました
      render :new
    end
  end

#TeamのeditはTeamのリーダー（オーナー）のみができるようにすること
  def update
    if @team.update(team_params)
      redirect_to @team, notice: I18n.t('views.messages.update_team')#チーム更新に成功しました
    else
      flash.now[:error] = I18n.t('views.messages.failed_to_save_team')#保存に失敗しました
      render :edit
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_url, notice: I18n.t('views.messages.delete_team')#チーム削除に成功しました
  end

  def dashboard
    @team = current_user.keep_team_id ? Team.find(current_user.keep_team_id) : current_user.teams.first
  end

  private

  def set_team
    @team = Team.friendly.find(params[:id])
  end

  def team_params
    params.fetch(:team, {}).permit %i[name icon icon_cache owner_id keep_team_id]
  end
end
