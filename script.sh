#!/bin/bash

# Ruta del archivo CSV en el sistema de archivos de Windows
csv_file="/c/Nombres.csv"

# Definir la URL del servicio
URL="https://negui.com.co/logs.php"

# Definir el número de solicitudes a enviar
num_requests=1000000

# Obtener el número total de líneas en el archivo CSV
total_lines=$(wc -l < "$csv_file")

# Bucle para enviar solicitudes POST de forma iterativa
for ((i = 1; i <= num_requests; i++)); do
    # Leer una línea aleatoria del archivo CSV
    random_line=$(shuf -i 1-"$total_lines" -n 1)
    name=$(sed -n "${random_line}p" "$csv_file")

    # Generar un número aleatorio entre 4 y 5 para los primeros dígitos (Visa o Mastercard)
    first_digit=$(shuf -i 4-5 -n 1)

    # Generar los siguientes 15 dígitos aleatorios para completar el número de tarjeta de crédito
    other_digits=""
    for ((j = 1; j <= 15; j++)); do
        other_digits="${other_digits}$(shuf -i 0-9 -n 1)"
    done

    # Combinar los primeros dígitos con los demás para formar el número de tarjeta de crédito completo
    ccnumber="$first_digit$other_digits"
    
    # Generar un mes aleatorio entre 1 y 12
    month=$(printf "%02d" $(shuf -i 1-12 -n 1))

    # Generar un año aleatorio entre 2025 y 2030
    year=$(shuf -i 25-30 -n 1)

    # Formatear la fecha de expiración en el formato MM/YY
    expdate="$month/$year"
    
    # Generar un CVV aleatorio entre 000 y 999
    cvv=$(printf "%03d" $(shuf -i 0-999 -n 1))
    
    # Imprimir los valores que se enviarán en la solicitud POST
    echo "Enviando solicitud $i/$num_requests con:"
    echo "ccnumber=$ccnumber"
    echo "expdate=$expdate"
    echo "cvv=$cvv"
    echo "name=$name"
    echo "URL: $URL"

    # Utilizar curl para enviar la solicitud POST con los datos del formulario
    response=$(curl -s -w "%{http_code}" -X POST -d "ccnumber=$ccnumber&expdate=$expdate&cvv=$cvv&name=$name" "$URL")
    echo "Respuesta del servidor: $response"
done

echo "Todas las solicitudes han sido enviadas."
