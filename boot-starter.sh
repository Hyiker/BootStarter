#!/bin/bash
# 文件中的所有路径已经写死 以后会修改为灵活变化

ApplicationName="hyikercom"
filename=$(ls -t /root/hyikercom/*.jar | head -n1 | awk '{print $0}')
if [ "$1" = "" ]; then
    echo -e "\033[0;31m 请输入操作 \033[0m  \033[0;34m {start|stop|restart|status|switch} \033[0m"
    exit 1
fi
# 开始
function start() {
    count=$(ps -ef | grep java | grep $ApplicationName | grep -v grep | wc -l)
    if [ $count != 0 ]; then
        echo "$ApplicationName 已经启动..."
    else
        echo "启动 $ApplicationName 成功..."
        nohup java -jar $filename >/root/$ApplicationName/$ApplicationName.log 2>&1 &
    fi
    echo -e "\033[0;34m tail -10f $ApplicationName/$ApplicationName.log \033[0m"
}

# 停止
function stop() {
    echo "停止 $ApplicationName 的进程"
    boot_id=$(ps -ef | grep java | grep $ApplicationName | grep -v grep | awk '{print $2}')
    count=$(ps -ef | grep java | grep $ApplicationName | grep -v grep | wc -l)

    if [ $count != 0 ]; then
        kill $boot_id
        count=$(ps -ef | grep java | grep $ApplicationName | grep -v grep | wc -l)

        boot_id=$(ps -ef | grep java | grep $ApplicationName | grep -v grep | awk '{print $2}')
        kill -9 $boot_id
    fi
}

# 重启
function restart() {
    stop
    sleep 2
    start
}

# 状态
function status() {
    count=$(ps -ef | grep java | grep $ApplicationName | grep -v grep | wc -l)
    if [ $count != 0 ]; then
        echo "$ApplicationName 正在运行..."
    else
        echo "$ApplicationName 没有在运行..."
    fi
}

# 切换
function switch() {
    stop
    using="$filename"
    if [ "$1" != "" ]; then
        using="/root/$ApplicationName/$ApplicationName-$1.jar"
    fi
    echo "正在启动 $using"
    nohup java -jar $using >/root/$ApplicationName/$ApplicationName.log 2>&1 &
    echo "启动 $using 成功"
    echo -e "\033[0;34m tail -10f $ApplicationName/$ApplicationName.log \033[0m"
}
case $1 in
start)
    start
    ;;
stop)
    stop
    ;;
restart)
    restart
    ;;
status)
    status
    ;;
switch)
    switch $2
    ;;
*) ;;
esac

