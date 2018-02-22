# aws-ecs-ami
# Current Versions
--> AWS AMI Builder - Ubuntu: AMIs were created:
ap-south-1: ami-e66e3e89
ap-southeast-1: ami-2e89cc52
ap-southeast-2: ami-a3768fc1
eu-west-1: ami-1d2b4964
eu-west-2: ami-64dbc100
us-east-1: ami-08360c72
us-west-2: ami-ba8830c2


running the CIS script on ec2-machine

`git clone https://github.com/AdityaJangid/CIS-on-ubuntu-16.04.git`

`cd CIS-on-ubuntu-16.04`

`cd scripts`

`chmod u+x ansible.sh tune.sh`

`sudo ./ansible.sh`

`sudo ./tune.sh`

`cd ../ansible`

`ansible-playbook playbook.yaml`


## To run on vagrant

`git clone https://github.com/AdityaJangid/CIS-on-ubuntu-16.04.git`

`cd CIS-on-ubuntu-16.04`

`cd ansible/roles/common`

`vagrant up`
