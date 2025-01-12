#!/bin/ksh

URLHOME="https://mckspot.net:8443/cdn/birdfy"
VARHOME="/var/www/html/cdn/birdfy"

cd $VARHOME
rm -f *-thumb.png
for v in $(find . -name '*.mp4' -ctime -5)
do
	ffmpeg -i $v -vf "select='gte(t,1)',scale=320:-1" -frames:v 1 -update true ${v%.*}-thumb.png
done

>index.html
cat - <<-EOF >>index.html
<html>
<head>
	<title>G's Birdfy Gallery</title>
	<link rel="stylesheet" href="/css/style.min.css">
	<style>
		code {
			background-color: black;
			color: white;
			font-family: "Lucida Console", "Courier New", monospace;
		}
		pre {
			background-color: black;
		}
	</style>
</head>
<body>
<h1>G's Birdfy Gallery</h1>
EOF

echo '<div class="flex four">' >>index.html
for t in $(find . -name '*.png' | sort -r)
do
	t=${t#./}
	print "$t" | IFS="-" read y c d h m s x
	f=$(date --date="$y-$c-$d $h:$m:$s" "+%a %b %-d %r")
	cat - <<-EOF >>index.html
	<div>
	<article class="card">
	<a href="${t%-*}.mp4"><img src="$t"></a>
	<footer>$f</footer>
	</article>
	</div>
	EOF
done
echo '</div>' >>index.html

cat - <<-EOF >>index.html
</body>
</html>
EOF
