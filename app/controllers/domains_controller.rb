class DomainsController < ApplicationController
  # GET /domains
  # GET /domains.json
  
  before_filter :admin_user, :only => [:destroy, :new, :create] 

  def history
    @domain = Domain.find(params[:id])
    @rule = Rule.find(params[:rule_id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @domain }
    end
  end

  def load_from_history
    @domain = Domain.find(params[:id])
    @domain.update_attributes(:custom_css => params[:custom_css], :rule => params[:rule])
    redirect_to edit_domain_path
  end

  def index
    @domains = Domain.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @domains }
    end
  end

  # GET /domains/1
  # GET /domains/1.json
  def show
    @domain = Domain.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @domain }
    end
  end

  # GET /domains/new
  # GET /domains/new.json
  def new
    @domain = Domain.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @domain }
    end
  end

  # GET /domains/1/edit
  def edit
    @domain = Domain.find(params[:id])
  end

  # POST /domains
  # POST /domains.json
  def create
    @domain = Domain.new(params[:domain])
#    domain_regex = /[a-z0-9]*\.[a-z0-9]*/
#    @domain.name = @domain.name.match(domain_regex)[0] 
    respond_to do |format|
      if @domain.save
        format.html { redirect_to @domain, notice: 'Domain was successfully created.' }
        format.json { render json: @domain, status: :created, location: @domain }
      else
        format.html { render action: "new" }
        format.json { render json: @domain.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /domains/1
  # PUT /domains/1.json
  def update
    @domain = Domain.find(params[:id])
    respond_to do |format|
      if @domain.update_attributes(params[:domain])
        format.html { redirect_to @domain, notice: 'Domain was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @domain.errors, status: :unprocessable_entity }
      end
    new_rule = Rule.new(:custom_css => @domain.custom_css, :domain_name => @domain.name, :user_id => current_user.id, :user_name => current_user.email, :rule => @domain.rule, :domain_id => @domain.id)
    new_rule.save
    end
  end

  # DELETE /domains/1
  # DELETE /domains/1.json
  def destroy
    @domain = Domain.find(params[:id])
    @domain.destroy

    respond_to do |format|
      format.html { redirect_to domains_url }
      format.json { head :ok }
    end
  end
end
