# RVM

$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
set :rvm_ruby_string, 'default'
set :rvm_type, :user

# Bundler

require "bundler/capistrano"

# General

set :application, "rails_projects/rushreader"
set :user, "dorian"

set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :copy

set :use_sudo, false

# Git

#set :scm, :git
#set :repository,  "~/#{application}/.git"
#set :branch, "master"
default_run_options[:pty] = true  # Must be set for the password prompt from git to work
set :repository, "git@github.com:lifegiver/rushreader.git"  # Your clone URL
set :scm, "git"
set :user, "dorian"  # The server's user for deploys
set :scm_passphrase, "spike1880"  # The deploy user's password
ssh_options[:forward_agent] = true
set :branch, "master"
set :deploy_via, :remote_cache

# VPS

role :web, "178.79.173.254"
role :app, "178.79.173.254"
role :db,  "178.79.173.254", :primary => true
role :db,  "178.79.173.254"

# Passenger

namespace :deploy do
 task :start do ; end
 task :stop do ; end
 task :restart, :roles => :app, :except => { :no_release => true } do
   run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
 end
end

desc "Reload Nginx"
task :reload_nginx do
  sudo "/etc/init.d/nginx reload"
end

namespace :deploy do
  desc "Symlinks the database.yml"
  task :symlink_db, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{deploy_to}/shared/lib/popular_articles.yml #{release_path}/lib/popular_articles.yml"
  end
end

namespace :deploy do
  desc "Symlinks the popular_articles.yml"
  task :symlink_popart, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/lib/popular_articles.yml #{deploy_to}/current/lib/popular_articles.yml"
  end
end

after "deploy", "reload_nginx"
after 'deploy:update_code', 'deploy:symlink_db'
after 'deploy:start', 'deploy:symlink_popart'
