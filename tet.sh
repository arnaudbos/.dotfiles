#!/bin/bash
if [ $# -gt 1 ]
then
    name=$2
else
    name=$1
fi
echo $name
