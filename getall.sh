#!/bin/bash
#####################################################################################
if [ -z $1 ]
	then
	echo '---------------------------'	
	echo "Profile not present."
	echo "Useage $0 [profile]"
	echo "Enter  a valid profile"
	echo '---------------------------'	
		if !  which aws ; then
			echo "AWS Cli is not installed"
			exit 1
		else
			cat ~/.aws/credentials|egrep -v "aws_*|=" | tr '[' ' '|tr ']' ' '|awk /./
		fi
else
	PROFILE=$1
	## Terraforming is on https://github.com/dtan4/terraforming#supported-version
	if !  which terraforming ; then
	echo "Terraforming is not installed"
	gem install terraforming
	else

	terraforming help | grep terraforming | grep -v help | awk -v var="${PROFILE}" '{ print "terraforming",  $2 ," --profile", var  " > ",  $2"-" var".tf" }' |bash

# find files that only have 1 empty line (likely nothing in AWS)
find $(pwd) -type f -name '*.tf' | xargs wc -l | grep ' 1 .'
	fi
fi
