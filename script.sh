#!/bin/bash

set -o noglob

OLD_IFS=''
CONFIG="config.myconfig"

DEBUG=true
TEMP_FILES=""
WORK_FILES=""
WORK_DIR=""
COMMAND=""
PARANS=""
MODE=""
ARGS=""

DEF_CONFIG="debug=false

tempFiles=*.log

workFiles=*.txt

workDir=.

command=grep error* last.txt > last.log"

FILE_NAME=`basename $0`

INTERACTIVE_HELP="Команды интерактивного режима:
    help            Вывести справку интерактивного режима
    big_help        Вывести полную справку
    temp_print      Вывести список расширений временных файлов
    temp_new        Заново задать список расширений временных файлов
    temp_add        Добавить элемент в список расширений временных файлов
    temp_remove     Удалить элемент из списка расширений временных файлов
    temp_clear      Удалить временные файлы
    temp_list       Просмотреть объём каждого временного файла
    work_print      Вывести список расширений рабочих файлов
    work_new        Заново задать список расширений рабочих файлов
    work_add        Добавить элемент в список расширений рабочих файлов
    work_remove     Удалить элемент из списка расширений рабочих файлов
    work_list       Просмотреть число строк и слов в каждом рабочем файле
    command_print   Вывести команду скрипта
    command_new     Задать команду скрипта
    command_execute Выполнить команду скрипта
    wd_print        Вывести рабочую папку
    wd_new          Задать заново рабочую папку
Примеры использования в интерактивном режиме:
    Вывод списка расширений временных файлов:
        temp_print
    Добавление элемента в список расширений рабочих файлов:
        work_add *.txt
    Задание с нуля списка расширений рабочих файлов:
        work_set *.txt;*.database;*.save
    Удаление четвёртого элемента из списка расширений временных файлов:
        temp_remove 3
Для запуска в тихом режиме необходимо указать ключ, подробнее: $FILE_NAME -h"

HELP="Использование: $FILE_NAME [ПАРАМЕТР][РЕЖИМ] [АРГУМЕНТЫ]...
Позволяет производить работу с файлами и запускать сохранённые команды
В случае отсутствия аргументов будет запущен режим работы через меню
    -h              Вывести сокращенную справку тихого режима
    -H              Вывести полную справку
    -t              Редактирование списка расширений временных файлов, необходимо указать один из режимов: p, n, a, r
    -w              Редактирование списка расширений рабочих файлов, необходимо указать один из режимов: p, n, a, r
    -d              Редактирование рабочей папки, необходимо указать один иж режимов: p, n
    -f              Удалить временные файлы
    -c              Работа с записанной командой, необходимо указать один из режимов: x, p, n
    -l              Вывести число строк и слов в каждом рабочем файле
    -g              Просмотреть объём каждого временного файла
Доступные режимы:
    -p              Вывести значение
    -n              Задать значение заново, требуется передать новое значение как аргумент
    -a              Добавить элемент к списку значений, требуется передать добавляемое значение как аргумент
    -r              Удалить элемент по номеру из списка значений, требуется передать индекс удаляемого элемента
    -x              Выполнить команду
Примеры использования в тихом режиме:
    Вывод выбранной рабочей папки:
        $FILE_NAME -dp
    Задание списка расширений рабочих файлов:
        $FILE_NAME -wn *.txt;*.database;*.save
    Удаление первого расширения из списка расширений временных файлов:
        $FILE_NAME -tr 0
    Добавление расширения в список рабочих файлов:
        $FILE_NAME -wa *.txt
    Выполнение сохранённой команды:
        $FILE_NAME -cx
    Удаление временных файлов:
        $FILE_NAME -f"

BIG_HELP="Использование: $FILE_NAME [ПАРАМЕТР][РЕЖИМ] [АРГУМЕНТЫ]...
Позволяет производить работу с файлами и запускать сохранённые команды
В случае отсутствия аргументов будет запущен режим работы через меню
Доступные параметры:
    -h              Вывести сокращенную справку тихого режима
    -H              Вывести полную справку
    -t              Редактирование списка расширений временных файлов, необходимо указать один из режимов: p, n, a, r
    -w              Редактирование списка расширений рабочих файлов, необходимо указать один из режимов: p, n, a, r
    -d              Редактирование рабочей папки, необходимо указать один иж режимов: p, n
    -f              Удалить временные файлы
    -c              Работа с записанной командой, необходимо указать один из режимов: x, p, n
    -l              Вывести число строк и слов в каждом рабочем файле
    -g              Просмотреть объём каждого временного файла
Доступные режимы:
    -p              Вывести значение
    -n              Задать значение заново, требуется передать новое значение как аргумент
    -a              Добавить элемент к списку значений, требуется передать добавляемое значение как аргумент
    -r              Удалить элемент по номеру из списка значений, требуется передать индекс удаляемого элемента
    -x              Выполнить команду
Примеры использования в тихом режиме:
    Вывод выбранной рабочей папки:
        $FILE_NAME -dp
    Задание списка расширений рабочих файлов:
        $FILE_NAME -wn *.txt;*.database;*.save
    Удаление первого расширения из списка расширений временных файлов:
        $FILE_NAME -tr 0
    Добавление расширения в список рабочих файлов:
        $FILE_NAME -wa *.txt
    Выполнение сохранённой команды:
        $FILE_NAME -cx
    Удаление временных файлов:
        $FILE_NAME -f
Интерактивный режим может быть активирован через режим работы с меню путём выбора соответствующей команды.
Команды интерактивного режима:
    help            Вывести справку интерактивного режима
    big_help        Вывести полную справку
    temp_print      Вывести список расширений временных файлов
    temp_new        Заново задать список расширений временных файлов
    temp_add        Добавить элемент в список расширений временных файлов
    temp_remove     Удалить элемент из списка расширений временных файлов
    temp_clear      Удалить временные файлы
    temp_list       Просмотреть объём каждого временного файла
    work_print      Вывести список расширений рабочих файлов
    work_new        Заново задать список расширений рабочих файлов
    work_add        Добавить элемент в список расширений рабочих файлов
    work_remove     Удалить элемент из списка расширений рабочих файлов
    work_list       Просмотреть число строк и слов в каждом рабочем файле
    command_print   Вывести команду скрипта
    command_new     Задать команду скрипта
    command_execute Выполнить команду скрипта
    wd_print        Вывести рабочую папку
    wd_new          Задать заново рабочую папку
    exit            Завершить интерактивную сессию и вернуться к меню
Примеры использования в интерактивном режиме:
    Вывод списка расширений временных файлов:
        temp_print
    Добавление элемента в список расширений рабочих файлов:
        work_add *.txt
    Задание с нуля списка расширений рабочих файлов:
        work_set *.txt:*.database:*.save
    Удаление четвёртого элемента из списка расширений временных файлов:
        temp_remove 3
        "

MENU="Доступные опции:
    1. Вывести список расширений временных файлов
    2. Заново задать список расширений временных файлов
    3. Добавить элемент в список расширений временных файлов
    4. Удалить элемент из списка расширений временных файлов
    5. Удалить временные файлы
    6. Просмотреть объём каждого временного файла
    7. Вывести список расширений рабочих файлов
    8. Заново задать список расширений рабочих файлов
    9. Добавить элемент в список расширений рабочих файлов
    10. Удалить элемент из списка расширений рабочих файлов
    11. Просмотреть число строк и слов в каждом рабочем файле
    12. Вывести команду скрипта
    13. Задать команду скрипта
    14. Выполнить команду скрипта
    15. Вывести рабочую папку
    16. Задать заново рабочую папку
    17. Завершить сессию скрипта
    18. Перейти в интерактивный режим
"

set_ifs(){
    OLD_IFS=$IFS
    IFS=$1
}

restore_ifs(){
    IFS=$OLD_IFS
}

upload_config(){
    set_ifs ''
    echo "debug=$DEBUG

tempFiles=$TEMP_FILES

workFiles=$WORK_FILES

workDir=$WORK_DIR

command=$COMMAND" > $CONFIG
    restore_ifs
}

save_backup(){
    mv "$CONFIG" "backup_$CONFIG"
}

log_debug(){
    if $DEBUG; then
        echo $1
    fi
}

is_valid_ext(){
    if echo "$1" | grep -Eq "^\*\.[[:alnum:]]+$"; then
        return 0
    fi

    return 1
}

is_valid_list(){
    if echo "$1" | grep -Eq "(^(\*\.[[:alnum:]]+:?)*\*\.[[:alnum:]]+$)|(^$)"; then
        return 0
    fi

    return 1
}

is_number(){
    if echo "$1" | grep -Eq "^[0-9]+$"; then
        return 0
    fi

    return 1
}

is_valid_dir(){
    if [ -d $1 ] && [ -n $1 ]; then
        return 0
    fi

    return 1
}

print_list(){
    if [ $# -eq 2 ]; then
        echo $2
    fi
    count=$(count_elements_in_list $1)
    if [ $count -eq 0 ]; then
        echo "Пусто!"
    else
        set_ifs ':'
        i=0
        for el in $1; do
            i=$(($i+1))
            echo "$i — $el"
        done
        restore_ifs
    fi
}

print_big_help(){
    set_ifs ''
    echo $BIG_HELP
    restore_ifs
}

print_menu(){
    set_ifs ''
    echo $MENU
    restore_ifs
}

print_silent_help(){
    set_ifs ''
    echo $HELP
    restore_ifs
}

print_interactive_help(){
    set_ifs ''
    echo $INTERACTIVE_HELP
    restore_ifs
}

set_temp_files(){
    if ! is_valid_list $1; then
        echo "$1 не является подходящим значением, ознакомьтесь с примерами в справке"
        return 1
    fi

    TEMP_FILES=$1
    upload_config
}

add_temp_files(){
    if ! is_valid_ext $1; then
        echo "$1 не является подходящим значением, ознакомьтесь примерами в справке"
        return 1
    fi

    TEMP_FILES="$TEMP_FILES:$1"
    upload_config
}

set_work_files(){
    if ! is_valid_list $1; then
        echo "$1 не является подходящим значением, ознакомьтесь с примерами в справке"
        return 1
    fi

    WORK_FILES=$1
    upload_config
}

add_work_files(){
    if ! is_valid_ext $1; then
        echo "$1 не является подходящим значением, ознакомьтесь примерами в справке"
        return 1
    fi

    WORK_FILES="$TEMP_FILES:$1"
    upload_config
}

set_working_dir(){
    if is_valid_dir $1 ; then
        WORK_DIR=$1
        echo "Новая рабочая папка скрипта установлена!"
        upload_config
    else
        echo "Вы должны ввести путь к существующей папке!"
        return 1
    fi
}

print_command(){
    echo "Текущая команда скрипта: $COMMAND"
}

print_wd(){
    echo "Текущая рабочая папка: '$WORK_DIR'"
}

set_command(){
    COMMAND=$1
    echo "Новая команда задана!"
    upload_config
}

execute_command(){
    echo "Выполняется команда $COMMAND:"
    eval $COMMAND
}

load_config(){
    if [ ! -f $CONFIG ]; then
        return 2
    fi

    while read line; do
    if echo "$line" | grep -q "^debug" ; then
        DEBUG="$(grep "^debug=" $CONFIG | cut -d= -f2)"
        if [ "$DEBUG" != "false" -a "$DEBUG" != "true" ]; then
            return 1
        fi
    elif echo "$line" | grep -q "^tempFiles" ; then
        TEMP_FILES="$(grep "tempFiles=" $CONFIG | cut -d= -f2)"
        set_ifs ':'
        if ! is_valid_list "$TEMP_FILES" ; then
            return 1
        fi
        restore_ifs
    elif echo "$line" | grep -q "^workFiles" ; then
        WORK_FILES="$(grep "workFiles=" $CONFIG | cut -d= -f2)"
        set_ifs ':'
        if ! is_valid_list "$WORK_FILES" ; then
            return 1
        fi
        restore_ifs
    elif echo "$line" | grep -q "^workDir" ; then
        WORK_DIR="$(grep "workDir=" $CONFIG | cut -d= -f2)"
        if ! is_valid_dir $WORK_DIR ; then
            return 1
        fi
    elif echo "$line" | grep -q "^command" ; then
        COMMAND="$(grep "command=" $CONFIG | cut -d= -f2)"
    fi

    done < $CONFIG
    return 0
}

load_default_config(){
    echo "$DEF_CONFIG" > $CONFIG
    load_config
}

exit_script(){
    echo ""
    echo "Завершение выполнения скрипта..."
    upload_config
    exit 1
}

load_or_gen_config(){
    set_ifs $'\n'

    load_config

    load_status=$?

    if [ $load_status -eq 1 ]; then
        log_debug "Конфиг повреждён, загружаем конфиг по умолчанию и создаём резервную копию старого конфига!"
        save_backup
        load_default_config
    elif [ $load_status -eq 2 ]; then
        log_debug "Конфиг не найден, загружаем конфиг по умолчанию"
        load_default_config
    fi
}



delete_element_by_index(){
    new_elements=""
    i=0
    set_ifs ':'
    for el in $1; do
        i=$(($i+1))
        if ! [ $i -eq $2 ]; then
            if [ -z $new_elements ]; then
                new_elements=$new_elements$el
            else
                new_elements=$new_elements:$el
            fi
        fi
    done
    restore_ifs
    echo $new_elements
}

count_elements_in_list(){
    i=0
    set_ifs ':'

    for el in $1; do
        i=$(($i+1))
    done

    restore_ifs

    echo $i
}

remove_temp_element(){
    count=$(count_elements_in_list $TEMP_FILES)
    pos=$1
    if ! is_number $pos; then
        echo "'$pos' не является числом!"
    elif [ $count -eq 0 ]; then
        echo "Список расширений временных файлов пуст!"
    elif [ $pos -lt 1 -o $pos -gt $count ]; then
        echo "Вы можете удалить элементы только в диапазоне от 1 до $count"
    else
        new=$(delete_element_by_index "$TEMP_FILES" $pos)
        TEMP_FILES=$new
        echo "Элемент на позиции $pos удалён из списка расширений временных файлов!"
    fi
    upload_config
}

remove_work_element(){
    count=$(count_elements_in_list $WORK_FILES)
    pos=$1
    if ! is_number $pos; then
        echo "'$pos' не является числом!"
    elif [ $count -eq 0 ]; then
        echo "Список расширений рабочих файлов пуст!"
    elif [ $pos -lt 1 -o $pos -gt $count ]; then
        echo "Вы можете удалить элементы только в диапазоне от 1 до $count"
    else
        new=$(delete_element_by_index "$WORK_FILES" $pos)
        WORK_FILES=$new
        echo "Элемент на позиции $pos удалён из списка расширений рабочих файлов!"
    fi
    upload_config
}

print_temp_size(){
    count=$(count_elements_in_list $TEMP_FILES)
    if [ $count -eq 0 ]; then
        echo "Список расширений временных файлов пуст!"
    else
        set_ifs ':'
        size_info=''
        for el in $TEMP_FILES; do
            set_ifs ''
            info=$(find $WORK_DIR -type f -name $el -exec du -h {} \;)
            if [ -z $size_info ]; then
                size_info=$info
            else
                size_info=$size_info$'\n'$info
            fi
            restore_ifs
        done
        restore_ifs

        echo 'Размер временных файлов:'
        echo $size_info
    fi
}

delete_temp(){
    count=$(count_elements_in_list $TEMP_FILES)
    if [ $count -eq 0 ]; then
        echo "Список расширений временных файлов пуст!"
    else
        set_ifs ':'
        size_info=''
        for el in $TEMP_FILES; do
            set_ifs ''
            $(find $WORK_DIR -maxdepth 1 -type f -name $el -exec du -h {} \;)
            restore_ifs

            echo "Временные файлы удалены!"
        done
        restore_ifs
    fi
}

print_work_info(){
    count=$(count_elements_in_list $TEMP_FILES)
    if [ $count -eq 0 ]; then
        echo "Список расширений рабочих файлов пуст!"
    else
        set_ifs ':'
        work_info=''
        for el in $WORK_FILES; do
            set_ifs ''
            info=$(find $WORK_DIR -maxdepth 1 -type f -name $el -exec wc -l -w {} \;)
            if [ -z $work_info ]; then
                work_info=$info
            else
                work_info=$work_info$'\n'$info
            fi
            restore_ifs
        done
        restore_ifs

        echo ' Строк Слов    Файл:'
        echo $work_info
    fi
}

run_with_menu(){
    while true; do
        print_menu
        read -r -p "Введите желаемый пункт меню: "
        mode=$REPLY
        if [ -z $mode ]; then
            echo "Данный пункт меню отсутствует!"
            continue
        fi
        if [ $mode == "1" ]; then
            temp_print
        elif [ $mode == "2" ]; then
            read -r -p "Введите новый список расширений временных файлов: "
            temp_new $REPLY
        elif [ $mode == "3" ]; then
            read -r -p "Введите добавляемое расширение временных файлов: "
            temp_add $REPLY
        elif [ $mode == "4" ]; then
            read -r -p "Введите номер расширения временных файлов для удаления: "
            remove_temp_element $REPLY
        elif [ $mode == "5" ]; then
            delete_temp
        elif [ $mode == "6" ]; then
            print_temp_size
        elif [ $mode == "7" ]; then
            work_print
        elif [ $mode == "8" ]; then
            read -r -p "Введите новый список расширений рабочих файлов: "
            work_new $REPLY
        elif [ $mode == "9" ]; then
            read -r -p "Введите добавляемое расширение рабочих файлов: "
            work_add $REPLY
        elif [ $mode == "10" ]; then
            read -r -p "Введите номер расширения рабочих файлов для удаления: "
            remove_work_element $REPLY
        elif [ $mode == "11" ]; then
            print_work_info
        elif [ $mode == "12" ]; then
            print_command
        elif [ $mode == "13" ]; then
            read -r -p "Введите новую команду скрипта: "
            command_new $REPLY
        elif [ $mode == "14" ]; then
            command_execute
        elif [ $mode == "15" ]; then
            print_wd
        elif [ $mode == "16" ]; then
            read -r -p "Введите новую рабочую папку: "
            set_working_dir $REPLY
        elif [ $mode == "17" ]; then
            exit_script
        elif [ $mode == "18" ]; then
            run_interactive
        else
            echo "Данный пункт меню отсутствует!"
        fi
    done
}

run_interactive(){
    while true; do
        count=0
        argument=""
        echo -n " > "
        key=''
        escape_char=$(printf "\u1b")
        while true; do
            read -n 1 key
            printf -v key_code "%d" "'$key"
            if [ $key_code -eq 4 ]; then
                exit_script
            fi
            argument=$argument$key

            if [ "$key" = '' ]; then
                break
            fi
        done
        set_ifs " "
        words=($argument)
        mode=${words[0]}
        argument=${words[@]:1}
        restore_ifs
        if [ -z $mode ]; then
            echo "Команда не найдена, воспользуйтесь командой help для получения справки"
            continue
        fi
        load_or_gen_config
        if [ $mode == "help" ]; then
            print_interactive_help
        elif [ $mode == "big_help" ]; then
            print_big_help
        elif [ $mode == "temp_print" ]; then
            print_list "$TEMP_FILES" "Список временных файлов:"
        elif [ $mode == "temp_new" ]; then
            set_temp_files $argument
        elif [ $mode == "temp_add" ]; then
            add_temp_files $argument
        elif [ $mode == "temp_remove" ]; then
            remove_temp_element $argument
        elif [ $mode == "temp_clear" ]; then
            delete_temp
        elif [ $mode == "temp_list" ]; then
            print_temp_size
        elif [ $mode == "work_print" ]; then
            print_list "$WORK_FILES" "Список рабочих файлов:"
        elif [ $mode == "work_new" ]; then
            set_work_files $argument
        elif [ $mode == "work_add" ]; then
            add_work_files $argument
        elif [ $mode == "work_remove" ]; then
            remove_work_element $argument
        elif [ $mode == "work_list" ]; then
            print_work_info
        elif [ $mode == "command_print" ]; then
            print_command
        elif [ $mode == "command_new" ]; then
            set_command $argument
        elif [ $mode == "command_execute" ]; then
            execute_command
        elif [ $mode == "wd_print" ]; then
            print_wd
        elif [ $mode == "wd_new" ]; then
            set_working_dir $argument
        elif [ $mode == "exit" ]; then
            break
        else
            echo "Команда не найдена, воспользуйтесь командой help для получения справки"
        fi
    done
}

run_silent(){
    mode=$1
    shift
    argument=''
    while [[ -n $1 ]]; do
        echo $1
        if [ -z $argument ]; then
            argument=$1
        else
            argument="$argument $1"
        fi
        shift
    done

    if [ $mode == "-h" ]; then
        print_silent_help
    elif [ $mode == "-H" ]; then
        print_big_help
    elif [ $mode == "-f" ]; then
        delete_temp
    elif [ $mode == "-l" ]; then
        print_temp_size
    elif [ $mode == "-g" ]; then
        print_work_info
    elif [ $mode == "-tp" ]; then
        temp_print
    elif [ $mode == "-tn" ]; then
        temp_new $argument
    elif [ $mode == "-ta" ]; then
        temp_add $argument
    elif [ $mode == "-tr" ]; then
        remove_temp_element $argument
    elif [ $mode == "-wp" ]; then
        work_print
    elif [ $mode == "-wn" ]; then
        work_new $argument
    elif [ $mode == "-wa" ]; then
        work_add $argument
    elif [ $mode == "-wr" ]; then
        remove_work_element $argument
    elif [ $mode == "-dp" ]; then
        print_wd
    elif [ $mode == "-dn" ]; then
        set_working_dir $argument
    elif [ $mode == "-cx" ]; then
        command_execute
    elif [ $mode == "-cp" ]; then
        command_print
    elif [ $mode == "-cn" ]; then
        command_new $argument
    else
        echo "Ошибка, введите подходящий ключ, подробнее: $FILE_NAME -h"
    fi
}

if [ $EUID -eq 0 ]; then
    echo "Скрипт не может быть запущен с правами администратора!"
    exit 1
fi

trap 'exit_script' 1 2 3 9 15

load_or_gen_config

if [ $# -eq 0 ]; then
    run_with_menu
else
    run_silent $@
fi
