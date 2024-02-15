# shell script to compare compression ratios of Pigzj and gzip
# Usage: ./compression.sh
# Output: compression.txt

#!/bin/bash
javac *.java
file_size=$(wc -c <large.txt)
pigzj_size=$(java Pigzj <large.txt | wc -c)
gzip_size=$(gzip -c large.txt | wc -c)
pigz_size=$(pigz -c large.txt | wc -c)
echo "Compression ratios of Pigzj and gzip" >compression.txt
echo "File size: $file_size" >>compression.txt
echo "Pigzj: " >>compression.txt
echo "      size: $pigzj_size" >>compression.txt
echo "gzip: " >>compression.txt
echo "      size: $gzip_size" >>compression.txt
echo "pigz: " >>compression.txt
echo "      size: $pigz_size" >>compression.txt
