#!/bin/bash

javac *.java
echo this is a test | java Pigzj | gunzip -c
