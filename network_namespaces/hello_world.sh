#!/usr/bin/env bash

# creating network ns
ip netns add ns-first
ip netns add ns-second

# creating veth dev
ip link add veth-first netns ns-first type veth peer veth-second netns ns-second

# configure veth-first

ip netst exec ns-first ip link up veth-first
ip netst exec ns-first ip a add 192.168.1.2/24 dev veth-first

# configure veth-second
sudo ip netst exec ns-second ip link up veth-second
sudo ip netst exec ns-second ip a add 192.168.1.2/24 dev veth-second
