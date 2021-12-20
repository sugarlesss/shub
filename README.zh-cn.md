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

## 脚本说明：

* 硬件信息
* 操作系统信息
* fio 硬盘读写测试
* IPv4 信息

## 下载 & 运行：

```bash
# Github
curl -fsSL https://raw.githubusercontent.com/sugarlesss/shub/main/SugarlessBench/SuagrlessBench.sh | bash -s fast
wget -N --no-check-certificate https://raw.githubusercontent.com/sugarlesss/shub/main/SugarlessBench/SuagrlessBench.sh && chmod +x SuagrlessBench.sh && bash SuagrlessBench.sh fast

# fastgit
curl -fsSL https://raw.fastgit.org/sugarlesss/shub/main/SugarlessBench/SuagrlessBench.sh | bash -s fast
wget -N --no-check-certificate https://raw.fastgit.org/sugarlesss/shub/main/SugarlessBench/SuagrlessBench.sh && chmod +x SuagrlessBench.sh && bash SuagrlessBench.sh fast
```

## 兼容性

### 阿里云镜像

```
centos
	[√] 8.5.2111
	[√] 7.2.1511 ~ 7.9.2009
	[x] 6.10 / 6.9
		* yum update 时会因为系统源的问题遇到一些错误，可自行 baidu/google 解决
			* http://mirrors.aliyun.com/centos/6/os/x86_64/repodata/repomd.xml: [Errno 14] PYCURL ERROR 22 - "The requested URL returned error: 404 Not Found" Trying other mirror.
	[x] 5.8
		* yum update 时会因为系统源的问题遇到一些错误，可自行 baidu/google 解决
			* http://mirrors.aliyun.com/centos/6/os/x86_64/repodata/repomd.xml: [Errno 14] PYCURL ERROR 22 - "The requested URL returned error: 404 Not Found" Trying other mirror.
		* curl/wget 下载脚本文件时, 会因为 SSL 协议的问题下载失败, 可手动上传脚本文件至服务器
			* curl: (35) error:1407742E:SSL routines:SSL23_GET_SERVER_HELLO:tlsv1 alert protocol version
			* OpenSSL: error:1407742E:SSL routines:SSL23_GET_SERVER_HELLO:tlsv1 alert protocol version. Unable to establish SSL connection.

Debian
	[√] 9.9

Ubuntu
	[√] 20.04.3 LTS
```

---
Copyright (C) 2020-2021 Sugarless <https://sugarless.cn>