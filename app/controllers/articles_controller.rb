class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.json
  def index
    @user = current_user
    if params[:day] == "tomorrow"
      @articles = @user.articles.where(:created_at => Time.now.midnight + 1.day.. (Time.now.midnight + 2.day))
    elsif params[:day] == "yesterday"
      @articles = @user.articles.where(:created_at =>  (Time.now.midnight - 1.day).. Time.now.midnight)
    else
      @articles = @user.articles.where(:created_at => Time.now.midnight .. (Time.now.midnight + 1.day))
    end

    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end

  def yesterday
    @user = current_user
    @articles = @user.articles.where(:created_at =>  (Time.now.midnight - 1.day).. Time.now.midnight)

    respond_to do |format|
      format.js
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @article = Article.find(params[:id])
    @article.read = true
#    logger.info "========================="
#    logger.info "Is it read? => #{@article.read}"
#    logger.info "========================="

    #url = Nokogiri::HTML(open(@article.link,'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_2) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30'))
    #@result = url.at('/html/body/div[2]/div/div/div[3]/div').to_html

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end
    @article.save
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

end
