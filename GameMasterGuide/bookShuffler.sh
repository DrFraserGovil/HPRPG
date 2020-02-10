#!/bin/bash
xelatex SpellBooks
echo "Bash version ${BASH_VERSION}..."
N=$(pdfinfo SpellBooks.pdf | grep Pages | awk '{print $2}')
N=168

sE="  "

for (( i=1; i <= $N; i+=4))
do
	s=$s""$i
	s=$s","$((i+2))
	s=$s","$((i+1))
	s=$s","$((i+3))","
done
echo $s
pdfjam SpellBooks.pdf	${s::-1} -o sortedBooks.pdf
