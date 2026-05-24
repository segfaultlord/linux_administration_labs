Task
Connect ditectrly two network namespaces:
- Create two network namespaces.
- Connect them with veth
- Configure interfaces.
- Ping each other

## Theory
Interface - struct in kernel that represent of netwok hardware device, like Ethernet adapter or emulated virtual connection. Represented in sysfs and procf. Usualy userspace programe like ip interracts with interface by netlink socket.

Virtual interface - interface that do not corespond directly to hardware

Network namespace - a kernel feature that provides isolated instances of the network stack (interfaces, routing tables, firewall rules) within a single operating system. They allow processes to have their own dedicated network configuration, separating them from the host's networking for enhanced security, testing, and containerization.
  A physical network device can live in exactly one network namespace.  When a network namespace is freed (i.e., when the last process in the namespace terminates), its physical network devices are moved back to the initial network namespace (not to the namespace of the parent of the process).
 A virtual device Usualy destroys with the namespace.
 loopback device cannot move to another namespace

veth - The veth devices are virtual Ethernet devices. They can act as tunnels between network namespaces to create a bridge to a physical network device in another namespace, but can also be used as standalone network devices. veth devices are always created in interconnected pairs.  A pair can be created using the command:
```ip link add <p1-name> type veth peer name <p2-name>```

## create two network namespace
Firstly, check existing namespaces:
```sudo ip netns list```

Empty, okay create two namespaces:
```
sudo ip netns add ns-first
sudo ip netns add ns-second
```

Another one try:
```sudo ip netns list```
output:
ns-second
ns-first

## Connect namespaces with a pair of veth
As mentioned before, veth device represent as pairs that creates a tunnels between network namespaces. That means, data sended from first veth apears at other one in pair.

Creating a pair of veth:
```sudo ip link add veth-first type veth peer name veth-second```

List interfaces:
```ip link show```
output:
7: veth-second@veth-first: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 02:99:5e:d4:80:26 brd ff:ff:ff:ff:ff:ff
8: veth-first@veth-second: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether aa:83:cc:10:bf:d1 brd ff:ff:ff:ff:ff:ff

A pair created successfully.Now move them to our namespaces.

```
sudo ip link set veth-first netns ns-first
sudo ip link set veth-second netns ns-second
```

Checking global namespace:
```ip link```

Checking our namespaces:
```sudo ip netns exec ns-first ip link```
```sudo ip netns exec ns-second ip link```

By the way we can create veth pait in a different namespaces in one command:
```sudo ip link add veth-first netns ns-first type veth peer veth-second netns ns-second```

## Configure interfaces

veth-first:
```
sudo ip netst exec ns-first ip link up veth-first
sudo ip netst exec ns-first ip a add 192.168.1.2/24 dev veth-first
```

veth-second:
```
sudo ip netst exec ns-second ip link up veth-second
sudo ip netst exec ns-second ip a add 192.168.1.2/24 dev veth-second
```

Checking:

## Ping

```sudo ip netst exec ns-first ping 192.168.1.3```
