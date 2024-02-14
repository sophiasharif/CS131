#!/bin/bash

javac *.java
java Pigzj <largefile.txt | gunzip -c
