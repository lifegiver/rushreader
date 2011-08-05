class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.json

  before_filter :authenticate, :only => [:index, :new, :create, :edit,
                                         :update, :archive, :show]
  before_filter :correct_user, :only => [:show, :destroy]

  def index
    articles_quantity = APP_CONFIG['articles_quantity']
    @readed_articles_today = current_user.articles.where(:read => true, :updated_at => user_time.midnight .. (user_time.midnight + 1.day))
    @articles = current_user.articles.where(:read => false)

    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end

  def archive
    @articles = current_user.articles.where(:read => true)
    #@articles = current_user.articles.where(:updated_at =>  (Time.now.midnight - 1.day).. Time.now.midnight, :read => true)
    respond_to do |format|
      format.js
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    require 'open-uri'
    last_article = last_read_article
    @article = Article.find(params[:id])
    if last_article.nil? || (!last_article.nil? && time_from_last_reading > current_user.setting.interval_between_readings.minutes) || @article.read?
      @article.read = true
  #    logger.info "========================="
  #    logger.info "Is it read? => #{@article.read}"
  #    logger.info "========================="

      url = Nokogiri::HTML(open(@article.link,'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_2) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30'))
      url.encoding = 'UTF-8'
      if (@article.domain.rule != nil)
        @result = url.at_css(@article.domain.rule).children
      else
        @result = "No data"
        flash[:notice] = "No damqin!"
      end

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @article }
      end
      @article.save
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
      @article = Article.new(params[:article])
      @article.user = current_user
      get_article_title(@article)
#      logger.info "========================="
#      logger.info "Is it read? => #{@article.read}"
#      logger.info "========================="
      respond_to do |format|
        if @article.save
          #format.html { redirect_to @article, notice: 'Article was successfully created.' }
          format.html { redirect_to articles_url }
          format.js
        else
          format.html { render action: "new" }
          format.json { render json: @article.errors, status: :unprocessable_entity }
        end
      end
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
    article_obj.title = result
    #article_obj.update_attributes(params[:article])
  end

   private

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @article = Article.find(params[:id])
      user = @article.user
      redirect_to root_path unless current_user == user
    end
end
