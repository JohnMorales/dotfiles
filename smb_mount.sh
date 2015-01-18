smb_mount() {
  if [ -f ~/.smbrc ]; then
    . ~/.smbrc
  fi
  local smb_host=$1
  local smb_host_uri=$smb_user:$smb_password@$smb_host
  local smb_share=$2
  local smb_mount_point=$3
  local result exit_code


  if [ -z $smb_host ] || [ -z $smb_share ]; then
    cat <<-USAGE
smb_mount {host} {share_name} {mount_point}

Parameters
==========
Host: The hostname or ip address only.
Sharename: The name of the share on the remote host.
Mount point: Optional (will default to /Volumes/{Sharename})

Authentication
==============
This function will use smb_user and smb_password environment variables,
or it will pull those values from a ~/.smbrc file. syntax is:
smb_user={username}
smb_password={password}
NOTE: no spaces between the equal sign.
USAGE
    return 1;
  fi
  if [ -z $smb_mount_point ]; then
    smb_mount_point=/Volumes/$smb_share
  fi
  if ! mount | grep " $smb_mount_point " >/dev/null; then
    mkdir -p $smb_mount_point
    result=$(mount -t smbfs //${smb_host_uri}/$smb_share $smb_mount_point 2>&1)
    if [ $? -ne 0 ]; then
      re='server connection failed: Socket is not connected'
      if [[ $result =~ $re ]]; then
        echo "'mount -t smbfs' failed, falling back to mount_smbfs"
        result=$(mount_smbfs -s //${smb_host_uri}/$smb_share $smb_mount_point 2>&1)
        exit_code=$?
        if [ $exit_code -ne 0 ]; then
          echo "mount failed (exit_code: $exit_code): $result"
          return 1
        fi
      fi
    fi
  fi
  #echo "$smb_mount_point already mounted."
}
