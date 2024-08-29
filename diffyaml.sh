#!/bin/bash
# Проверяем, что передано два аргумента
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <file1.yaml> <file2.yaml>"
  exit 1
fi

# Файлы, переданные в качестве аргументов
default_file="$1"
new_file="$2"

# Проверяем, существуют ли файлы
if [ ! -f "$default_file" ]; then
  echo "File $default_file does not exist."
  exit 1
fi

if [ ! -f "$new_file" ]; then
  echo "File $new_file does not exist."
  exit 1
fi
yq -P 'sort_keys(..)' -o=props "$default_file" > /tmp/dyff_temp_file_default
yq -P 'sort_keys(..)' -o=props "$new_file" > /tmp/dyff_temp_file_new

diff /tmp/dyff_temp_file_default /tmp/dyff_temp_file_new| grep -E '^>'|tr -d '>\ '| yq e -p=props

rm /tmp/dyff_temp_file_default
rm /tmp/dyff_temp_file_new
