aws_show_cloudfronts ()
{
  aws cloudfront list-distributions | jq -r '.DistributionList|.Items[]| "\(.Id) \(.DomainName) \(.Origins.Items[0].DomainName) \(.Status)"'
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
  local sec_group=ssh_only_from_home
  local newip=$(whatismyip)
  local oldip=$(aws ec2 describe-security-groups --filters Name=ip-permission.from-port,Values=22 --query 'SecurityGroups[*].IpPermissions[*].IpRanges[*].CidrIp' |  grep -oE '([0-9]+\.?){4}' |xargs echo -n)
  if [ -n "$newip" ] && [ "$newip" != "$oldip" ]; then
    echo "Setting $sec_group to '$newip' old ip was '$oldip'"
    if [ -n "$oldip" ]; then
      aws ec2 revoke-security-group-ingress --group-name ${sec_group} --protocol tcp --port 22 --cidr ${oldip}/32
    fi
    aws ec2 authorize-security-group-ingress --group-name ${sec_group} --protocol tcp --port 22 --cidr ${newip}/32
  else
    echo "Security group already set to $newip"
  fi
}

aws_get_running_instance()
{
  aws ec2 describe-instances | jq '.Reservations[].Instances[]|{state: .State.Name,instance: .InstanceId,name: .Tags[0].Value} | select(.state=="running")'
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
  aws ec2 describe-instances --instance-ids $1 | jq '.Reservations[].Instances[].SecurityGroups[].GroupName'
}

