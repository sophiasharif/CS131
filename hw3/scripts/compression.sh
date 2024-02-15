# shell script to compare compression ratios of Pigzj and gzip
# Usage: ./compression.sh
# Output: compression.txt

#!/bin/bash
javac *.java
input=/usr/local/cs/jdk-21.0.2/lib/modules
file_size=$(wc -c <$input)
pigzj_size=$(java Pigzj <$input | wc -c)
gzip_size=$(gzip -c $input | wc -c)
pigz_size=$(pigz -c $input | wc -c)
echo "Compression ratios of Pigzj and gzip" >compression.txt
echo "File size: $file_size" >>compression.txt
echo "Pigzj: " >>compression.txt
echo "      size: $pigzj_size" >>compression.txt
echo "gzip: " >>compression.txt
echo "      size: $gzip_size" >>compression.txt
echo "pigz: " >>compression.txt
echo "      size: $pigz_size" >>compression.txt
