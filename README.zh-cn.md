# 無糖的小宇宙 | Shub

![GitHub license](https://img.shields.io/github/license/sugarlesss/shub)
![GitHub forks](https://img.shields.io/github/forks/sugarlesss/shub)
![GitHub stars](https://img.shields.io/github/stars/sugarlesss/shub)

[English README](https://github.com/sugarlesss/shub/blob/main/README.md) | 简体中文说明

<div align="center">
    <img src="./sugarless.svg" width="30%" height="30%" align="center">
</div>

[![Stargazers over time](https://starchart.cc/sugarlesss/shub.svg)](https://starchart.cc/sugarlesss/shub)

# 脚本索引

* 服务器
  * [SugarlessBench.sh](#sugarlessbenchsh)

---

# SugarlessBench.sh

## 简介：

SugarlessBench 是一款针对 Linux 服务器设计的测试脚本。通过此一键脚本，可以查看硬件配置信息及其综合性能。

SugarlessBench 目前涵盖了如下测试：

- **服务器基础信息** ( CPU信息 / 内存信息 / Swap信息 / 磁盘空间信息 / 网络信息等)
- **系统性能测试 ([ TODO ]CPU / [ TODO ]内存 / 磁盘)**

预览：

```
 CPU / RAM / Disk / OS / TCP 
 -------------------------------------------------------------- 
 CPU Model               : AMD EPYC 7402P 24-Core Processor
 CPU Cores               : 1 Cores 2794.750 MHz x64
 CPU Cache               : 512 KB 
 CPU AES-NI              : ✔ Enabled
 CPU VM-x/AMD-V          : ✔ Enabled

 RAM                     : 407 MB / 989 MB (132 MB Buff)
 SWAP                    : 29 MB / 1024 MB

 Disk                    : 5.9 GB / 9.9 GB 

 OS Release              : CentOS 7.9.2009
 OS Architecture         : x64
 OS virtualization       : KVM
 OS Kernel               : 4.9.215-36.el7.x86_64

 TCP Congestion Control  : bbr


 IPv4 / IPv6 / Region / ASN 
 -------------------------------------------------------------- 
 IPv4 - IP Address       : [US] 192.168.3.10
 IPv4 - ASN Info         : AS1234 (xxxxxxxxxxx)
 IPv4 - Region           : United States California Los Angeles
 IPv6 - IP Address       : [US] 1234:1234:1234:123::
 IPv6 - ASN Info         : AS1234 (xxxxxxxxxxx)
 IPv6 - Region           : United States United States 


 fio Disk Speed Tests (Mixed R/W 50/50): 
 -------------------------------------------------------------- 
 Block Size | 4k            (IOPS) | 64k           (IOPS)
   ------   | ---            ----  | ----           ---- 
 Read       | 10.97 MB/s    (2.7k) | 162.14 MB/s   (2.5k)
 Write      | 10.99 MB/s    (2.7k) | 162.99 MB/s   (2.5k)
 Total      | 21.97 MB/s    (5.4k) | 325.13 MB/s   (5.0k)
            |                      |                     
 Block Size | 512k          (IOPS) | 1m            (IOPS)
   ------   | ---            ----  | ----           ---- 
 Read       | 640.00 MB/s   (1.2k) | 789.10 MB/s    (770)
 Write      | 674.00 MB/s   (1.3k) | 841.65 MB/s    (821)
 Total      | 1.31 GB/s     (2.5k) | 1.63 GB/s     (1.5k)
```


## 下载 & 运行：

```bash
# Github
curl -fsSL https://raw.githubusercontent.com/sugarlesss/shub/main/SugarlessBench/SugarlessBench.sh | bash -s fast
wget -qO- https://raw.githubusercontent.com/sugarlesss/shub/main/SugarlessBench/SugarlessBench.sh | bash -s fast

# Gitee
curl -fsSL https://gitee.com/sugarlesss/shub/raw/main/SugarlessBench/SugarlessBench.sh | bash -s fast
wget -qO- https://gitee.com/sugarlesss/shub/raw/main/SugarlessBench/SugarlessBench.sh | bash -s fast
```

## 已测试通过的镜像

### 阿里云

```
centos
	[√] 8.5.2111
	[√] 7.2.1511 ~ 7.9.2009

Debian
	[√] 9.9

Ubuntu
	[√] 20.04.3 LTS
```

### Oracle Cloud

```
CentOS
	[√] 7.9.2009
```



---
Copyright (C) 2020-2021 Sugarless <https://sugarless.cn>