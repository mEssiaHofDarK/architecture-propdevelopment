#!/bin/bash

# Создание пользователей
create_user() {
  local user=$1
  local cert_dir=~/.kube/ssl

  # Создание директории для сертификатов
  mkdir -p "$cert_dir"

  # Генерация сертификата для пользователя
  openssl genrsa -out "$cert_dir/$user.key" 2048
  openssl req -new -key "$cert_dir/$user.key" -out "$cert_dir/$user.csr" -subj "/CN=$user/O=example"
  openssl x509 -req -in "$cert_dir/$user.csr" -signkey "$cert_dir/$user.key" -out "$cert_dir/$user.crt" -days 365

  # Создание контекста для пользователя
  kubectl config set-credentials "$user" --client-certificate="$cert_dir/$user.crt" --client-key="$cert_dir/$user.key"
}

create_user "sesurity"
create_user "devops"
create_user "developer"
