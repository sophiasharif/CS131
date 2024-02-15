===== SEASnet CONFIGURATION =====
This section of the report contains information about the congiguration of my SEASnet machine. Listed below are different aspects of its configuration and the commands I ran to find the details.

--- OS Version ---
$ uname -a
Linux lnxsrv13.seas.ucla.edu 4.18.0-348.12.2.el8_5.x86_64 #1 SMP Mon Jan 17 07:06:06 EST 2022 x86_64 GNU/Linux

--- CPU info ---
$ lscpu 
Architecture:        x86_64
CPU op-mode(s):      32-bit, 64-bit
Byte Order:          Little Endian
CPU(s):              4
On-line CPU(s) list: 0-3
Thread(s) per core:  1
Core(s) per socket:  4
Socket(s):           1
NUMA node(s):        1
Vendor ID:           GenuineIntel
CPU family:          6
Model:               85
Model name:          Intel(R) Xeon(R) Silver 4116 CPU @ 2.10GHz
Stepping:            4
CPU MHz:             2095.075
BogoMIPS:            4190.15
Hypervisor vendor:   Microsoft
Virtualization type: full
L1d cache:           32K
L1i cache:           32K
L2 cache:            1024K
L3 cache:            16896K
NUMA node0 CPU(s):   0-3
Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss ht syscall nx pdpe1gb rdtscp lm constant_tsc rep_good nopl xtopology cpuid pni pclmulqdq ssse3 fma cx16 pcid sse4_1 sse4_2 movbe popcnt aes xsave avx f16c rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single pti ibrs ibpb stibp fsgsbase bmi1 hle avx2 smep bmi2 erms invpcid rtm mpx avx512f avx512dq rdseed adx smap clflushopt avx512cd avx512bw avx512vl xsaveopt xsavec xsaves


--- RAM info ---
$ free -h 
              total        used        free      shared  buff/cache   available
Mem:           62Gi        48Gi       6.3Gi        33Mi       8.0Gi        13Gi
Swap:         8.0Gi       2.2Gi       5.8Gi

--- Storage info ---
$ df -h
Filesystem                                    Size  Used Avail Use% Mounted on
devtmpfs                                       32G     0   32G   0% /dev
tmpfs                                          32G     0   32G   0% /dev/shm
tmpfs                                          32G   82M   32G   1% /run
tmpfs                                          32G     0   32G   0% /sys/fs/cgroup
/dev/mapper/vg00-lv_root                      9.8G   89M  9.2G   1% /
/dev/mapper/vg00-lv_usr                        15G  7.2G  6.9G  52% /usr
/dev/mapper/vg00-lv_space                     438G   73M  416G   1% /space
/dev/sda2                                     976M  368M  542M  41% /boot
/dev/sda1                                     256M  5.8M  250M   3% /boot/efi
/dev/mapper/vg00-lv_var                       9.8G  7.4G  1.9G  80% /var
/dev/mapper/vg00-lv_tmp                       9.8G   38M  9.3G   1% /tmp
barlock2.seas.ucla.edu:/vol/vol2/local_rhel8   40G   36G  4.7G  89% /usr/local
barlock2.seas.ucla.edu:/vol/vol2/fac.7         30G  2.3G   28G   8% /w/fac.7
barlock2.seas.ucla.edu:/vol/vol3/home.11      400G  148G  253G  37% /w/home.11
barlock2.seas.ucla.edu:/vol/vol3/class.02      30G   12G   19G  38% /w/class.02
barlock2.seas.ucla.edu:/vol/vol2/home.03      400G  205G  196G  52% /w/home.03
barlock2.seas.ucla.edu:/vol/vol2/fac.8         30G  5.4G   25G  18% /w/fac.8
barlock2.seas.ucla.edu:/vol/vol3/class.1      220G  168G   53G  77% /w/class.1
barlock2.seas.ucla.edu:/vol/vol2/fac.2         30G   16G   15G  54% /w/fac.2
barlock2.seas.ucla.edu:/vol/vol2/home.01      400G  154G  247G  39% /w/home.01
barlock2.seas.ucla.edu:/vol/vol3/home.10      400G  141G  260G  36% /w/home.10
barlock2.seas.ucla.edu:/vol/vol2/home.04      400G  203G  198G  51% /w/home.04
gayley.seas.ucla.edu:/vol/vol4/rtm.1           10G  6.1G  4.0G  61% /w/rtm.1
gayley.seas.ucla.edu:/vol/vol3/seas.2/public   70G   58G   13G  82% /usr/public
barlock.seas.ucla.edu:/vol/vol7/classproj     300G   28G  273G  10% /w/classproj
gayley.seas.ucla.edu:/vol/vol5/class.2        200G   68G  133G  34% /w/class.2
barlock.seas.ucla.edu:/vol/vol6/home.19       400G  147G  254G  37% /w/home.19
barlock.seas.ucla.edu:/vol/vol5/home.14       400G  118G  283G  30% /w/home.14
barlock2.seas.ucla.edu:/vol/vol2/home.02      400G  102G  299G  26% /w/home.02
barlock2.seas.ucla.edu:/vol/vol3/home.18      400G  131G  270G  33% /w/home.18
barlock.seas.ucla.edu:/vol/vol7/home.23       400G   77G  324G  20% /w/home.23
barlock2.seas.ucla.edu:/vol/vol2/home.06      400G  129G  272G  33% /w/home.06
gayley.seas.ucla.edu:/vol/vol1/u/seas/u2      1.0G  576K  1.0G   1% /u
barlock.seas.ucla.edu:/vol/vol6/home.17       400G  163G  238G  41% /w/home.17
barlock2.seas.ucla.edu:/vol/vol2/fac.4         30G  4.3G   26G  15% /w/fac.4
barlock.seas.ucla.edu:/vol/vol7/home.21       400G  113G  288G  29% /w/home.21
barlock.seas.ucla.edu:/vol/vol6/home.20       400G   97G  304G  25% /w/home.20
barlock.seas.ucla.edu:/vol/vol5/home.13       400G  123G  278G  31% /w/home.13
barlock.seas.ucla.edu:/vol/vol7/home.22       400G  134G  267G  34% /w/home.22
barlock2.seas.ucla.edu:/vol/vol2/fac.1         50G   13G   38G  25% /w/fac.1
barlock.seas.ucla.edu:/vol/vol7/home.24       400G   94G  307G  24% /w/home.24
ashton2.seas.ucla.edu:/vol/vol2/home.26       400G  158G  243G  40% /w/home.26
barlock2.seas.ucla.edu:/vol/vol2/home.07      400G  216G  185G  54% /w/home.07
gayley.seas.ucla.edu:/vol/vol5/classapps.01    20G  7.7G   13G  39% /w/classapps.01
ashton2.seas.ucla.edu:/vol/vol2/home.27       400G  135G  266G  34% /w/home.27
barlock2.seas.ucla.edu:/vol/vol2/fac.3         30G  2.9G   28G  10% /w/fac.3
gayley.seas.ucla.edu:/vol/vol3/staff.2         21G  4.5G   17G  22% /w/staff.2
barlock.seas.ucla.edu:/vol/vol5/home.15       400G  130G  271G  33% /w/home.15
barlock2.seas.ucla.edu:/vol/vol2/home.09      400G  114G  287G  29% /w/home.09
barlock.seas.ucla.edu:/vol/vol6/home.16       400G  154G  247G  39% /w/home.16
barlock.seas.ucla.edu:/vol/vol5/home.12       400G  102G  299G  26% /w/home.12
gayley.seas.ucla.edu:/vol/vol3/staff.1         21G  2.5G   19G  12% /w/staff.1
barlock2.seas.ucla.edu:/vol/vol2/home.08      400G  147G  254G  37% /w/home.08
ashton2.seas.ucla.edu:/vol/vol2/home.28       400G   33G  368G   9% /w/home.28
barlock2.seas.ucla.edu:/vol/vol2/fac.6         30G  5.6G   25G  19% /w/fac.6
barlock2.seas.ucla.edu:/vol/vol2/home.05      400G  150G  251G  38% /w/home.05
ashton2.seas.ucla.edu:/vol/vol2/home.25       400G  133G  268G  34% /w/home.25
barlock2.seas.ucla.edu:/vol/vol2/fac.5         30G  3.4G   27G  12% /w/fac.5
barlock.seas.ucla.edu:/vol/vol4/adm.00        973G   51G  923G   6% /w/adm
tmpfs                                         6.3G     0  6.3G   0% /run/user/1106012322
tmpfs                                         6.3G     0  6.3G   0% /run/user/9748
tmpfs                                         6.3G     0  6.3G   0% /run/user/0
tmpfs                                         6.3G     0  6.3G   0% /run/user/14930
tmpfs                                         6.3G     0  6.3G   0% /run/user/10462
tmpfs                                         6.3G  4.0K  6.3G   1% /run/user/1805919722
tmpfs                                         6.3G  4.0K  6.3G   1% /run/user/8689
tmpfs                                         6.3G  4.0K  6.3G   1% /run/user/13830
tmpfs                                         6.3G  4.0K  6.3G   1% /run/user/1506053914
tmpfs                                         6.3G  4.0K  6.3G   1% /run/user/15444
tmpfs                                         6.3G     0  6.3G   0% /run/user/1105311906
tmpfs                                         6.3G  4.0K  6.3G   1% /run/user/16809
tmpfs                                         6.3G     0  6.3G   0% /run/user/15109
tmpfs                                         6.3G  4.0K  6.3G   1% /run/user/1105956925
tmpfs                                         6.3G   12K  6.3G   1% /run/user/1506233878

--- Network setup ---
$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:15:5d:55:41:0c brd ff:ff:ff:ff:ff:ff
    inet 164.67.100.233/24 brd 164.67.100.255 scope global noprefixroute eth0
       valid_lft forever preferred_lft forever


===== CPU COMPARISON OF GZIP, PIGZ, AND PIGZJ =====

To compare the runtimes of these three programs, I ran the following shell script:

---- shell -----
input=/usr/local/cs/jdk-21.0.2/lib/modules
time gzip <$input >gzip.gz
time pigz <$input >pigz.gz
time java Pigzj <$input >Pigzj.gz
ls -l gzip.gz pigz.gz Pigzj.gz

# This checks Pigzj's output.
pigz -d <Pigzj.gz | cmp - $input
---------------

This was the output:

---- (trial 1) -----
real	0m8.442s
user	0m7.747s
sys	0m0.060s

real	0m3.224s
user	0m8.128s
sys	0m0.063s

real	0m3.977s
user	0m7.883s
sys	0m0.571s

---- (trial 2) -----

real	0m8.460s
user	0m7.745s
sys	0m0.084s

real	0m3.265s
user	0m8.122s
sys	0m0.059s

real	0m5.745s
user	0m7.907s
sys	0m0.623s

---- (trial 3) -----

real	0m8.351s
user	0m7.720s
sys	0m0.085s

real	0m3.012s
user	0m8.116s
sys	0m0.070s

real	0m4.727s
user	0m7.891s
sys	0m0.591s



===== COMPRESSION RATIO COMPARISON =====
I used this script to find the sizes in bytes of the outputs of the three compression programs:

----- shell -----
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
-----------------

First, I tried running this script on a 11.44 MB file that was just the word "marshmellow" repeated several times. This was the output:

----- compresion.txt -----
Compression ratios of Pigzj and gzip
File size: 12000000
Pigzj: 
      size: 26587
gzip: 
      size: 23330
pigz: 
      size: 25135
--------------------------

This means that for this file, these were the compression ratios:

---- compression ratios ----
Pigzj: 0.00222
gzip: 0.00194
pigz: 0.00209
----------------------------

Next, I tried the file "/usr/local/cs/jdk-21.0.2/lib/modules" on SEASnet, which is less repetitive than the marshmellow file and more representative of the type of data we might be trying to compress in the real-world. These were the results:

----- compresion.txt -----
File size: 139257677
Pigzj: 
      size: 47952936
gzip: 
      size: 47109901
pigz: 
      size: 47008853
----------------------------

---- compression ratios ----
Pigzj: 0.344
gzip: 0.338
pigz: 0.337
----------------------------

The data indicates that gzip generally achieves the best compression ratio, particularly for less repetitive files, evidenced by its performance on the "/usr/local/cs/jdk-21.0.2/lib/modules" file with a ratio of 0.338, slightly better than pigz at 0.337 and Pigzj at 0.344. However, for highly repetitive content like the "marshmellow" file, the differences are less pronounced but gzip still leads slightly. This suggests gzip is slightly more efficient in compressing diverse file types, while Pigzj and pigz perform comparably with a slight edge for gzip.
