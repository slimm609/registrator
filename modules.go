package main

import (
	_ "github.com/slimm609/registrator/consul"
	_ "github.com/slimm609/registrator/consulkv"
	_ "github.com/slimm609/registrator/etcd"
	_ "github.com/slimm609/registrator/skydns2"
	_ "github.com/slimm609/registrator/zookeeper"
)
