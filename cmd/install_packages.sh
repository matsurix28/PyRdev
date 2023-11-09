while read line
do
    apt-get install -y $line
done < packages.txt