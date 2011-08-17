class ArticlesController < ApplicationController
  before_filter :authenticate, :only => [:index, :new, :create, :edit, :update, :archive, :show]
  before_filter :correct_user, :only => [:destroy]
  layout :layout_by_method

  def index
    articles_quantity = APP_CONFIG['articles_quantity']
    readed_articles = %(SELECT article_id FROM user_articles WHERE user_id = (#{current_user.id}) AND read = 1)
    @readed_articles_today = current_user.articles.where("article_id IN (#{readed_articles})",
                            :updated_at => user_time.midnight .. (user_time.midnight + 1.day))
    @articles = current_user.articles.where("article_id NOT IN (#{readed_articles})")
    #@readed_articles_today = current_user.articles.where(:read => true, :updated_at => user_time.midnight .. (user_time.midnight + 1.day))
    #@articles = current_user.articles.where(:read => false)

    if !last_read_article.nil?
      timer_all_time = last_read_time
      @timer_minutes = timer_all_time / 60
      @timer_seconds = timer_all_time-(((timer_all_time)/ 60) * 60)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    require 'open-uri'
    last_article = last_read_article
    @article = Article.find(params[:id])
    user_article = UserArticle.find(:first, :limit => 1,
                                    :conditions => { :user_id => current_user.id,
                                    :article_id => @article.id })
    if last_article.nil? || (!last_article.nil? && time_from_last_reading > current_user.setting.interval_between_readings.minutes) || user_article.read?
      user_article.read = true
  #    logger.info "========================="
  #    logger.info "Is it read? => #{@article.read}"
  #    logger.info "========================="

      if (@article.domain.rule.nil?)
        @result = "empty"
      else
        url = Nokogiri::HTML(open(@article.link,'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_2) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30'))
        url.encoding = 'UTF-8'
        @result = url.at_css(@article.domain.rule).children
      end

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @article }
      end
      user_article.save
    else
      #visit_in = current_user.setting.interval_between_readings.minutes - time_from_last_reading
      #"Wait for #{(visit_in / 1.minutes).floor} minutes"
      redirect_to articles_path, :notice => "You are not allowed to read this article yet."
    end
  end

  # GET /articles/new
  # GET /articles/new.json
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  # POST /articles.json
  def create
    exist_article = Article.find_by_link(params[:article][:link])
    if exist_article.nil?
      @article = Article.new(params[:article])
      get_article_title(@article)
      respond_to do |format|
        if @article.save
          #format.html { redirect_to @article, notice: 'Article was successfully created.' }
          format.html { redirect_to articles_url }
          format.js
        else
          format.html { render action: "new" }
          format.json { render json: @article.errors, status: :unprocessable_entity }
        end
        new_article_record = UserArticle.create(:user_id => current_user.id,
                                            :article_id => @article.id, :read => false)
      end
    else
     # if read?(exist_article)
      #  read = true
     # else
     #   read = false
     # end
      new_article_record = UserArticle.create(:user_id => current_user.id,
                                               :article_id => exist_article.id,
                                               :read => read?(exist_article))
    end
    new_article_record.save
  end



  # PUT /articles/1
  # PUT /articles/1.json
  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url }
      format.js
    end
  end

  def get_article_title(article_obj)
    require 'open-uri'
    url = Nokogiri::HTML(open(article_obj.link,'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_2) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30'))
    result = url.xpath('/html/head/title').text
    if result.blank?
      article_obj.title = article_obj.link
    else
      article_obj.title = result
    end
    #article_obj.update_attributes(params[:article])
  end

  private

    def layout_by_method
      if params[:action] == "show"
        "show"
      else
        "application"
      end
    end

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @article = Article.find(params[:id])
      user = @article.user
      redirect_to root_path unless current_user == user
    end
end
