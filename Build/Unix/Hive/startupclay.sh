#!/usr/bin/env bash

screen -S $2 -X stuff $"cd\n" 
screen -S $2 -X stuff $"cd $1\n" 
screen -S $2 -X stuff $"$(< $3/config.sh)\n"