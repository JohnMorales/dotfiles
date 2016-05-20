aws_show_cloudfronts ()
{
  aws cloudfront list-distributions | jq -r '.DistributionList|.Items[]| "\(.Id) \(.DomainName) \(.Origins.Items[0].DomainName) \(.Status)"'
}
aws_show_load_balanacers()
{
  aws elb describe-load-balancers | jq '.LoadBalancerDescriptions[]| "\(.DNSName) \(.Instances[]|join(","))"'
}

aws_show_pending_cloudfronts ()
{
  aws cloudfront list-distributions | jq -r '.DistributionList|.Items[]|select(.Status=="InProgress")|{Status, Aliases: .Aliases.Items}'
}

aws_update_ssh_hosts()
{
  aws ec2 describe-instances | jq -r '.Reservations[].Instances[]|"\(.PublicDnsName) \(.KeyName) \((((.Tags//[])[]|select(.Key == "Name"))//{}).Value) \(.InstanceId)"' | while read hostname keyfile name instanceid; do
    if [ "$name" == "null" ]; then
     >&2 echo "$instanceid does not have a tag!!"
     continue
    fi
    name=${name//\//_}
    cat <<OUTPUT
Host aws.$name
IdentityFile ~/.ssh/$keyfile.pem
HostName $hostname
User ec2-user

OUTPUT
  done > ~/.ssh/config.d/aws

  cat ~/.ssh/config.d/* >~/.ssh/config;
}

aws_update_ssh_from_home()
{
  local sec_group=${1:-ssh_only_from_home}
  local newip=$(whatismyip)
  local oldip=$(aws ec2 describe-security-groups  --group-names $sec_group --filters Name=ip-permission.from-port,Values=22 --query 'SecurityGroups[].IpPermissions[].IpRanges[].CidrIp' | jq -r '.[]' | grep -oE '([0-9]+\.?){4}' |xargs echo -n)
  if [ -n "$newip" ] && [ "$newip" != "$oldip" ]; then
    echo "Setting $sec_group to '$newip' old ip was '$oldip'"
    if [ -n "$oldip" ]; then
      aws ec2 revoke-security-group-ingress --group-name ${sec_group} --protocol tcp --port 22
    fi
    aws ec2 authorize-security-group-ingress --group-name ${sec_group} --protocol tcp --port 22 --cidr ${newip}/32
  else
    echo "Security group already set to $newip"
  fi
}

aws_get_running_instances()
{
  aws ec2 describe-instances | jq '.Reservations[].Instances[]|{State: .State.Name,instance: .InstanceId, Name: (((.Tags//[])[]|select(.Key == "Name"))//{}).Value} | select(.State=="running")'
}
aws_show_instance()
{
  instance_id=$1
  if [ -z $instance_id ]; then
    echo "Must provide an instance id"
    return
  fi
  aws ec2 describe-instances --instance-ids $instance_id | jq '.Reservations[].Instances[]'
}
aws_show_instances()
{
  aws ec2 describe-instances | jq '.Reservations[]|.Instances[]|{PublicDnsName,KeyName,InstanceId,Name: (((.Tags//[])[]|select(.Key == "Name"))//{}).Value}'
}
aws_show_instance_security_groups()
{
  instance_id=$1
  if [ -z $instance_id ]; then
    echo "Must provide an instance id"
    return
  fi
  aws ec2 describe-instances --instance-ids $instance_id | jq '[.Reservations[].Instances[].SecurityGroups[]]'
}
aws_show_pending_spot_instances()
{
  aws ec2 describe-spot-instance-requests | jq '.SpotInstanceRequests[]|select(.Status.Code != "fulfilled")|{Status: .Status.Message, SpotInstanceRequestId }'
}
aws_show_spot_instance_requests()
{
  aws ec2 describe-spot-instance-requests | jq '.SpotInstanceRequests[]|{Status: .Status.Message, SpotInstanceRequestId }'
}
aws_copy_security_groups_to_instance()
{
  local instance_id=$1
  local to_instance=$2
  if [ -z $instance_id ]; then
    echo "Must provide an instance id"
    return
  fi
  if [ -z $to_instance ]; then
    echo "Must provide an instance id to copy to"
    return
  fi
  local groups=$(aws ec2 describe-instances --instance-ids $instance_id | jq '{ Groups: [.Reservations[].Instances[].SecurityGroups[].GroupId] }')
  aws ec2 modify-instance-attribute --instance-id $to_instance --cli-input-json "$groups"
}

aws_attach_security_group()
{
  local instance_id=$1
  local security_group_desc=$2
  if [ -z $instance_id ]; then
    echo "Must provide an instance id"
    return
  fi
  if ! [ -f $security_group_desc ]; then
    echo "Must provide a security group file"
    return
  fi
  aws ec2 modify-instance-attribute --instance-id $instance_id --cli-input-json "$(cat $security_group_desc)"
}

aws_set_instance_name()
{
  local instance_id=$1
  if [ -z $instance_id ]; then
    echo "Must provide an instance id"
    return
  fi
  local name=$2
  aws ec2 create-tags --resources $instance_id --tags "Key=Name,Value=$name"
}
aws_show_security_group()
{
  local security_group_name=$1
  if [ -z $security_group_name ]; then
    aws ec2 describe-security-groups | jq '.SecurityGroups[]|{GroupName,IpPermissions,IpPermissionsEgress}'
    return
  fi
  aws ec2 describe-security-groups | jq ".SecurityGroups[]|{GroupName,IpPermissions,IpPermissionsEgress}|select(.GroupName == \"$security_group_name\")"
}

aws_show_security_groups()
{
  aws ec2 describe-security-groups | jq '.SecurityGroups[]|"\(.GroupId) \(.GroupName) \(.Description)"'
}

aws_show_vpcs()
{
  aws ec2 describe-vpcs
}

aws_terminate_instances()
{
   aws ec2 terminate-instances --instance-ids "$@"
}

aws_show_policies()
{
  aws iam list-policies | jq '.Policies[]|(.Arn|select(startswith("arn:aws:iam::")))'
}

aws_set_profile()
{
  local profile_id=$1
  if [ -z $profile_id ] && [ -f ~/.aws_current_profile ]; then
    profile_id=$(cat ~/.aws_current_profile)
  fi
  if [ -z $profile_id ]; then
    echo "Must provide on of the following profile ids: "
    cat ~/.aws/credentials | awk '/^\[/ { gsub(/\[|\]/, "", $1); print $1 }'
    return
  fi
  local profile=$(grep -E "\[.*$profile_id.*\]" ~/.aws/credentials | sed -e 's/\[//' -e 's/\]//' -e '/^$/d')
  if [ -n "$profile" ] && [ $(echo -n "$profile" | wc -l) -ne 0 ]; then
    echo "Could not validate profile id, found '$profile'"
    return
  else
    echo $profile > ~/.aws_current_profile
  fi
  #echo export AWS_DEFAULT_PROFILE=$profile
  export AWS_DEFAULT_PROFILE=$profile
  export AWS_EB_PROFILE=$profile
  keys=$(grep -A2 $profile ~/.aws/credentials | tail -n2 | awk '{ printf("export %s=%s\n", toupper($1), $3) }')
  #echo "$keys"
  eval "$keys"
}
