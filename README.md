jenkins Cookbook
================

 - Author: Eduardo Ximenes Soares <duximenes@gmail.com>
 - Cookbook install and configure: jenkins / jdk / jboss server / monit 
 - Test: chef-solo AMI UBNTU SERVER EC2 and AMI LINUX AMAZON


HowTo
------------------

 - Install GIT client

 - Install chef solo
	- curl -L https://www.opscode.com/chef/install.sh | bash

 - Download and configure CHEF-REPO structure
	- wget http://github.com/opscode/chef-repo/tarball/master
	- tar -zxvf master  
	- mv opscode-chef-repo-ef75514/ /opt/chef-repo
	- mkdir /opt/chef-repo/.chef
 
 - Configre cookbook path (/opt/chef-repo/.chef/knife.rb)
	- Add line
		- cookbook_path [ '/opt/chef-repo/cookbooks' ]
 
 - Configure solo.rb (/opt/chef-repo/solo.rb)
	- Add lines:
		- file_cache_path "/opt/chef-solo"
		- cookbook_path "/opt/chef-repo/cookbooks"

 - Download REPO: 
	- git clone https://github.com/ximenes/jenkins.git -l /opt/chef-repo/cookbooks/jenkins

 - Create your json (/opt/chef-repo/JSON_NAME.json)
	- Add line: 
		-  {   "run_list": [ "recipe[jenkins]" ] } 

 - Execute CHEF-SOLO
	- chef-solo -c /opt/chef-repo/solo.rb -j /opt/chef-repo/JASON_NAME.json


 - Access:
	- http://your_ip:8080/jenkins
