#!/bin/bash

# Verificar se o Apache está em execução
if pgrep apache2 > /dev/null; then
    echo "O Apache já está em execução. Reiniciando..."
    apachectl restart
else
    echo "O Apache não está em execução. Iniciando..."
    apachectl start
fi

# Configurações
LOG_FILE="$HOME/device_info.log"
CHECK_INTERVAL=300 # 5 minutos em segundos
JSON_FILE="/data/data/com.termux/files/usr/share/apache2/default-site/htdocs/device_info.json"
WEBSITE_DIR="/data/data/com.termux/files/usr/share/apache2/default-site/htdocs"
WEBSITE_HTML="$WEBSITE_DIR/index.html"

# Função para enviar notificação
enviar_notificacao() {
    termux-notification --title "Informações do dispositivo" \
        --content "$1" \
        --priority high \
        --sound \
        --vibrate 1000 \
        --button1 "Abrir Configurações" \
        --button1-action "am start -a android.intent.action.VIEW -n com.android.settings/.Settings" \
        --button2 "Abrir navegador" \
        --button2-action "am start -a android.intent.action.VIEW -n com.android.chrome/com.google.android.apps.chrome.Main http://127.0.0.1:8080"

}

# Função para atualizar o arquivo HTML do site
update_html() {
    cat <<EOF > "$WEBSITE_HTML"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Device Info</title>
    <script>
        function atualizarInformacoes(armazenamento, ram, cpu, modelo) {
            document.getElementById("armazenamento").innerText = "Armazenamento: " + armazenamento;
            document.getElementById("ram").innerText = "RAM: " + ram;                               
            document.getElementById("cpu").innerText = "CPU: " + cpu;
            document.getElementById("modelo").innerText = "Modelo: " + modelo;
        }
    </script>
</head>
<body>
    <h1>Informações do Dispositivo</h1>
    <p id="armazenamento">Armazenamento: Aguardando informações...</p>
    <p id="ram">RAM: Aguardando informações...</p>
    <p id="cpu">CPU: Aguardando informações...</p>
    <p id="modelo">Modelo: Aguardando informações...</p>

    <script>
        atualizarInformacoes("$1", "$2", "$3", "$4");
    </script>
</body>
</html>
EOF
}

while true; do
    # Coleta de informações
    STORAGE=$(df -h | grep '/data' | awk '{print $5}')
    RAM=$(free -h | grep 'Mem' | awk '{print $3}')
    CPU=$(top -n 1 -b | grep 'Cpu(s)' | awk '{print $2}')
    MODEL=$(getprop ro.product.model)

    # Envia notificação com as informações coletadas
    NOTIFICATION_CONTENT="Armazenamento: $STORAGE usado\nRAM: $RAM usada\nCPU: $CPU% em uso\nModelo: $MODEL"
    enviar_notificacao "$NOTIFICATION_CONTENT"
    echo "Notificação Enviada!"

    # Atualiza o arquivo HTML do site
    update_html "$STORAGE" "$RAM" "$CPU" "$MODEL"

    # Aguarda o intervalo de tempo especificado antes da próxima verificação
    sleep "$CHECK_INTERVAL"
done

