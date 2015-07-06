aws_show_cloudfronts ()
{
  aws cloudfront list-distributions | jq -r '.DistributionList|.Items[]| "\(.Id) \(.DomainName) \(.Origins.Items[0].DomainName) \(.Status)"'
}
aws_show_pending_cloudfronts ()
{
  aws cloudfront list-distributions | jq -r '.DistributionList|.Items[]|select(.Status=="InProgress")|{Status, Aliases: .Aliases.Items}'
}

aws_update_ssh_hosts()
{
  cp ~/.ssh/config ~/.ssh/config.bak
  cp ~/.ssh/config ~/.ssh/config.tmp
  sed '/BEGIN - AWS/,/END - AWS/ d' ~/.ssh/config.tmp > ~/.ssh/config 
  AWS_ACCESS_KEY=$AWS_ACCESS_KEY_ID AWS_SECRET_KEY=$AWS_SECRET_ACCESS_KEY ec2din  --filter instance-state-name=running  |grep -E "^INSTANCE|^TAG.*\WName\W" | awk 'BEGIN { print "#BEGIN - AWS" } {hostname=$4; keyfile=$7; getline; name=$5; gsub("/", "_", name);  printf("Host aws.%s\n", name); printf("IdentityFile ~/.ssh/%s.pem\n", keyfile); printf("HostName %s\n", hostname); printf("User ec2-user\n"); print "" } END { print "#END - AWS"}' >> ~/.ssh/config
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
  aws ec2 describe-instances | jq '.Reservations[].Instances[]|{state: .State.Name,instance: .InstanceId,name: .Tags[0].Value} | select(.state=="running")'
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
  aws ec2 describe-instances | jq '.Reservations[]|.Instances[]|{PublicDnsName,KeyName,InstanceId,Name: .Tags[0].Value}'
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
  if [ -z $instance_id ]; then
    echo "Must provide an instance id"
    return
  fi
  local groups=$(aws ec2 describe-instances --instance-ids $instance_id | jq '{ Groups: [.Reservations[].Instances[].SecurityGroups[].GroupId] }')
  aws ec2 modify-instance-attribute --instance-id $instance_id --cli-input-json "$groups"
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
