module DomainsHelper

# History of changes made by users on specific domain
  def domain_history 
    History.find(:all,   :conditions => { :domain_name => @domain.name } )
  end

  def last_rule(domain)
    History.where(:domain_name => domain.name).order("updated_at DESC").first
  end

end
