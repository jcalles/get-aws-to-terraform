#!/bin/bash

terraformget(){
	echo '---------------------------'	
	echo "Creating dir configurations from profile: aws-${PROFILE}"
				echo "getting new config please wait..."
				echo '---------------------------'	
	mkdir -p aws-${PROFILE} && cd aws-${PROFILE}
	
	terraforming help | grep terraforming | grep -v help | awk -v var="${PROFILE}" '{ print "terraforming",  $2 ," --profile", var  " > ",  $2"-" var".tf" }' |bash 2> /dev/null
		# find files that only have 1 empty line (likely nothing in AWS)
		echo '---------------------------'	
		echo "deleting empty tf files"
		echo '---------------------------'	
		
		#find $(pwd) -type f -name '*.tf' | xargs wc -l | grep ' 1 .'|xargs rm -f
		find $(pwd) -type f -name '*.tf' -empty -delete
		cd ../
}

 if ! which gem > /dev/null ; then
 echo '---------------------------'	
				echo "ruby gem  is not installed"
				echo "please install ruby gem"
				echo '---------------------------'	
				exit 1
fi


#####################################################################################
if [ -z $1 ]
	then
		echo '---------------------------'	
		echo "Profile not present."
		echo "Useage $0 [profile]"
		echo "Enter  a valid profile"
		echo '---------------------------'	
			if !  which aws > /dev/null; then
			echo '---------------------------'	
				echo "AWS Cli is not installed"
				echo '---------------------------'	
				exit 1
			else	
			echo '---------------------------'	
				echo "Profile is:"
				cat ~/.aws/credentials|egrep -v "aws_*|=" | tr '[' ' '|tr ']' ' '|awk /./
			echo '---------------------------'	
			fi
else
	PROFILE=$1
	## Terraforming is on https://github.com/dtan4/terraforming#supported-version
		if !  which terraforming > /dev/null; then
		echo '---------------------------'	
			echo "Terraforming is not installed"
			echo '---------------------------'	
			gem install terraforming
		else
			if ! [ -d aws-${PROFILE} ]
			then 
								
				terraformget
				ls aws-${PROFILE}
				
			else
			echo '---------------------------'	
			echo "profile:  aws-${PROFILE} exist!!"
				echo "moving profile aws-${PROFILE} to aws-${PROFILE}.old"
				echo '---------------------------'	
				if [ -d aws-${PROFILE}.old ]
				then
				echo '---------------------------'	
					echo "deleting old conf from aws-${PROFILE}"
					echo '---------------------------'	
					rm -Rf aws-${PROFILE}.old
				fi
					mv aws-${PROFILE} aws-${PROFILE}.old
					echo '---------------------------'	
					echo "Listing old aws configurations"
					echo '---------------------------'	
					ls aws-${PROFILE}.old/*
					terraformget
					echo '---------------------------'	
					echo "Listing NEW aws configurations"
					echo '---------------------------'	
					ls aws-${PROFILE}
			
			fi
		
		
		fi
fi
