#!/bin/bash
echo -e "\033[1;34m TraceHunter-Forensic Collector \033[0m"

if [[ $EUID -ne 0 ]]; then
        echo -e "\033[1;31m Este script precisa ser executado como root\033[0m"
        exit 1
fi

COLLECTED_DIR="collected_files"

mkdir -p "$COLLECTED_DIR"

echo -e "\033[1;35m Coletando arquivos do sistema... \033[0m"

echo -e "\033[1;95 Listando informações sobre disco e partições... \033[Om"

lsblk >> $COLLECTED_DIR/disk-info.txt

echo -e "\033[1;95m Coletando informações de rede... \033[0m"

ss >> $COLLECTED_DIR/active_connections.txt

netstat -a -n >> $COLLECTED_DIR/open_ports.txt

echo -e "\033[1;95m Coletando lista de processos... \033[0m"

ps aux >> $COLLECTED_DIR/process_list.txt

echo -e "033[1;95 Coletado logs do sistema... \033[0m"

cp -r /var/log/syslog $COLLECTED_DIR/syslog.log
cp -r /var/log/auth.log $COLLECTED_DIR/auth.log
cp -r /var/log/dmesg $COLLECTED_DIR/dmesg.log

echo -e "\033[1;95m Coletando arquivos de configuração... \033[0m"

cp -r /etc $COLLECTED_DIR/backup

echo -e "\033[1;95 Listando o diretório raiz... \033[0m"

HOSTNAME=$(hostname)

date "+%Y-%M-%D %H:%M:%S"

tar -czf "TraceHunter_${HOSTNAME}_${DATAHORA}.taz.gz" "COLLECTED_DIR"
