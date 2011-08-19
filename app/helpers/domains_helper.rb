module DomainsHelper

  def domain_history 
    History.find(:all,   :conditions => { :domain_name => @domain.name } )
  end

end
