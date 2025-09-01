for f in *
do
	if [ -d "$f" ]
	then
		cd $f
		if [ -e driver.xml ]
		then
			./../buildPO.py
		fi
		cd ..
	fi
done
