#!/bin/bash
let total=$(texcount -merge main.tex | awk '/Words in text:/ {print $4}')+$(texcount -merge main.tex | awk '/Words in headers:/ {print $4}')+$(texcount -merge main.tex | awk '/Words outside text/ {print $6}'); echo $total