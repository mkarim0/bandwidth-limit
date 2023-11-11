IF=eth0
tc qdisc add dev $IF root handle 1: htb default 30
tc class add dev $IF parent 1: classid 1:1 htb rate 6mbit burst 15k
tc class add dev $IF parent 1:1 classid 1:30 htb rate 3mbit ceil 6mbit burst 15k
tc qdisc add dev $IF parent 1:30 handle 30: sfq perturb 10

modprobe ifb 
ip link set dev ifb0 up
tc qdisc add dev $IF handle ffff: ingress
tc filter add dev $IF parent ffff: protocol ip u32 match u32 0 0 action mirred egress redirect dev ifb0

tc qdisc add dev ifb0 root handle 1: htb default 30
tc class add dev ifb0 parent 1: classid 1:1 htb rate 6mbit burst 15k
tc class add dev ifb0 parent 1:1 classid 1:30 htb rate 3mbit ceil 6mbit burst 15k
tc qdisc add dev ifb0 parent 1:30 handle 30: sfq perturb 10
