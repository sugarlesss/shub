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
 CPU Model               : Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz
 CPU Cores               : 2 Cores 2699.998 MHz x64
 CPU Cache               : 30720 KB 
 CPU AES-NI              : ✔ Enabled
 CPU VM-x/AMD-V          : ❌ Disabled

 RAM                     : 77 MB / 984 MB (89 MB Buff)
 SWAP                    : 0 MB / 1022 MB

 Disk                    : 1.7 GB / 34.0 GB 

 OS Release              : CentOS 7.9.2009
 OS Architecture         : x64
 OS virtualization       : KVM
 OS Kernel               : 4.14.129-bbrplus

 TCP Congestion Control  : bbrplus


 IPv4 / IPv6 / Region / ASN 
 -------------------------------------------------------------- 
 IPv4 - IP Address       : [US] 192.168.1.1
 IPv4 - ASN Info         : AS35916 (MULTA-ASN1 - MULTACOM CORPORATION, US)
 IPv4 - Region           : United States California Los Angeles


 CPU Performance Test (Standard Mode, 3-Pass @ 15sec) 
 -------------------------------------------------------------- 
 1 Thread Test           : 769 Scores
 2 Threads Test           : 1538 Scores


 Memory Performance Test (Standard Mode, 3-Pass @ 15sec) 
 -------------------------------------------------------------- 
 1 Thread - Read Test    : 15811.04 MB/s
 1 Thread - Write Test   : 12623.19 MB/s


 Disk Performance Test (fio Mixed R/W 50/50): 
 -------------------------------------------------------------- 
 Block Size | 4k            (IOPS) | 64k           (IOPS)
   ------   | ---            ----  | ----           ---- 
 Read       | 11.57 MB/s    (2.8k) | 151.52 MB/s   (2.3k)
 Write      | 11.56 MB/s    (2.8k) | 152.32 MB/s   (2.3k)
 Total      | 23.14 MB/s    (5.7k) | 303.84 MB/s   (4.7k)
            |                      |                     
 Block Size | 512k          (IOPS) | 1m            (IOPS)
   ------   | ---            ----  | ----           ---- 
 Read       | 155.82 MB/s    (304) | 174.88 MB/s    (170)
 Write      | 164.10 MB/s    (320) | 186.53 MB/s    (182)
 Total      | 319.93 MB/s    (624) | 361.42 MB/s    (352)
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