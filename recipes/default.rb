#
# Cookbook Name:: PostgreSQL 9.3.1
# Recipe:: default
#
# Copyright 2013, Eduardo Ximenes Soares
#
# All rights reserved - Do Not Redistribute
#

package "build-essential" do
  action :install
end

package "zlib1g-dev" do
  action :install
end

package "libreadline6-dev" do
  action :install
end

bash "download_install_pg" do
  user "root"
  code <<-EOH
    wget http://ftp.postgresql.org/pub/source/v9.3.1/postgresql-9.3.1.tar.gz -O /opt/postgresql-9.3.1.tar.gz
    tar -zxf /opt/postgresql-9.3.1.tar.gz -C /opt/
    (cd /opt/postgresql-9.3.1/ && ./configure --prefix=/usr/local/pgsql9.3.1 && make && make install)
  EOH
end

cookbook_file "/etc/init.d/postgresql" do
  source "postgresql"
  mode 0544
  owner "root"
  group "root"
end

execute "link_pg" do 
  command "ln -s /usr/local/pgsql9.3.1/ /usr/local/pgsql"
  ignore_failure true
end

execute "start_default_pg" do 
  command "update-rc.d postgresql defaults"
end

directory "/database" do
  owner "postgres"
  group "postgres"
  mode 0755
  action :create
  ignore_failure true
end


execute "add_user_pg" do
 command "useradd postgres --home-dir /database --shell /bin/bash"
 ignore_failure true
end

cookbook_file "/var/lib/locales/supported.d/local" do 
  source "locale-gen"
   mode 0544
  owner "root"
  group "root"
end

execute "locale_gen" do
 command "locale-gen"
end

cookbook_file "/etc/default/locale" do
  source "locale_etc"
  mode 0554
  owner "root"
  group "root"
end 

cookbook_file "/database/.profile" do
  source "profile_pg"
  owner "postgres"
  group "postgres"
  mode 0755
end

directory "/database/data" do
  owner "postgres"
  group "postgres"
  mode 0700
  action :create
end

execute "initdb" do
  command "su postgres -l -c 'initdb'"
  action :run
end


service "postgresql" do
 action :start
end

