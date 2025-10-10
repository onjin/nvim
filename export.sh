#!/usr/bin/env bash
rm -f export.txt
eza --tree > export.txt
for file in $(find . -type f|grep -v .git|grep -v export.txt); do
    echo "# {$file}" >> export.txt
    cat ${file} >> export.txt
done

ls -l export.txt

