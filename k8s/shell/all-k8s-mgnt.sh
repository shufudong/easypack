#!/bin/sh

usage(){
  echo "Usage: $0 ACTION TYPE"
  echo "       ACTION:start|stop|restart|status|install|clear"
  echo "       TYPE:master|node|docker|ssl|apiserver|scheduler|controller"
  echo "            kubelet|kubeproxy|flannel|etcd"
  echo ""
}

ACTION=$1
TYPE=$2

if [ $# -ne 2 ]; then
  usage
  exit 1
fi

if [ _"$ACTION" = _"clear" ]; then
  # stop service first
  sh $0 stop all

  # in order to avoid rm -rf / : here hard coding for default dir
  echo "## data dir clear operation begins..."
  echo " # clear ssl dirs "
  rm -rf /etc/ssl/{ca,etcd,flannel,k8s} 
  echo " # clear etc dirs " 
  rm -rf /etc/{docker,flannel,k8s,etcd,kubernetes}
  echo " # clear log dirs "
  rm -rf /var/log/kubernetes
  echo " # cler ~/.kube"
  rm -rf ~/.kube
  echo " # clear working dirs or data dirs"
  rm -rf /var/lib/kubelet /var/lib/k8s /var/lib/docker /var/lib/etcd 
  echo "## data dir clear operation ends  ..."
  exit 0
fi

if [ _"$TYPE" = _"all" -o _"$TYPE" = _"master" -o _"$TYPE" = _"ssl" ]; then
  sh k8s-mgnt.sh $ACTION "ssl"
fi

if [ _"$TYPE" = _"all" -o _"$TYPE" = _"master" -o _"$TYPE" = _"etcd" ]; then
  sh k8s-mgnt.sh $ACTION "etcd"
fi

if [ _"$TYPE" = _"all" -o _"$TYPE" = _"master" -o _"$TYPE" = _"apiserver" ]; then
  sh k8s-mgnt.sh $ACTION "apiserver"
fi

if [ _"$TYPE" = _"all" -o _"$TYPE" = _"master" -o _"$TYPE" = _"scheduler" ]; then
  sh k8s-mgnt.sh $ACTION "scheduler"
fi

if [ _"$TYPE" = _"all" -o _"$TYPE" = _"master" -o _"$TYPE" = _"controller" ]; then
  sh k8s-mgnt.sh $ACTION "controller"
fi

if [ _"$TYPE" = _"all" -o _"$TYPE" = _"node" -o _"$TYPE" = _"flannel" ]; then
  sh k8s-mgnt.sh $ACTION "flannel"
fi

if [ _"$TYPE" = _"all" -o _"$TYPE" = _"node" -o _"$TYPE" = _"docker" ]; then
  sh k8s-mgnt.sh $ACTION "docker"
fi

if [ _"$TYPE" = _"all" -o _"$TYPE" = _"node" -o _"$TYPE" = _"kubelet" ]; then
  sh k8s-mgnt.sh $ACTION "kubelet"
fi

if [ _"$TYPE" = _"all" -o _"$TYPE" = _"node" -o _"$TYPE" = _"kubeproxy" ]; then
  sh k8s-mgnt.sh $ACTION "kubeproxy"
fi
