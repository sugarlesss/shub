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
  * [SugarlessBench.sh](#SugarlessBenchsh)

---

# SugarlessBench.sh

## 简介：

SugarlessBench 是一款针对 Linux 服务器设计的测试脚本。通过此一键脚本，可以查看硬件配置信息及其综合性能。

SugarlessBench 目前涵盖了如下测试：

- **服务器基础信息** ( CPU信息 / 内存信息 / Swap信息 / 磁盘空间信息 / 网络信息等)
- **系统性能测试 ([ TODO ]CPU / [ TODO ]内存 / 磁盘)**

预览：

```
 -------------------------------------------------------------- 
 CPU Model               : AMD EPYC 7551 32-Core Processor
 CPU Cores               : 2 Cores 1996.253 MHz x64
 CPU Cache               : 512 KB 
 CPU AES-NI              : ✔ Enabled
 CPU VM-x/AMD-V          : ❌ Disabled

 RAM                     : 349 MB / 979 MB (244 MB Buff)
 SWAP                    : 1 MB / 8191 MB

 Disk                    : 5.1 GB / 39.5 GB 

 OS                      : CentOS 7.9.2009
 OS Architecture         : x64
 OS virtualization       : KVM
 OS Kernel               : 4.14.129-bbrplus
 TCP Congestion Control  : bbrplus

 Uptime                  : 10 days 4 hour 58 min
 Load Average            : 0.20, 0.14, 0.13
 -------------------------------------------------------------- 
 IPV4 - IP Address       : [KR] 193.x.x.231
 IPV4 - ASN Info         : AS31898 (ORACLE-BMC-31898 - Oracle Corporation, US)
 IPV4 - Region           : Republic of Korea Seoul 
 -------------------------------------------------------------- 

 fio Disk Speed Tests (Mixed R/W 50/50):
 ---------------------------------
 Block Size | 4k            (IOPS) | 64k           (IOPS)
   ------   | ---            ----  | ----           ---- 
 Read       | 6.30 MB/s     (1.5k) | 25.93 MB/s     (405)
 Write      | 6.31 MB/s     (1.5k) | 26.38 MB/s     (412)
 Total      | 12.61 MB/s    (3.1k) | 52.32 MB/s     (817)
            |                      |                     
 Block Size | 512k          (IOPS) | 1m            (IOPS)
   ------   | ---            ----  | ----           ---- 
 Read       | 24.52 MB/s      (47) | 23.90 MB/s      (23)
 Write      | 26.04 MB/s      (50) | 26.66 MB/s      (26)
 Total      | 50.57 MB/s      (97) | 50.56 MB/s      (49)
```


## 下载 & 运行：

```bash
# Github
wget -N --no-check-certificate https://raw.githubusercontent.com/sugarlesss/shub/main/SugarlessBench/SugarlessBench.sh && chmod +x SugarlessBench.sh && bash SugarlessBench.sh fast

# Gitee
wget -N --no-check-certificate https://gitee.com/sugarlesss/shub/raw/main/SugarlessBench/SugarlessBench.sh && chmod +x SugarlessBench.sh && bash SugarlessBench.sh fast
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