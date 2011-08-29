class ArticlesController < ApplicationController
  before_filter :authenticate, :only => [:index, :new, :create, :edit, :update, :archive, :show]
  before_filter :correct_user, :only => [:destroy]

  layout :layout_by_method

  def index
    articles_quantity = APP_CONFIG['articles_quantity']
    #articles that user have read today
    @readed_articles_today = current_user.user_articles.where(:read => true, :updated_at => user_time.midnight .. (user_time.midnight + 1.day))
    # unread user's articles
    @articles = current_user.user_articles.where(:read => false)
    #time before user can read next article
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
    if user_article.nil? 
      user_article = current_user.user_articles.create(:article_id => @article.id)
      user_article.save
    end
    # User can read article if it is his first article, if time between user can read new articles 
    # has passed(time is an option defined by user) or if user has already read this article
    if last_article.nil? || (!last_article.nil? && time_from_last_reading > current_user.setting.interval_between_readings.minutes) || user_article.read?
      user_article.read = true
      # Each read/viewed article is counted. The most viewed articles for today
      # displayed as current popular articles
      add_view(@article)
      if (@article.domain.rule.nil?)
        @result = "empty"
      else
        url = Nokogiri::HTML(open(@article.link,'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_2) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30'))

        #check if the domain is present in images tags. if not, add the domain
        url.search('img').each do |n|
          if !n['src'].match(/http/)
            n['src'] = "http://" + @article.domain.name + "/" + n['src']
          end
        end

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
    # If current user add an article that already exist (added by other user), it is only created
    # a record that connects current user to added article in user_articles.    
    exist_article = Article.find_by_link(params[:article][:link])
    if !exist_article.nil?
      @article = current_user.user_articles.create(:article_id => exist_article.id)
    else # Article do not exist
      @article = current_user.articles.create(params[:article])
      get_article_title(@article)
    end
    respond_to do |format|
      if @article.save
        format.html { redirect_to articles_url }
        format.js
      else
        format.html { render action: "new" }
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

# Each article displayed as its title on original site or its link (if title is absent)
  def get_article_title(article_obj)
    require 'open-uri'
    # If article url doesn't contain "http://" its added for
    # properly defining of article title
    if (article_obj.link =~ /http:\/\//).nil?
      article_obj.link = "http://" + article_obj.link
    end
    url = Nokogiri::HTML(open(article_obj.link,'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_2) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30'))
    result = url.xpath('/html/head/title').text
    if result.blank?
      article_obj.title = article_obj.link
    else
      article_obj.title = result
    end
    #article_obj.update_attributes(params[:article])
  end

# Popular articles are the most read articles for today
  def popular_articles
    popart_ids = PopularArticle.find(:all, :order => "views DESC", :limit => 5, :conditions => {:created_at => Time.now.midnight .. (Time.now.midnight + 1.day)}).map{|art| art.article_id}
    File.open('lib/popular_articles.yml', 'w') do |f|
      f.puts popart_ids.to_yaml
    end
    redirect_to articles_path
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

# Information about views of every day stores in popular_articles. If this article is read for first
# time ever or for first time of current day it has 1 view. In other case 1 view is added to current 
# quantity of views 
  def add_view(article)
    popular_article = PopularArticle.find(:last, :conditions => {:article_id => article.id})
    if !popular_article.nil? && popular_article.created_at > 1.day.ago
      popular_article.update_attributes(:views => popular_article.views + 1)
    else
      PopularArticle.create(:article_id => article.id, :views => 1).save
    end
  end

end
