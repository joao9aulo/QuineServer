#!/usr/bin/bash

# URL do arquivo JAR
JAR_URL="localhost:8080"
JAR_NAME="QuineServer.jar"

# Executa o arquivo JAR em segundo plano e armazena o PID
java -jar "$JAR_NAME" & JAR_PID=$!
sleep 1

while true; do
    # Gera um nome de arquivo baseado na data e hora atual ou extrai da URL
    JAR_NAME="arquivo_$(date +%Y%m%d%H%M%S).jar"
    # Ou use: JAR_NAME=$(basename "$JAR_URL")

    # Baixa o arquivo JAR
    echo "Iniciando o download de $JAR_URL..."
    wget -O "$JAR_NAME" "$JAR_URL"

    if [ $? -eq 0 ]; then
        echo "Download concluído com sucesso. Executando $JAR_NAME em segundo plano..."
        
        # Interrompe o processo do arquivo JAR
        echo "Interrompendo o processo do JAR (PID: $JAR_PID)."
        kill $JAR_PID
        # Executa o arquivo JAR em segundo plano e armazena o PID
        java -jar "$JAR_NAME" &
        JAR_PID=$!

        # Aguarda um determinado período antes de interromper o processo do JAR. Exemplo: 60 segundos
        sleep 1



        # Após a execução, você pode optar por remover o arquivo JAR se não for mais necessário
        # rm "$JAR_NAME"

        echo "Processo do JAR interrompido. Aguardando para a próxima execução..."
    else
        echo "Falha no download do arquivo. Tentando novamente..."
    fi

    # Aguarda novamente antes de repetir o processo, se necessário
    sleep 1
done

