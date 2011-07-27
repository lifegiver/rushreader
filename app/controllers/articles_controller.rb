class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.json

  def index
    articles_quantity = APP_CONFIG['articles_quantity']
    @articles = current_user.articles.limit(articles_quantity[current_user.setting.articles_quantity])

    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end

  def archive
    @articles = current_user.articles.where(:updated_at =>  (Time.now.midnight - 1.day).. Time.now.midnight)
    respond_to do |format|
      format.js
    end
  end

  def next
    @articles = current_user.articles.where(:updated_at => Time.now.midnight + 1.day.. (Time.now.midnight + 2.day))
    respond_to do |format|
      format.js
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    require 'open-uri'
    @article = Article.find(params[:id])
    @article.read = true
#    logger.info "========================="
#    logger.info "Is it read? => #{@article.read}"
#    logger.info "========================="

    url = Nokogiri::HTML(open(@article.link,'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_2) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30'))
    url.encoding = 'UTF-8'
    css_arr = ["html body#main-page.blogs div#wrapper div#inner div#main-content div.hentry div.content", "html body.mediawiki div#content div#bodyContent", "html body.single div.page-container div#page_content.clearfix div#primary.grid_4 article#post-690343.post div.description", "html body#techcrunch.single div#page-container div.column-container div.left-container div#module-post-detail.module-post-detail div.body-copy", "html body.home div.content_holder div.inner-padding div.col1 div.blogroll div.post_content div.post_body", "html body div#doc4.yui-t6 div#bd div#yui-main div.yui-b div.content div.sl-layout-post div#content.content div.small div.KonaBody", "html body div#container div#main article.economy div.post"]
    css_arr.each do |item|
      logger.info "########################"
      logger.info item
      logger.info "########################"
      if (url.at_css(item))
        @result = url.at_css(item).children
        break
      else
        @result = "No data";
      end
    end

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
