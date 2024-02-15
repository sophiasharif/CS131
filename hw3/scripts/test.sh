#!/bin/bash

javac *.java
echo success! | java Pigzj | gunzip -c
