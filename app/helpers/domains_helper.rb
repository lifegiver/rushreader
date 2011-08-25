module DomainsHelper

# History of changes made by users on specific domain
  def domain_history 
    History.find(:all,   :conditions => { :domain_name => @domain.name } )
  end

end
