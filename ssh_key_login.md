# SSH Key login

Steps:
- Gen a new pair of keys
- Ensure delivering public key to ssh host
- Login with key

resources:
[debian wiki](https://wiki.debian.org/Setup%20SSH%20Passwordless%20Login) 
[TODO] How it works briefly?

## Gen a new keys
```
ssh-keygen -t ed25519
```

On legacy system

```
ssh-keygen -t rsa -b 4096
```

also option -C would be pretty usefull for identifying. It appends a comment, a line using only for user purpouses.

```ssh-keygen -t rsa -b 4096 -C "example@gmail.com github key"```

As a result we get the pair of key files(public  and privite). Typically they srores at ~/.ssh directory.

## Copy the public key 

### Automatic method
For this method you will need to have password auth permiton enabled at taget machine ssh daemon.

```
ssh-copy-id
```

### Manualy
you should write a public key to target's ~/.ssh/authorized_key file

```cat ~/.ssh/id_rsa.pub | ssh <user>@<hostname> 'umask 0077; mkdir -p .ssh; cat >> .ssh/authorized_keys```

## Finally login
at default it is search a default named key at ~/.ssh/* .
If pathname is changed, you could do it by passing key's pathname through -i option to ssh command.

excplicitly specify key file
```
ssh -i ~/.ssh/key user@localhost
```

## using alias in ssh configurarion
We can use aliases defined at ssh configuration file.
Example:
Host debian
    HostName localhost
    user yarik
    port 12345
    IdentityFile ~/.ssh/github_adm

usage: ssh debian


