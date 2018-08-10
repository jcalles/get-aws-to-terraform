#!/bin/bash
## support to getsession.sh 

set -ex
export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
export AWS_REGION=${AWS_DEFAULT_REGION}

export AWS_PROFILE=${AWS_PROFILE}
export AWS_ROLE=${AWS_ROLE}

if [ -z "${AWS_ROLE}" ] || [ -z "${AWS_PROFILE}" ]
then
echo "ROLE or PROFILE does not exist!"
fi

if !  which aws > /dev/null; then
			echo '---------------------------'	
				echo "AWS Cli is not installed"
				echo '---------------------------'	
				exit 1
fi

if ! which gem > /dev/null ; then
 echo '---------------------------'	
				echo "ruby gem  is not installed"
				echo "please install ruby gem"
				echo '---------------------------'	
				exit 1
fi

if !  which terraforming > /dev/null; then
		echo '---------------------------'	
			echo "Terraforming is not installed"
			echo '---------------------------'	
			sudo -u ${USER} gem install terraforming
fi	
if ! [ -f ~/.aws/credentials ]
then
	echo "credentials files does not exist!"
else
	echo '---------------------------'
	echo "PROFILES are:"
	cat  ~/.aws/credentials|egrep -v "aws_*|=" | tr '[' ' '|tr ']' ' '|awk /./
	echo '---------------------------'
fi

if ! [ -f ~/.aws/account-roles ]
then
	echo "File with Roles does not exist"
else
	echo "ROLES are:"
	cat ~/.aws/account-roles|egrep -v "aws_*|=" | tr '[' ' '|tr ']' ' '|awk /./
fi


if [ -z "${1}" ]
	then
		echo '---------------------------'	
		echo "Usage $0 PATH"
		echo "Enter  PATH to save tfs"
	exit 1
	
	else
		mkdir -p aws-${AWS_PROFILE}
fi

AWS_PROFILE="${1}"

emptyfiles(){
	if [ -z ${AWS_PROFILE} ]
	then
		echo "AWS_PROFILE var is impty"
		exit 1
	
	fi
		# find files that only have 1 empty line (likely nothing in AWS)
		#find $(pwd) -type f -name '*.tf' | xargs wc -l | grep ' 1 .'|xargs rm -f
	if  [ -d aws-${AWS_PROFILE} ]
	then
		echo '---------------------------'	
		echo "finding empty tf files"
		echo '---------------------------'	
		find aws-${AWS_PROFILE} -type f -name '*.tf' -empty -delete
	else
		echo "PATH does not  exist"	
	fi

}

terraformget(){
	echo '---------------------------'	
	echo "searching dir configurations from profile: aws-${AWS_PROFILE}"
	echo "getting new config please wait..."
	echo '---------------------------'	
	
	#terraforming help | grep terraforming | grep -v help | awk -v var="${AWS_PROFILE}" '{ print "terraforming",  $2 , " > ",  $2"-" var".tf" }' |bash 2> /dev/null
	terraforming help | grep terraforming | grep -v help | awk -v var="aws-${AWS_PROFILE}" '{ print "terraforming",  $2 , " > ",  var"/"$2".tf" }'|bash 2> /dev/null
	
}

#####################################################################################
emptyfiles
terraformget
emptyfiles
