#!/bin/bash

javac *.java
echo success! | java Pigzj -p -3 | gunzip -c
