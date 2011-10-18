# encoding: utf-8
#--
#   Copyright (C) 2009 Nokia Corporation and/or its subsidiary(-ies)
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Affero General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Affero General Public License for more details.
#
#   You should have received a copy of the GNU Affero General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++
class Admin::OauthSettingsController < ApplicationController
  before_filter :login_required
  before_filter :require_site_admin
  before_filter :find_project

  def show
    redirect_to :action => 'edit', :project_id => @project.to_param  
  end
  
  def edit
    @root = Breadcrumb::EditOAuthSettings.new(@project)
  end

  def update
    @project.oauth_settings = params[:oauth_settings]
    @project.save
    flash[:notice] = "OAuth settings were updated"
    redirect_to :action => 'edit', :project_id => @project.to_param
  end

  private
    def require_site_admin
      unless current_user.site_admin?
        flash[:error] = I18n.t "admin.users_controller.check_admin"
        redirect_to root_path
      end
    end
end
