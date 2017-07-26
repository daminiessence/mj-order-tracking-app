class AgentVerificationsController < ApplicationController

  add_breadcrumb "users", :users_path
  before_action :add_user_breadcrumb, only: [ :index, :edit ]

  def index
    agents_regex = "\\\A" + current_user.agent_id.gsub(".", '\\.') + "\\\.(0|[1-9][0-9]*)\\\Z"
    @unverified_agents = User.where('agent_id ~ ?', agents_regex).where(verified_agent: false)
    add_breadcrumb "pending", user_agent_verifications_path(current_user.id)
  end

  def update
    @agent = User.find_by(id: params[:id])
    if @agent.verify
      flash[:success] = "TODO: ok, verified"
      redirect_to user_agent_verifications_path(current_user)
    else
      flash[:danger] = "TODO: something went wrong with verification"
      redirect_to user_agent_verifications_path(current_user)
    end
  end

  private

    def add_user_breadcrumb
      add_breadcrumb current_user.first_name.downcase, user_path(current_user)
    end

end
