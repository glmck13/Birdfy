#!/bin/ksh

rebuild="n"
cd ~/Downloads
typeset -Z2 s
s=0
for v in $(find . -name '*.mp4')
do
	ls -l --time-style=long-iso $v | read x x x x x d t x
	t=${t//:/-}-$s
	scp $v www-data@ubuvaio.lan:/var/www/html/cdn/birdfy/$d-$t.${v##*.}
	rm $v
	let s=$s+1
	rebuild="y"
done

[ "$rebuild" = "y" ] && ssh www-data@ubuvaio.lan '~/bin/birdfy.sh'
