# compare runtime of Pigzj to number of threads
# Usage: ./num_threads.sh
# Output: num_threads.txt

#!/bin/bash
javac *.java
input=large.txt
pigzj_time=$(time java Pigzj <$input 2>&1 | grep real | awk '{print $2}')
pigzj_threads=$(time java Pigzj <$input 2>&1 | grep real | awk '{print $2}')
echo "Runtime of Pigzj with different number of threads" >num_threads.txt
echo "Pigzj: " >>num_threads.txt
echo "      time: $pigzj_time" >>num_threads.txt
echo "      threads: $pigzj_threads" >>num_threads.txt
