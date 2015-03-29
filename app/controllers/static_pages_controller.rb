class StaticPagesController < ApplicationController

  def home
    @flag = 'home'
    render 'events/index'
  end

  def help
    @flag = 'help'
    render_site_info
  end

  def about
    @flag = 'about'
    render_site_info
  end

  def contact
    @flag = 'contact'
    render_site_info
  end

  def roadmap
    @flag = 'roadmap'
    render_site_info
  end

    private
    def render_site_info
      render 'static_pages/site_info'
    end

end
