class HomeController < ApplicationController
  def index
    if current_user
      redirect_to articles_url
    end
    @articles = Article.all
  end

end
