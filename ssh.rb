 cheatsheet do
  title 'SSH'               # Will be displayed by Dash in the docset list
  docset_file_name 'ssh'    # Used for the filename of the docset
  keyword 'SSH'             # Used as the initial search keyword 
                            # (listed in Preferences > Docsets)
  # resources 'resources_dir'  # An optional resources folder which can contain images or anything else
  # introduction 'Quelques commandes'  # Optional, can contain Markdown or HTML

  # A cheat sheet must consist of categories
  category do
    id 'SSH Cheatsheet'
    entry do
        command 'ssh [user]@[host]'
        name    'Base Usage'
    end
    entry do
      command 'ssh -i ~/.ssh/id_rsa [user]@[host]'
      name    'Use Specific Key'
    end
    entry do
      command 'ssh -i ~/.ssh/id_rsa -p [port] [user]@[host]'
      name    'Use Alternative Port'
    end
    entry do
      command 'ssh -D8080 [user]@[host]'
      name    'Dynamic SOCKS Proxy'
      notes   'This can be used with proxychains to forward client traffic through the remote server.'
    end
    entry do
      command 'ssh -L [bindaddr]:[port]:[dsthost]:[dstport] [user]@[host]'
      name    'Local Port Forwarding'
      notes   'This will bind to **[bindaddr]:[port]** on the client and forward through the SSH server to the **[dsthost]:[dstport]**'
    end
    entry do
      command 'ssh -R [bindaddr]:[port]:[localhost]:[localport] [user]@[host]'
      name    'Remote Port Forwarding'
      notes   'This will bind to **[bindaddr]:[port]** on the remote server and tunnel traffic through the ssh client side to **[localhost]:[localport]**'
    end
    entry do
      command 'ssh -i ~/.ssh/id_rsa [user]@[host] "sudo apt-get update && sudo apt-get upgrade"'
      name    'Execute a One Liner'
    end
  end

  category do
    id 'VPN over SSH'
    entry do
      command 'ssh [user]@[host] -w any:any'
      name    'Establish VPN over SSH'
      notes "
        The following options **must** be enabled on the server side.
        
        ```
        PermitRootLogin yes
        PermitTunnel yes
        ```
        
        You can see the established tun interface by typing ```ifconfig -a```

        The interfaces and forwarding must still be configured. This assumes that we are going to forward 10.0.0.0/24 
        through the remote server. We are also assuming that the server’s main connection is through ```eth0```, 
        and both client/server stood up tun0. This may be different if you already have existing VPN connections.
        "
    end
    entry do
      command 'ip addr add 192.168.5.2/32 peer 192.168.5.1 dev tun0'
      name    '**Client**'
      notes "
        ```
        # Once Server is setup, run the following to add routes
        route add -net 10.0.0.0/24 gw 192.168.5.1
        ```
        "
    end
    entry do
      command 'ip addr add 192.168.5.1/32 peer 192.168.5.2 dev tun0'
      name    '**Server**'
      notes "
        ```
        sysctl -w net.ipv4.ip_forward=1
        iptables -t nat -A POSTROUTING -s 192.168.5.1 -o eth0 -j MASQUERADE
        ```
        "
    end
  end

  category do
    id 'Files'
    entry do
      notes "
      <table>
        <tbody>
          <tr><th>File</th><th>Description</th></tr>
          <tr><td>~/.ssh/	              </td><td>Directory for user-specific SSH configuration</td></tr>
          <tr><td>~/.ssh/authorized_keys</td><td>Lists public keys authorized for logging into this user</td></tr>
          <tr><td>~/.ssh/config	        </td><td>Per-user config file. Can specify how to connect, with which keys etc</td></tr>
          <tr><td>~/.ssh/id_*	          </td><td>Key files, both public and private</td></tr>
          <tr><td>~/.ssh/known_hosts	  </td><td>Contains list of public host keys known to user</td></tr>
          <tr><td>/etc/ssh/ssh_config	  </td><td>Global SSH client configuration</td></tr>
          <tr><td>/etc/ssh/sshd_config	</td><td>SSH server configuration</td></tr>
        </tbody>
      </table>
      "
    end
  end

  category do
    id 'Keys'
    entry do
      command 'ssh-keygen'
      name    'Generating Keys'
    end
    entry do
      command 'cat id_rsa.pub >> ~/.ssh/authorized_keys'
      name    'Adding Authorized Keys'
    end
    entry do
      command 'ssh-copy-id -i ~/.ssh/id_rsa [user]@[host]'
      name    'Copying Authorized Keys on [host]'
    end
  end

  category do
    id 'SSH Escape Sequences'
    entry do
      notes "
      <table>
        <tbody>
          <tr><th>Escape Sequence</th><th>Description</th></tr>
          <tr><td>~?</td><td>List all options</td></tr>
          <tr><td>~B</td><td>Send BREAK to remote host</td></tr>
          <tr><td>~R</td><td>Request Re-key</td></tr>
          <tr><td>~V/v</td><td>Decrease / Increase verbosity</td></tr>
          <tr><td>~^Z</td><td>Suspend SSH</td></tr>
          <tr><td>~#</td><td>List forwarded connections</td></tr>
          <tr><td>~&</td><td>background ssh</td></tr>
          <tr><td>~~</td><td>Send the escape character instead of escaping the next char</td></tr>
        </tbody>
      </table>
      "
    end
  end

  category do
    id 'SCP: SSH Copy utility for pushing and pulling files remotely'
    entry do
      command 'scp [user]@[host]:file.txt /tmp/file.txt'
      name    'Copy from remote to local'
    end
    entry do
      command 'scp file.txt [user]@[host]:/tmp/file.txt'
      name    'Copy from local to remote'
    end
    entry do
      command 'scp -r [user]@[host]:/home/ubuntu/.vim ./vim'
      name    'Copy recursively (full directories)'
    end
    entry do
      command 'scp -P 2222 [user]@[host]:/home/ubuntu/test.py ./test.py'
      name    'Use non-standard port'
      notes   'Uses -P instead of -p switch in regular SSH command. The preceding uses port 2222.'
    end
  end

  notes <<-'END'
  * Based on a [cheat sheet](https://bitrot.sh/cheatsheet/13-12-2017-ssh-cheatsheet/) by [bitrot.sh](https://bitrot.sh/page/about/)
  END

end
