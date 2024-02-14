#!/bin/bash

javac *.java
echo this is a test | java -cp . Pigzj >t.gz
gunzip -c t.gz
