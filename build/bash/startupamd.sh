#!/usr/bin/env bash 
#SWARM is open-source software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#SWARM is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.

[[ -e /usr/lib/x86_64-linux-gnu/libcurl-compat.so.3.0.0 ]] && export LD_PRELOAD=libcurl-compat.so.3.0.0

screen -S $2 -d -m
sleep .25
screen -S $2 -X logfile $4
sleep .25
screen -S $2 -X logfile flush 5
sleep .25
screen -S $2 -X log
sleep .25
screen -S $2 -X stuff $"export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$5\n"
screen -S $2 -X stuff $"export GPU_MAX_HEAP_SIZE=100\n"
screen -S $2 -X stuff $"export GPU_USE_SYNC_OBJECTS=1\n"
screen -S $2 -X stuff $"export GPU_SINGLE_ALLOC_PERCENT=100\n"
screen -S $2 -X stuff $"export GPU_MAX_ALLOC_PERCENT=100\n"
sleep .25
screen -S $2 -X stuff $"cd\n"
sleep .25
screen -S $2 -X stuff $"cd $1\n"
sleep .25
screen -S $2 -X stuff $"$(< $3/config.sh)\n"