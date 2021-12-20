#!/usr/bin/env bash

# 全局常量 =======================================================================================================================#
Script_Version="0.1.0"                                                                                                            #
UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36"  #
UA_Dalvik="Dalvik/2.1.0 (Linux; U; Android 9; ALP-AL00 Build/HUAWEIALP-AL00)"                                                    #
# 全局常量========================================================================================================================#

# 字体颜色 ========# 
Black="\033[30m"   #
Red="\033[31m"     #
Green="\033[32m"   #
Yellow="\033[33m"  #
Blue="\033[34m"    #
Purple="\033[35m"  #
SkyBlue="\033[36m" #
White="\033[37m"   #
Suffix="\033[0m"   #
# 字体颜色=========#

# 消息提示定义 =============================#
Msg_Info="${Blue}[Info] ${Suffix}"         #
Msg_Warning="${Yellow}[Warning] ${Suffix}" #
Msg_Debug="${Yellow}[Debug] ${Suffix}"     #
Msg_Error="${Red}[Error] ${Suffix}"        #
Msg_Success="${Green}[Success] ${Suffix}"  #
Msg_Fail="${Red}[Failed] ${Suffix}"        #
# 消息提示定义 =============================#

# 关于此脚本
About() {
    echo -e "
 ${Green} +---------------------------------------------------------------------------+ ${Suffix}
 ${Green} |${Suffix} ${Blue}SugarlessBench.sh${Suffix} ${Yellow}Version ${Script_Version}${Suffix}                                           ${Green}|${Suffix}
 ${Green} +---------------------------------------------------------------------------+ ${Suffix}
 ${Green} |${Suffix} ${Purple}Description :${Suffix} ${Yellow}Basic system info & I/O test & Speedtest${Suffix}                    ${Green}|${Suffix}
 ${Green} |${Suffix} ${Purple}Intro       :${Suffix} ${SkyBlue}https://sugarless.cn/posts/linux-script/sugarlessbench.html${Suffix} ${Green}|${Suffix}
 ${Green} |${Suffix} ${Purple}Github      :${Suffix} ${SkyBlue}https://github.com/sugarlesss/shub${Suffix}                          ${Green}|${Suffix}
 ${Green} |${Suffix} ${Purple}Author      :${Suffix} ${SkyBlue}Sugarless${Suffix} ${Blue}<jaded@foxmail.com>${Suffix}                               ${Green}|${Suffix}
 ${Green} |${Suffix} ${Purple}Blog        :${Suffix} ${SkyBlue}https://sugarless.cn${Suffix}                                        ${Green}|${Suffix}
 ${Green} +---------------------------------------------------------------------------+${Suffix}"
}

# 初始化
Init() {
    # 在运行脚本的同一位置创建一个目录, 以临时存放有关的文件
    DATE=$(date -Iseconds | sed -e "s/:/_/g")
    ROOT_PATH=./$DATE
    mkdir -p $ROOT_PATH

    # 测试用户在当前目录中是否有写入权限，如果没有则退出
    touch $DATE.test 2>/dev/null
    if [ ! -f "$DATE.test" ]; then
        # 没有写入权限
        echo -e
        echo -e "You do not have write permission in this directory. Switch to an owned directory and re-run the script.\nExiting..."
        exit 1
    else
        # 删除测试文件
        rm $DATE.test
    fi
}

# Trap 终止信号捕获 ===========
trap "TrapSigExit_Sig1" 1
trap "TrapSigExit_Sig2" 2
trap "TrapSigExit_Sig3" 3
trap "TrapSigExit_Sig15" 15

# 捕获 CTRL+C 终止信号
trap CatchAbort INT

# 处理 CTRL+C 终止信号事件
CatchAbort(){
    echo -e "\n\n${Msg_Error}Caught Signal SIGINT (or Ctrl+C), Exiting ...\n"
    Clean
    exit 1
}
# =================================================

# 清理缓存文件
Clean() {
    echo -e "${Msg_Info}Deleting temporary files..."
    rm -rf $ROOT_PATH
}

# 测试完成
Complete(){
    echo -e
    Clean
    echo -e "\n${Msg_Success}Test complete\n"
    exit 0
}


# GetSystemInfo
GetSystemInfo() {
    # CPU 名字及其编号、标称主频
    cpu_model_name=$(awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//')
    # 该逻辑核所处 CPU 的物理核数
    cpu_cores=$(awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo)
    # CPU 实际主频
    cpu_MHz=$(awk -F: '/cpu MHz/ {cpu_MHz=$2} END {print cpu_MHz}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//')
    # CPU 二级缓存
    cpu_cache=$(awk -F: '/cache size/ {cache=$2} END {print cache}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//')

    # 是否支持 AES-NI 指令集
    cpu_aes=$(cat /proc/cpuinfo | grep aes)
    [[ -z "$cpu_aes" ]] && cpu_aes="${Red}\xE2\x9D\x8C Disabled${Suffix}" || cpu_aes="${Yellow}\xE2\x9C\x94 Enabled${Suffix}"
    # VM-x/AMD-V 硬件加速
    cpu_virt=$(cat /proc/cpuinfo | grep 'vmx\|svm')
    [[ -z "$cpu_virt" ]] && cpu_virt="${Red}\xE2\x9D\x8C Disabled${Suffix}" || cpu_virt="${Yellow}\xE2\x9C\x94 Enabled${Suffix}"

    # RAM 总量
    ram_total=$(free -m | awk '/Mem/ {print $2}')
    # RAM 已使用
    ram_used=$(free -m | awk '/Mem/ {print $3}')
    # RAM 已缓存
    ram_buffer=$(free -m | awk '/Mem/ {print $6}')

    # SWAP 总量
    swap_total=$(free -m | awk '/Swap/ {print $2}')
    # SWAP 已使用
    swap_used=$(free -m | awk '/Swap/ {print $3}')

    # 系统已经运行了多长时间
    system_uptime=$(awk '{a=$1/86400;b=($1%86400)/3600;c=($1%3600)/60} {printf("%d days %d hour %d min\n",a,b,c)}' /proc/uptime)
    # 系统负载
    system_load=$(w | head -1 | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//')

    # 获取操作系统信息
    os_version=$(GetOperatingSystemInfo)
    # 操作系统架构
    # os_arch=$(uname -m)
    os_arch=$(GetArch)

    # 操作系统位数
    os_long_bit=$(getconf LONG_BIT)
    # 操作系统内核
    os_kernel=$(uname -r)
    # 虚拟化
    os_virt=$(GetVirt)

    # 硬盘 已使用容量 / 总容量
    disk_size1=$(LANG=C df -hPl | grep -wvE '\-|none|tmpfs|overlay|shm|udev|devtmpfs|by-uuid|chroot|Filesystem' | awk '{print $2}')
    disk_size2=$(LANG=C df -hPl | grep -wvE '\-|none|tmpfs|overlay|shm|udev|devtmpfs|by-uuid|chroot|Filesystem' | awk '{print $3}')
    disk_total_size=$(calc_disk ${disk_size1[@]})
    disk_used_size=$(calc_disk ${disk_size2[@]})

    # TCP 拥塞控制算法
    tcp_congestion_control=$(sysctl net.ipv4.tcp_congestion_control | awk -F ' ' '{print $3}')
}

# 系统虚拟化
GetVirt() {
    if hash ifconfig 2>/dev/null; then
        eth=$(ifconfig)
    fi

    virtualx=$(dmesg) 2>/dev/null

    if [ $(which dmidecode) ]; then
        sys_manu=$(dmidecode -s system-manufacturer) 2>/dev/null
        sys_product=$(dmidecode -s system-product-name) 2>/dev/null
        sys_ver=$(dmidecode -s system-version) 2>/dev/null
    else
        sys_manu=""
        sys_product=""
        sys_ver=""
    fi

    if grep docker /proc/1/cgroup -qa; then
        virtual="Docker"
    elif grep lxc /proc/1/cgroup -qa; then
        virtual="Lxc"
    elif grep -qa container=lxc /proc/1/environ; then
        virtual="Lxc"
    elif [[ -f /proc/user_beancounters ]]; then
        virtual="OpenVZ"
    elif [[ "$virtualx" == *kvm-clock* ]]; then
        virtual="KVM"
    elif [[ "$cpu_model_name" == *KVM* ]]; then
        virtual="KVM"
    elif [[ "$cpu_model_name" == *QEMU* ]]; then
        virtual="KVM"
    elif [[ "$virtualx" == *"VMware Virtual Platform"* ]]; then
        virtual="VMware"
    elif [[ "$virtualx" == *"Parallels Software International"* ]]; then
        virtual="Parallels"
    elif [[ "$virtualx" == *VirtualBox* ]]; then
        virtual="VirtualBox"
    elif [[ -e /proc/xen ]]; then
        virtual="Xen"
    elif [[ "$sys_manu" == *"Microsoft Corporation"* ]]; then
        if [[ "$sys_product" == *"Virtual Machine"* ]]; then
            if [[ "$sys_ver" == *"7.0"* || "$sys_ver" == *"Hyper-V" ]]; then
                virtual="Hyper-V"
            else
                virtual="Microsoft Virtual Machine"
            fi
        fi
    else
        virtual="Dedicated"
    fi

    echo ${virtual}
}

# 架构信息  x86 / x64 / aarch64 / arm
GetArch(){
    # local ARCH

    # 确定 Server 架构
    # determine architecture of host
    ARCH=$(uname -m)
    if [[ $ARCH = *x86_64* ]]; then
        # host is running a 64-bit kernel
        ARCH="x64"
    elif [[ $ARCH = *i?86* ]]; then
        # host is running a 32-bit kernel
        ARCH="x86"
    elif [[ $ARCH = *aarch* || $ARCH = *arm* ]]; then
        KERNEL_BIT=`getconf LONG_BIT`
        if [[ $KERNEL_BIT = *64* ]]; then
            # host is running an ARM 64-bit kernel
            ARCH="aarch64"
        else
            # host is running an ARM 32-bit kernel
            ARCH="arm"
        fi
            # ARM 兼容性被认为是*实验性的*。
        echo -e "\nARM compatibility is considered *experimental*"
    else
            # 不支持此架构
        # host is running a non-supported kernel
        echo -e "Architecture not supported by YABS."
        exit 1
    fi

    echo ${ARCH}
}

# 操作系统信息
GetOperatingSystemInfo() {
    [ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
}

# 将硬盘空间单位转换为 G, 并累加起来
calc_disk() {
    local total_size=0
    local array=$@
    for size in ${array[@]}; do
        [ "${size}" == "0" ] && size_tmp=0 || size_tmp=$(echo ${size:0:${#size}-1})
        [ "$(echo ${size:(-1)})" == "K" ] && size=0
        [ "$(echo ${size:(-1)})" == "M" ] && size=$(awk 'BEGIN{printf "%.1f", '$size_tmp' / 1024}')
        [ "$(echo ${size:(-1)})" == "T" ] && size=$(awk 'BEGIN{printf "%.1f", '$size_tmp' * 1024}')
        [ "$(echo ${size:(-1)})" == "G" ] && size=${size_tmp}
        total_size=$(awk 'BEGIN{printf "%.1f", '$total_size' + '$size'}')
    done
    echo ${total_size}
}

# System info
ShowSystemInfo() {
    echo -e "${Green} -------------------------------------------------------------- ${Suffix}"

    echo -e " CPU Model               : ${SkyBlue}$cpu_model_name${Suffix}" | tee -a $log
    echo -e " CPU Cores               : ${Yellow}$cpu_cores Cores ${SkyBlue}$cpu_MHz MHz $os_arch${Suffix}" | tee -a $log
    echo -e " CPU Cache               : ${SkyBlue}$cpu_cache ${Suffix}" | tee -a $log
    echo -e " CPU AES-NI              : $cpu_aes"
    echo -e " CPU VM-x/AMD-V          : $cpu_virt"
    echo -e ""

    echo -e " RAM                     : ${SkyBlue}$ram_used MB / ${Yellow}$ram_total MB ${SkyBlue}($ram_buffer MB Buff)${Suffix}" | tee -a $log
    echo -e " SWAP                    : ${SkyBlue}$swap_used MB / $swap_total MB${Suffix}" | tee -a $log
    echo -e ""

    echo -e " Disk                    : ${SkyBlue}$disk_used_size GB / ${Yellow}$disk_total_size GB ${Suffix}" | tee -a $log
    echo -e ""

    echo -e " OS                      : ${SkyBlue}$os_version${Suffix}" | tee -a $log
    echo -e " OS Architecture         : ${SkyBlue}$os_arch${Suffix}" | tee -a $log
    echo -e " OS virtualization       : ${Yellow}$os_virt${Suffix}" | tee -a $log
    echo -e " OS Kernel               : ${SkyBlue}$os_kernel${Suffix}" | tee -a $log
    echo -e " TCP Congestion Control  : ${Yellow}$tcp_congestion_control${Suffix}" | tee -a $log
    echo -e ""

    echo -e " Uptime                  : ${SkyBlue}$system_uptime${Suffix}" | tee -a $log
    echo -e " Load Average            : ${SkyBlue}$system_load${Suffix}" | tee -a $log

    echo -e "${Green} -------------------------------------------------------------- ${Suffix}"
}

# 新版JSON解析
PharseJSON() {
    # 使用方法: PharseJSON "要解析的原JSON文本" "要解析的键值"
    # Example: PharseJSON ""Value":"123456"" "Value" [返回结果: 123456]
    echo -n $1 | jq -r .$2
}

# 获取网络信息
GetNetworkInfo() {

    # 检查本地 fio/iperf 的安装情况
    # check for local fio/iperf installs
    command -v fio >/dev/null 2>&1 && LOCAL_FIO=true || unset LOCAL_FIO
    command -v iperf3 >/dev/null 2>&1 && LOCAL_IPERF=true || unset LOCAL_IPERF

    # 测试主机是否具有 IPv4/IPv6 连接性
    # test if the host has IPv4/IPv6 connectivity
    IPV4_CHECK=$((ping -4 -c 1 -W 4 ipv4.google.com >/dev/null 2>&1 && echo true) || curl -s -4 -m 4 icanhazip.com 2> /dev/null)
    IPV6_CHECK=$((ping -6 -c 1 -W 4 ipv6.google.com >/dev/null 2>&1 && echo true) || curl -s -6 -m 4 icanhazip.com 2> /dev/null)

    # https://ip-api.com/
    local Result_IPV4="$(curl --user-agent "${UA_LemonBench}" --connect-timeout 10 -fsL4 https://lemonbench-api.ilemonrain.com/ipapi/ipapi.php)"
    local Result_IPV6="$(curl --user-agent "${UA_LemonBench}" --connect-timeout 10 -fsL6 https://lemonbench-api.ilemonrain.com/ipapi/ipapi.php)"
    if [ "${Result_IPV4}" != "" ] && [ "${Result_IPV6}" = "" ]; then
        LBench_Result_NetworkStat="ipv4only"
    elif [ "${Result_IPV4}" = "" ] && [ "${Result_IPV6}" != "" ]; then
        LBench_Result_NetworkStat="ipv6only"
    elif [ "${Result_IPV4}" != "" ] && [ "${Result_IPV6}" != "" ]; then
        LBench_Result_NetworkStat="dualstack"
    else
        LBench_Result_NetworkStat="unknown"
    fi
    if [ "${LBench_Result_NetworkStat}" = "ipv4only" ] || [ "${LBench_Result_NetworkStat}" = "dualstack" ]; then
        IPAPI_IPV4_ip="$(PharseJSON "${Result_IPV4}" "data.ip")"
        local IPAPI_IPV4_country_name="$(PharseJSON "${Result_IPV4}" "data.country")"
        local IPAPI_IPV4_region_name="$(PharseJSON "${Result_IPV4}" "data.province")"
        local IPAPI_IPV4_city_name="$(PharseJSON "${Result_IPV4}" "data.city")"
        IPAPI_IPV4_location="${IPAPI_IPV4_country_name} ${IPAPI_IPV4_region_name} ${IPAPI_IPV4_city_name}"
        IPAPI_IPV4_country_code="$(PharseJSON "${Result_IPV4}" "data.country_code")"
        IPAPI_IPV4_asn="$(PharseJSON "${Result_IPV4}" "data.asn.number")"
        IPAPI_IPV4_organization="$(PharseJSON "${Result_IPV4}" "data.asn.desc")"
    fi
    if [ "${LBench_Result_NetworkStat}" = "ipv6only" ] || [ "${LBench_Result_NetworkStat}" = "dualstack" ]; then
        IPAPI_IPV6_ip="$(PharseJSON "${Result_IPV6}" "data.ip")"
        local IPAPI_IPV6_country_name="$(PharseJSON "${Result_IPV6}" "data.country")"
        local IPAPI_IPV6_region_name="$(PharseJSON "${Result_IPV6}" "data.province")"
        local IPAPI_IPV6_city_name="$(PharseJSON "${Result_IPV6}" "data.city")"
        IPAPI_IPV6_location="${IPAPI_IPV6_country_name} ${IPAPI_IPV6_region_name} ${IPAPI_IPV6_city_name}"
        IPAPI_IPV6_country_code="$(PharseJSON "${Result_IPV6}" "data.country_code")"
        IPAPI_IPV6_asn="$(PharseJSON "${Result_IPV6}" "data.asn.number")"
        IPAPI_IPV6_organization="$(PharseJSON "${Result_IPV6}" "data.asn.desc")"
    fi
    if [ "${LBench_Result_NetworkStat}" = "unknown" ]; then
        IPAPI_IPV4_ip="-"
        IPAPI_IPV4_location="-"
        IPAPI_IPV4_country_code="-"
        IPAPI_IPV4_asn="-"
        IPAPI_IPV4_organization="-"
        IPAPI_IPV6_ip="-"
        IPAPI_IPV6_location="-"
        IPAPI_IPV6_country_code="-"
        IPAPI_IPV6_asn="-"
        IPAPI_IPV6_organization="-"
    fi
}

# 输出网络信息
ShowNetworkInfo() {
    if [ "${LBench_Result_NetworkStat}" = "ipv4only" ] || [ "${LBench_Result_NetworkStat}" = "dualstack" ]; then
        if [ "${IPAPI_IPV4_ip}" != "" ]; then
            echo -e " IPV4 - IP Address       : ${SkyBlue}[${IPAPI_IPV4_country_code}] ${IPAPI_IPV4_ip}${Suffix}"
            echo -e " IPV4 - ASN Info         : ${SkyBlue}AS${IPAPI_IPV4_asn} (${IPAPI_IPV4_organization})${Suffix}"
            echo -e " IPV4 - Region           : ${SkyBlue}${IPAPI_IPV4_location}${Suffix}"
        else
            echo -e " IPV6 - IP Address       : ${Red}Error: API Query Failed${Suffix}"
        fi
    fi
    if [ "${LBench_Result_NetworkStat}" = "ipv6only" ] || [ "${LBench_Result_NetworkStat}" = "dualstack" ]; then
        if [ "${IPAPI_IPV6_ip}" != "" ]; then
            echo -e " IPV6 - IP Address      :${SkyBlue}[${IPAPI_IPV6_country_code}] ${IPAPI_IPV6_ip}${Suffix}"
            echo -e " IPV6 - ASN Info        :${SkyBlue}AS${IPAPI_IPV6_asn} (${IPAPI_IPV6_organization})${Suffix}"
            echo -e " IPV6 - Region          :${SkyBlue}${IPAPI_IPV6_location}${Suffix}"
        else
            echo -e " IPV6 - IP Address      :${Red}Error: API Query Failed${Suffix}"
        fi
    fi

    echo -e "${Green} -------------------------------------------------------------- ${Suffix}"
}

fioTest() {
    # 检查磁盘性能是否被测试，主机是否有所需空间（2G）。
    # check if disk performance is being tested and the host has required space (2G)
    AVAIL_SPACE=$(df -k . | awk 'NR==2{print $4}')
    if [[ -z "$SKIP_FIO" && "$AVAIL_SPACE" -lt 2097152 && "$os_arch" != "aarch64" && "$os_arch" != "arm" ]]; then # 2GB = 2097152KB
        echo -e "\nLess than 2GB of space available. Skipping disk test..."
    elif [[ -z "$SKIP_FIO" && "$AVAIL_SPACE" -lt 524288 && ("$os_arch" = "aarch64" || "$os_arch" = "arm") ]]; then # 512MB = 524288KB
        echo -e "\nLess than 512MB of space available. Skipping disk test..."
    # if the skip disk flag was set, skip the disk performance test, otherwise test disk performance
    elif [ -z "$SKIP_FIO" ]; then
        # Perform ZFS filesystem detection and determine if we have enough free space according to spa_asize_inflation
        ZFSCHECK="/sys/module/zfs/parameters/spa_asize_inflation"
        if [[ -f "$ZFSCHECK" ]]; then
            mul_spa=$((($(cat /sys/module/zfs/parameters/spa_asize_inflation) * 2)))
            warning=0
            poss=()

            for pathls in $(df -Th | awk '{print $7}' | tail -n +2); do
                if [[ "${PWD##$pathls}" != "${PWD}" ]]; then
                    poss+=($pathls)
                fi
            done

            long=""
            m=-1
            for x in ${poss[@]}; do
                if [ ${#x} -gt $m ]; then
                    m=${#x}
                    long=$x
                fi
            done

            size_b=$(df -Th | grep -w $long | grep -i zfs | awk '{print $5}' | tail -c 2 | head -c 1)
            free_space=$(df -Th | grep -w $long | grep -i zfs | awk '{print $5}' | head -c -2)

            if [[ $size_b == 'T' ]]; then
                free_space=$(bc <<<"$free_space*1024")
                size_b='G'
            fi

            if [[ $(df -Th | grep -w $long) == *"zfs"* ]]; then

                if [[ $size_b == 'G' ]]; then
                    if [[ $(echo "$free_space < $mul_spa" | bc) -ne 0 ]]; then
                        warning=1
                    fi
                else
                    warning=1
                fi

            fi

            if [[ $warning -eq 1 ]]; then
                echo -en "\nWarning! You are running YABS on a ZFS Filesystem and your disk space is too low for the fio test. Your test results will be inaccurate. You need at least $mul_spa GB free in order to complete this test accurately. For more information, please see https://github.com/masonr/yet-another-bench-script/issues/13\n"
            fi
        fi

        echo -en "\nPreparing system for disk tests..."

        # create temp directory to store disk write/read test files
        DISK_PATH=$ROOT_PATH/disk
        mkdir -p $DISK_PATH

        if [[ -z "$PREFER_BIN" && ! -z "$LOCAL_FIO" ]]; then # local fio has been detected, use instead of pre-compiled binary
            FIO_CMD=fio
        else
            # download fio binary
            if [ ! -z "$IPV4_CHECK" ]; then # if IPv4 is enabled
                curl -s -4 --connect-timeout 5 --retry 5 --retry-delay 0 https://raw.githubusercontent.com/masonr/yet-another-bench-script/master/bin/fio/fio_$os_arch -o $DISK_PATH/fio
            else # no IPv4, use IPv6 - below is necessary since raw.githubusercontent.com has no AAAA record
                curl -s -6 --connect-timeout 5 --retry 5 --retry-delay 0 -k -g --header 'Host: raw.githubusercontent.com' https://[2a04:4e42::133]/masonr/yet-another-bench-script/master/bin/fio/fio_$os_arch -o $DISK_PATH/fio
            fi

            if [ ! -f "$DISK_PATH/fio" ]; then # ensure fio binary download successfully
                echo -en "\r\033[0K"
                echo -e "Fio binary download failed. Running dd test as fallback...."
                DD_FALLBACK=True
            else
                chmod +x $DISK_PATH/fio
                FIO_CMD=$DISK_PATH/fio
            fi
        fi

        if [ -z "$DD_FALLBACK" ]; then # if not falling back on dd tests, run fio test
            echo -en "\r\033[0K"

            # init global array to store disk performance values
            declare -a DISK_RESULTS
            # disk block sizes to evaluate
            BLOCK_SIZES=("4k" "64k" "512k" "1m")

            # execute disk performance test
            disk_test "${BLOCK_SIZES[@]}"
        fi

        if [[ ! -z "$DD_FALLBACK" || ${#DISK_RESULTS[@]} -eq 0 ]]; then # fio download failed or test was killed or returned an error, run dd test instead
            if [ -z "$DD_FALLBACK" ]; then                              # print error notice if ended up here due to fio error
                echo -e "fio disk speed tests failed. Run manually to determine cause.\nRunning dd test as fallback..."
            fi

            dd_test

            # format the speed averages by converting to GB/s if > 1000 MB/s
            if [ $(echo $DISK_WRITE_TEST_AVG | cut -d "." -f 1) -ge 1000 ]; then
                DISK_WRITE_TEST_AVG=$(awk -v a="$DISK_WRITE_TEST_AVG" 'BEGIN { print a / 1000 }')
                DISK_WRITE_TEST_UNIT="GB/s"
            else
                DISK_WRITE_TEST_UNIT="MB/s"
            fi
            if [ $(echo $DISK_READ_TEST_AVG | cut -d "." -f 1) -ge 1000 ]; then
                DISK_READ_TEST_AVG=$(awk -v a="$DISK_READ_TEST_AVG" 'BEGIN { print a / 1000 }')
                DISK_READ_TEST_UNIT="GB/s"
            else
                DISK_READ_TEST_UNIT="MB/s"
            fi

            # print dd sequential disk speed test results
            echo -e
            echo -e "dd Sequential Disk Speed Tests:"
            echo -e "---------------------------------"
            printf "%-6s | %-6s %-4s | %-6s %-4s | %-6s %-4s | %-6s %-4s\n" "" "Test 1" "" "Test 2" "" "Test 3" "" "Avg" ""
            printf "%-6s | %-6s %-4s | %-6s %-4s | %-6s %-4s | %-6s %-4s\n"
            printf "%-6s | %-11s | %-11s | %-11s | %-6.2f %-4s\n" "Write" "${DISK_WRITE_TEST_RES[0]}" "${DISK_WRITE_TEST_RES[1]}" "${DISK_WRITE_TEST_RES[2]}" "${DISK_WRITE_TEST_AVG}" "${DISK_WRITE_TEST_UNIT}"
            printf "%-6s | %-11s | %-11s | %-11s | %-6.2f %-4s\n" "Read" "${DISK_READ_TEST_RES[0]}" "${DISK_READ_TEST_RES[1]}" "${DISK_READ_TEST_RES[2]}" "${DISK_READ_TEST_AVG}" "${DISK_READ_TEST_UNIT}"
        else # fio tests completed successfully, print results
            DISK_RESULTS_NUM=$(expr ${#DISK_RESULTS[@]} / 6)
            DISK_COUNT=0

            # print disk speed test results
            echo -e "fio Disk Speed Tests (Mixed R/W 50/50):"
            echo -e "---------------------------------"

            while [ $DISK_COUNT -lt $DISK_RESULTS_NUM ]; do
                if [ $DISK_COUNT -gt 0 ]; then printf "%-10s | %-20s | %-20s\n"; fi
                printf "%-10s | %-11s %8s | %-11s %8s\n" "Block Size" "${BLOCK_SIZES[DISK_COUNT]}" "(IOPS)" "${BLOCK_SIZES[DISK_COUNT + 1]}" "(IOPS)"
                printf "%-10s | %-11s %8s | %-11s %8s\n" "  ------" "---" "---- " "----" "---- "
                printf "%-10s | %-11s %8s | %-11s %8s\n" "Read" "${DISK_RESULTS[DISK_COUNT * 6 + 1]}" "(${DISK_RESULTS[DISK_COUNT * 6 + 4]})" "${DISK_RESULTS[(DISK_COUNT + 1) * 6 + 1]}" "(${DISK_RESULTS[(DISK_COUNT + 1) * 6 + 4]})"
                printf "%-10s | %-11s %8s | %-11s %8s\n" "Write" "${DISK_RESULTS[DISK_COUNT * 6 + 2]}" "(${DISK_RESULTS[DISK_COUNT * 6 + 5]})" "${DISK_RESULTS[(DISK_COUNT + 1) * 6 + 2]}" "(${DISK_RESULTS[(DISK_COUNT + 1) * 6 + 5]})"
                printf "%-10s | %-11s %8s | %-11s %8s\n" "Total" "${DISK_RESULTS[DISK_COUNT * 6]}" "(${DISK_RESULTS[DISK_COUNT * 6 + 3]})" "${DISK_RESULTS[(DISK_COUNT + 1) * 6]}" "(${DISK_RESULTS[(DISK_COUNT + 1) * 6 + 3]})"
                DISK_COUNT=$(expr $DISK_COUNT + 2)
            done
        fi
    fi
}

# disk_test
# Purpose: This method is designed to test the disk performance of the host using the partition that the
#          script is being run from using fio random read/write speed tests.
# Parameters:
#          - (none)
disk_test() {
    if [[ "$os_arch" = "aarch64" || "$os_arch" = "arm" ]]; then
        FIO_SIZE=512M
    else
        FIO_SIZE=2G
    fi

    # run a quick test to generate the fio test file to be used by the actual tests
    echo -en "Generating fio test file..."
    $FIO_CMD --name=setup --ioengine=libaio --rw=read --bs=64k --iodepth=64 --numjobs=2 --size=$FIO_SIZE --runtime=1 --gtod_reduce=1 --filename=$DISK_PATH/test.fio --direct=1 --minimal &>/dev/null
    echo -en "\r\033[0K"

    # get array of block sizes to evaluate
    BLOCK_SIZES=("$@")

    for BS in "${BLOCK_SIZES[@]}"; do
        # run rand read/write mixed fio test with block size = $BS
        echo -en "Running fio random mixed R+W disk test with $BS block size..."
        DISK_TEST=$(timeout 35 $FIO_CMD --name=rand_rw_$BS --ioengine=libaio --rw=randrw --rwmixread=50 --bs=$BS --iodepth=64 --numjobs=2 --size=$FIO_SIZE --runtime=30 --gtod_reduce=1 --direct=1 --filename=$DISK_PATH/test.fio --group_reporting --minimal 2>/dev/null | grep rand_rw_$BS)
        DISK_IOPS_R=$(echo $DISK_TEST | awk -F';' '{print $8}')
        DISK_IOPS_W=$(echo $DISK_TEST | awk -F';' '{print $49}')
        DISK_IOPS=$(format_iops $(awk -v a="$DISK_IOPS_R" -v b="$DISK_IOPS_W" 'BEGIN { print a + b }'))
        DISK_IOPS_R=$(format_iops $DISK_IOPS_R)
        DISK_IOPS_W=$(format_iops $DISK_IOPS_W)
        DISK_TEST_R=$(echo $DISK_TEST | awk -F';' '{print $7}')
        DISK_TEST_W=$(echo $DISK_TEST | awk -F';' '{print $48}')
        DISK_TEST=$(format_speed $(awk -v a="$DISK_TEST_R" -v b="$DISK_TEST_W" 'BEGIN { print a + b }'))
        DISK_TEST_R=$(format_speed $DISK_TEST_R)
        DISK_TEST_W=$(format_speed $DISK_TEST_W)

        DISK_RESULTS+=("$DISK_TEST" "$DISK_TEST_R" "$DISK_TEST_W" "$DISK_IOPS" "$DISK_IOPS_R" "$DISK_IOPS_W")
        
        echo -en "\r\033[0K"
    done
}

# dd test
# 如果 fio 磁盘测试失败，则调用此方法。dd 顺序速度测试并不代表真实世界的结果，然而，某种形式的磁盘速度测量 总比没有好。

# dd_test
# Purpose: This method is invoked if the fio disk test failed. dd sequential speed tests are
#          not indiciative or real-world results, however, some form of disk speed measure
#          is better than nothing.
# Parameters:
#          - (none)
dd_test() {
    I=0
    DISK_WRITE_TEST_RES=()
    DISK_READ_TEST_RES=()
    DISK_WRITE_TEST_AVG=0
    DISK_READ_TEST_AVG=0

    # run the disk speed tests (write and read) thrice over
    while [ $I -lt 3 ]; do
        # write test using dd, "direct" flag is used to test direct I/O for data being stored to disk
        DISK_WRITE_TEST=$(dd if=/dev/zero of=$DISK_PATH/$DATE.test bs=64k count=16k oflag=direct |& grep copied | awk '{ print $(NF-1) " " $(NF)}')
        VAL=$(echo $DISK_WRITE_TEST | cut -d " " -f 1)
        [[ "$DISK_WRITE_TEST" == *"GB"* ]] && VAL=$(awk -v a="$VAL" 'BEGIN { print a * 1000 }')
        DISK_WRITE_TEST_RES+=("$DISK_WRITE_TEST")
        DISK_WRITE_TEST_AVG=$(awk -v a="$DISK_WRITE_TEST_AVG" -v b="$VAL" 'BEGIN { print a + b }')

        # read test using dd using the 1G file written during the write test
        DISK_READ_TEST=$(dd if=$DISK_PATH/$DATE.test of=/dev/null bs=8k |& grep copied | awk '{ print $(NF-1) " " $(NF)}')
        VAL=$(echo $DISK_READ_TEST | cut -d " " -f 1)
        [[ "$DISK_READ_TEST" == *"GB"* ]] && VAL=$(awk -v a="$VAL" 'BEGIN { print a * 1000 }')
        DISK_READ_TEST_RES+=("$DISK_READ_TEST")
        DISK_READ_TEST_AVG=$(awk -v a="$DISK_READ_TEST_AVG" -v b="$VAL" 'BEGIN { print a + b }')

        I=$(($I + 1))
    done
    # calculate the write and read speed averages using the results from the three runs
    DISK_WRITE_TEST_AVG=$(awk -v a="$DISK_WRITE_TEST_AVG" 'BEGIN { print a / 3 }')
    DISK_READ_TEST_AVG=$(awk -v a="$DISK_READ_TEST_AVG" 'BEGIN { print a / 3 }')
}

# 格式速度
# 目的：
# 		该方法是一个方便的函数，用于格式化fio磁盘测试的输出，总是以KB/s为单位返回结果。
# 		如果结果>=1 GB/s，则使用GB/s。如果结果<1 GB/s且>=1 MB/s，则使用MB/s。否则，使用KB/s。
# 参数:
# 		1. RAW - 原始磁盘速度结果(KB/s)
# 返回:
# 		格式化后的磁盘速度，单位为GB/s、MB/s或KB/s

# format_speed
# Purpose: This method is a convenience function to format the output of the fio disk tests which
#          always returns a result in KB/s. If result is >= 1 GB/s, use GB/s. If result is < 1 GB/s
#          and >= 1 MB/s, then use MB/s. Otherwise, use KB/s.
# Parameters:
#          1. RAW - the raw disk speed result (in KB/s)
# Returns:
#          Formatted disk speed in GB/s, MB/s, or KB/s
format_speed() {
    # 磁盘速度（KB/s
    RAW=$1 # disk speed in KB/s
    RESULT=$RAW
    local DENOM=1
    local UNIT="KB/s"

    # 确保原始值不是空的，如果是，则返回空白
    # ensure raw value is not null, if it is, return blank
    if [ -z "$RAW" ]; then
        echo ""
        return 0
    fi

    # 检查磁盘速度是否>=1GB/s
    # check if disk speed >= 1 GB/s
    if [ "$RAW" -ge 1000000 ]; then
        DENOM=1000000
        UNIT="GB/s"
    # 检查磁盘速度是否<1 GB/s && >= 1 MB/s
    # check if disk speed < 1 GB/s && >= 1 MB/s
    elif [ "$RAW" -ge 1000 ]; then
        DENOM=1000
        UNIT="MB/s"
    fi

    # 除去原始结果，得到相应的格式化结果（根据确定的单位）。
    # divide the raw result to get the corresponding formatted result (based on determined unit)
    RESULT=$(awk -v a="$RESULT" -v b="$DENOM" 'BEGIN { print a / b }')
    # 将格式化的结果缩短到小数点后两位（即x.xx）。
    # shorten the formatted result to two decimal places (i.e. x.xx)
    RESULT=$(echo $RESULT | awk -F. '{ printf "%0.2f",$1"."substr($2,1,2) }')
    # 将格式化的结果值与单位相连接并返回结果
    # concat formatted result value with units and return result
    RESULT="$RESULT $UNIT"
    echo $RESULT
}

# format_iops
# Purpose: This method is a convenience function to format the output of the raw IOPS result
# Parameters:
#          1. RAW - the raw IOPS result
# Returns:
#          Formatted IOPS (i.e. 8, 123, 1.7k, 275.9k, etc.)
format_iops() {
    RAW=$1 # iops
    RESULT=$RAW

    # ensure raw value is not null, if it is, return blank
    if [ -z "$RAW" ]; then
        echo ""
        return 0
    fi

    # check if IOPS speed > 1k
    if [ "$RAW" -ge 1000 ]; then
        # divide the raw result by 1k
        RESULT=$(awk -v a="$RESULT" 'BEGIN { print a / 1000 }')
        # shorten the formatted result to one decimal place (i.e. x.x)
        RESULT=$(echo $RESULT | awk -F. '{ printf "%0.1f",$1"."substr($2,1,1) }')
        RESULT="$RESULT"k
    fi

    echo $RESULT
}

# =============== 检查 JSON Query 组件 ===============
SystemInfo_GetOSRelease() {
    if [ -f "/etc/centos-release" ]; then # CentOS
        Var_OSRelease="centos"
        local Var_OSReleaseFullName="$(cat /etc/os-release | awk -F '[= "]' '/PRETTY_NAME/{print $3,$4}')"
        if [ "$(rpm -qa | grep -o el6 | sort -u)" = "el6" ]; then
            Var_CentOSELRepoVersion="6"
            local Var_OSReleaseVersion="$(cat /etc/centos-release | awk '{print $3}')"
        elif [ "$(rpm -qa | grep -o el7 | sort -u)" = "el7" ]; then
            Var_CentOSELRepoVersion="7"
            local Var_OSReleaseVersion="$(cat /etc/centos-release | awk '{print $4}')"
        elif [ "$(rpm -qa | grep -o el8 | sort -u)" = "el8" ]; then
            Var_CentOSELRepoVersion="8"
            local Var_OSReleaseVersion="$(cat /etc/centos-release | awk '{print $4}')"
        else
            local Var_CentOSELRepoVersion="unknown"
            local Var_OSReleaseVersion="<Unknown Release>"
        fi
        local Var_OSReleaseArch="$(arch)"
        LBench_Result_OSReleaseFullName="$Var_OSReleaseFullName $Var_OSReleaseVersion ($Var_OSReleaseArch)"
    elif [ -f "/etc/redhat-release" ]; then # RedHat
        Var_OSRelease="rhel"
        local Var_OSReleaseFullName="$(cat /etc/os-release | awk -F '[= "]' '/PRETTY_NAME/{print $3,$4}')"
        if [ "$(rpm -qa | grep -o el6 | sort -u)" = "el6" ]; then
            Var_RedHatELRepoVersion="6"
            local Var_OSReleaseVersion="$(cat /etc/redhat-release | awk '{print $3}')"
        elif [ "$(rpm -qa | grep -o el7 | sort -u)" = "el7" ]; then
            Var_RedHatELRepoVersion="7"
            local Var_OSReleaseVersion="$(cat /etc/redhat-release | awk '{print $4}')"
        elif [ "$(rpm -qa | grep -o el8 | sort -u)" = "el8" ]; then
            Var_RedHatELRepoVersion="8"
            local Var_OSReleaseVersion="$(cat /etc/redhat-release | awk '{print $4}')"
        else
            local Var_RedHatELRepoVersion="unknown"
            local Var_OSReleaseVersion="<Unknown Release>"
        fi
        local Var_OSReleaseArch="$(arch)"
        LBench_Result_OSReleaseFullName="$Var_OSReleaseFullName $Var_OSReleaseVersion ($Var_OSReleaseArch)"
    elif [ -f "/etc/fedora-release" ]; then # Fedora
        Var_OSRelease="fedora"
        local Var_OSReleaseFullName="$(cat /etc/os-release | awk -F '[= "]' '/PRETTY_NAME/{print $3}')"
        local Var_OSReleaseVersion="$(cat /etc/fedora-release | awk '{print $3,$4,$5,$6,$7}')"
        local Var_OSReleaseArch="$(arch)"
        LBench_Result_OSReleaseFullName="$Var_OSReleaseFullName $Var_OSReleaseVersion ($Var_OSReleaseArch)"
    elif [ -f "/etc/lsb-release" ]; then # Ubuntu
        Var_OSRelease="ubuntu"
        local Var_OSReleaseFullName="$(cat /etc/os-release | awk -F '[= "]' '/NAME/{print $3}' | head -n1)"
        local Var_OSReleaseVersion="$(cat /etc/os-release | awk -F '[= "]' '/VERSION/{print $3,$4,$5,$6,$7}' | head -n1)"
        local Var_OSReleaseArch="$(arch)"
        LBench_Result_OSReleaseFullName="$Var_OSReleaseFullName $Var_OSReleaseVersion ($Var_OSReleaseArch)"
        Var_OSReleaseVersion_Short="$(cat /etc/lsb-release | awk -F '[= "]' '/DISTRIB_RELEASE/{print $2}')"
    elif [ -f "/etc/debian_version" ]; then # Debian
        Var_OSRelease="debian"
        local Var_OSReleaseFullName="$(cat /etc/os-release | awk -F '[= "]' '/PRETTY_NAME/{print $3,$4}')"
        local Var_OSReleaseVersion="$(cat /etc/debian_version | awk '{print $1}')"
        local Var_OSReleaseVersionShort="$(cat /etc/debian_version | awk '{printf "%d\n",$1}')"
        if [ "${Var_OSReleaseVersionShort}" = "7" ]; then
            Var_OSReleaseVersion_Short="7"
            Var_OSReleaseVersion_Codename="wheezy"
            local Var_OSReleaseFullName="${Var_OSReleaseFullName} \"Wheezy\""
        elif [ "${Var_OSReleaseVersionShort}" = "8" ]; then
            Var_OSReleaseVersion_Short="8"
            Var_OSReleaseVersion_Codename="jessie"
            local Var_OSReleaseFullName="${Var_OSReleaseFullName} \"Jessie\""
        elif [ "${Var_OSReleaseVersionShort}" = "9" ]; then
            Var_OSReleaseVersion_Short="9"
            Var_OSReleaseVersion_Codename="stretch"
            local Var_OSReleaseFullName="${Var_OSReleaseFullName} \"Stretch\""
        elif [ "${Var_OSReleaseVersionShort}" = "10" ]; then
            Var_OSReleaseVersion_Short="10"
            Var_OSReleaseVersion_Codename="buster"
            local Var_OSReleaseFullName="${Var_OSReleaseFullName} \"Buster\""
        else
            Var_OSReleaseVersion_Short="sid"
            Var_OSReleaseVersion_Codename="sid"
            local Var_OSReleaseFullName="${Var_OSReleaseFullName} \"Sid (Testing)\""
        fi
        local Var_OSReleaseArch="$(arch)"
        LBench_Result_OSReleaseFullName="$Var_OSReleaseFullName $Var_OSReleaseVersion ($Var_OSReleaseArch)"
    elif [ -f "/etc/alpine-release" ]; then # Alpine Linux
        Var_OSRelease="alpinelinux"
        local Var_OSReleaseFullName="$(cat /etc/os-release | awk -F '[= "]' '/NAME/{print $3,$4}' | head -n1)"
        local Var_OSReleaseVersion="$(cat /etc/alpine-release | awk '{print $1}')"
        local Var_OSReleaseArch="$(arch)"
        LBench_Result_OSReleaseFullName="$Var_OSReleaseFullName $Var_OSReleaseVersion ($Var_OSReleaseArch)"
    else
        Var_OSRelease="unknown" # 未知系统分支
        LBench_Result_OSReleaseFullName="[Error: Unknown Linux Branch !]"
    fi
}
SystemInfo_GetSystemBit() {
    local sysarch="$(uname -m)"
    if [ "${sysarch}" = "unknown" ] || [ "${sysarch}" = "" ]; then
        local sysarch="$(arch)"
    fi
    if [ "${sysarch}" = "x86_64" ]; then
        # X86平台 64位
        LBench_Result_SystemBit_Short="64"
        LBench_Result_SystemBit_Full="amd64"
    elif [ "${sysarch}" = "i386" ] || [ "${sysarch}" = "i686" ]; then
        # X86平台 32位
        LBench_Result_SystemBit_Short="32"
        LBench_Result_SystemBit_Full="i386"
    elif [ "${sysarch}" = "armv7l" ] || [ "${sysarch}" = "armv8" ] || [ "${sysarch}" = "armv8l" ] || [ "${sysarch}" = "aarch64" ]; then
        # ARM平台 暂且将32位/64位统一对待
        LBench_Result_SystemBit_Short="arm"
        LBench_Result_SystemBit_Full="arm"
    else
        LBench_Result_SystemBit_Short="unknown"
        LBench_Result_SystemBit_Full="unknown"                
    fi
}
Check_JSONQuery() {
    if [ ! -f "/usr/bin/jq" ]; then
        SystemInfo_GetOSRelease
        SystemInfo_GetSystemBit
        if [ "${LBench_Result_SystemBit_Short}" = "64" ]; then
            local DownloadSrc="https://raindrop.ilemonrain.com/LemonBench/include/JSONQuery/jq-amd64.tar.gz"
            # local DownloadSrc="https://raw.githubusercontent.com/LemonBench/LemonBench/master/Resources/JSONQuery/jq-amd64.tar.gz"
            # local DownloadSrc="https://raindrop.ilemonrain.com/LemonBench/include/jq/1.6/amd64/jq.tar.gz"
        elif [ "${LBench_Result_SystemBit_Short}" = "32" ]; then
            local DownloadSrc="https://raindrop.ilemonrain.com/LemonBench/include/JSONQuery/jq-i386.tar.gz"
            # local DownloadSrc="https://raw.githubusercontent.com/LemonBench/LemonBench/master/Resources/JSONQuery/jq-i386.tar.gz"
            # local DownloadSrc="https://raindrop.ilemonrain.com/LemonBench/include/jq/1.6/i386/jq.tar.gz"
        else
            local DownloadSrc="https://raindrop.ilemonrain.com/LemonBench/include/JSONQuery/jq-i386.tar.gz"
            # local DownloadSrc="https://raw.githubusercontent.com/LemonBench/LemonBench/master/Resources/JSONQuery/jq-i386.tar.gz"
            # local DownloadSrc="https://raindrop.ilemonrain.com/LemonBench/include/jq/1.6/i386/jq.tar.gz"
        fi

        if [ "${Var_OSRelease}" = "centos" ] || [ "${Var_OSRelease}" = "rhel" ]; then
            echo -e "${Msg_Warning}JSON Query Module not found, Installing ..."
            echo -e "${Msg_Info}Installing Dependency ..."

            echo -e "\n${Msg_Info}yum install -y epel-release"
            yum install -y epel-release

            echo -e "\n${Msg_Info}yum install -y jq"
            yum install -y jq

        elif [ "${Var_OSRelease}" = "ubuntu" ] || [ "${Var_OSRelease}" = "debian" ]; then
            echo -e "${Msg_Warning}JSON Query Module not found, Installing ..."
            echo -e "${Msg_Info}Installing Dependency ..."

            echo -e "\n${Msg_Info}apt-get update"
            apt-get update

            echo -e "\n${Msg_Info}apt-get install -y jq"
            apt-get install -y jq

        elif [ "${Var_OSRelease}" = "fedora" ]; then
            echo -e "${Msg_Warning}JSON Query Module not found, Installing ..."
            echo -e "${Msg_Info}Installing Dependency ..."

            echo -e "\n${Msg_Info}dnf install -y jq"
            dnf install -y jq

        elif [ "${Var_OSRelease}" = "alpinelinux" ]; then
            echo -e "${Msg_Warning}JSON Query Module not found, Installing ..."
            echo -e "${Msg_Info}Installing Dependency ..."

            echo -e "\n${Msg_Info}apk update"
            apk update

            echo -e "\n${Msg_Info}apk add jq"
            apk add jq

        else
            echo -e "${Msg_Warning}JSON Query Module not found, Installing ..."
            echo -e "${Msg_Info}Installing Dependency ..."

            echo -e "\n${Msg_Info}apk update"
            apk update

            echo -e "\n${Msg_Info}apk add wget unzip curl"
            apk add wget unzip curl

            echo -e "${Msg_Info}Downloading Json Query Module ..."
            curl --user-agent "${UA_LemonBench}" ${DownloadSrc} -o ${ROOT_PATH}/jq.tar.gz

            echo -e "${Msg_Info}Installing JSON Query Module ..."
            tar xvf ${ROOT_PATH}/jq.tar.gz
            mv ${ROOT_PATH}/jq /usr/bin/jq
            chmod +x /usr/bin/jq
            
            echo -e "${Msg_Info}Cleaning up ..."
            rm -rf ${ROOT_PATH}/jq.tar.gz
        fi
    fi
    # 二次检测
    if [ ! -f "/usr/bin/jq" ]; then
        echo -e "JSON Query Moudle install Failure! Try Restart Bench or Manually install it! (/usr/bin/jq)"
        exit 1
    fi
}

# 主程序
main() {
    # 清屏
    clear

    # 检查 JSONQuery 组件
    Check_JSONQuery

    # 清屏
    clear

    # 输出脚本基本信息
    About

    # 初始化
    Init

    # 获取系统信息
    GetSystemInfo
    # 输出系统信息
    ShowSystemInfo

    # 获取网络信息
    GetNetworkInfo
    # 输出网络信息
    ShowNetworkInfo

    # FIO test
    fioTest

    Complete
}

# 运行主程序
main