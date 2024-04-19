# CyberPulse

São um conjunto de códigos e funções que são do futuro kkkkkk
para seu termux e que te permite saber mais a fundo do teu aparelho

# Requisitos
Celular
Internet
Termux v118                                                                                          Conhecimento basico de Linux

## Instalação no Termux

```bash
git clone https://github.com/Zer0G0ld/cyberPulse
```

Agora entre, dê permissão ao arquivo e inicie ele:

```bash
cd CyberPulse
chmod +X info_device.sh
./info_device.sh

## Explicações 

### Baixe o apache 

```bash
apt update -y && apt upgrade -y
clear
pkg install apache
```

acesse o server apache e entre no index.html onde fica o site q rodará em localhost.

Caminho no Termux:

```bash
/data/data/com.termux/files/usr/share/apache2/default-site/htdocs
```
