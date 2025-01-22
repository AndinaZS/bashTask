#!/bin/bash
file="access.log"

#проверка существования файла access.log
if [ ! -f "$file" ]; then
  echo "ERROR: file $file does not exists in current directory"
  exit 1
fi

#обработка лога
awk 'BEGIN {
uniqueIP=0
}

{
#собираем уникальные IP
if (!seen[$1]++) uniqueIP+=1

#считаем количество запросов каждого типа
!query[substr($6, 2, 10)]++

#считаем количество обращений к хосту
!host[$7]++
}

END {
#вывод результата
print "Отчет о логе web-сервера"
print "========================"
print "Общее количество запросов: ", NR
print "Количество уникальных IP-адресов: ", uniqueIP
print "\nКоличество запросов по методам: "
for (i in query) {print query[i], i}

#поиск самого популярного url
for (count in host){
  if ( max < host[count] ) {
    max = host[count];
    maxhost = count; }
}
print "Самый популярный URL: ", max, maxhost
}
' $file > report.txt
echo "Отчет сохранен в файл report.txt"

