javac *.java
cmp=$(java Pigzj <large.txt | gunzip | cmp - large.txt)
if [ -z "$cmp" ]; then
    echo "Success!"
fi
