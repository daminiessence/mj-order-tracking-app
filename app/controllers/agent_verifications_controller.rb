class AgentVerificationsController < ApplicationController

  add_breadcrumb "agent verifications", :user_agent_verifications_path

  def index
    agents_rg = "\\\A" + current_user.agent_id.gsub(".", '\\.') + "\\\.(0|[1-9][0-9]*)\\\Z"
    @agents = User.where('agent_id ~ ?', agents_rg)
  end

  def update
  end

end
