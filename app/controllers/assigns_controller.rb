class AssignsController < ApplicationController
  before_action :authenticate_user!
  #認証されたユーザー


  #チームメンバーを招待する
  def create
    #入力したアドレスをもとに招待したいユーザを探す
    team = Team.friendly.find(params[:team_id])#チームメンバー
    user = email_reliable?(assign_params) ? User.find_or_create_by_email(assign_params) : nil　#アサインしている人
    if user
      team.invite_member(user)
      redirect_to team_url(team), notice: I18n.t('views.messages.assigned')#アサインしました
    else
      redirect_to team_url(team), notice: I18n.t('views.messages.failed_to_assign')#アサインに失敗しました
    end
  end
#リーダー権限持っている人とログインしているひとの場合はチーム離脱ができる。チームメンバーを離脱出来ない
#Teamに所属しているUserの削除（離脱）は、そのTeamのオーナーか、そのUser自身しかできないようにすること

  def destroy
    assign = Assign.find(params[:id])
    destroy_message = assign_destroy(assign, assign.user)
    redirect_to team_url(params[:team_id]), notice: destroy_message
  end

  private

  def assign_params
    params[:email]
  end


  #destroyするときのメッセージ
  def assign_destroy(assign, assigned_user)
    #アサインしている人がリーダ−のとき
    if assigned_user == assign.team.owner
      I18n.t('views.messages.cannot_delete_the_leader')#リーダーは削除出来ません
    #所属している人が一人の場合、
    elsif Assign.where(user_id: assigned_user.id).count == 1
      I18n.t('views.messages.cannot_delete_only_a_member')#このユーザーはこのチームにしか所属していないため、削除できません
      #削除するとき
    elsif assign.team.owner != current_user || current_user != assigned_userd
        '削除できる権限はありません'  
    elsif assign.destroy
      set_next_team(assign, assigned_user)
      I18n.t('views.messages.delete_member')#メンバーを削除しました
    else
      I18n.t('views.messages.cannot_delete_member_4_some_reason')#なんらかの原因で、削除できませんでした
    end
  end
  
  def email_reliable?(address)
    address.match(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
  end
  
  def set_next_team(assign, assigned_user)
    another_team = Assign.find_by(user_id: assigned_user.id).team
    change_keep_team(assigned_user, another_team) if assigned_user.keep_team_id == assign.team_id
  end
end
