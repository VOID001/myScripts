#########################################################################
# File Name: conv_html_to_novel.sh
# Author: VOID_133
# QQ: #########
# mail: ####@gmail.com
# Created Time: Wed 01 Jul 2015 10:46:46 AM CST
#########################################################################
#!/bin/bash

echo "Convert HTML Novel TO text Novel,Just for you XD"
echo "please give me the URL of the HTML novel (sfacg preferred)"
read myurl
echo "Please give your novel a name (Do not need suffix)"
read novel
wget $myurl -O ${novel}.raw
#if ($? == 0) echo "Novel get complete"

#grep '&nbsp;' ${novel}.raw | tee ${novel}.res

sed 's/<br\/>/\
		/g' ${novel}.raw |sed 's/<br \/>/\
			/g'| sed 's/<[[:alpha:]]*>//g'| sed 's/<\/[[:alpha:][:blank:]]*>//g'| sed 's/<.*[[:alpha:][:blank:]].*>//g'| sed '/^$/d' | sed 's///g' | sed 's/\.[[:alpha:][:blank:]]*//g' | sed 's/[a-z]*[!#@$%^&*]*//g' > ${novel}.res

sed -i 's/&nbsp;/ /g' ${novel}.res
sed -i 's/;;;;//g' ${novel}.res
linedel=$(grep '返回目录' ${novel}.res -n | cut -d ':' -f 1)
sed -i "$linedel,$ d" ${novel}.res
linedel=$(grep '举报违规内容' ${novel}.res -n | cut -d ':' -f 1)
sed -i "1,$linedel d" ${novel}.res
mv ${novel}.res ${novel}.txt
rm ${novel}.raw
clear
echo "${novel}.txt is the final converted version ! Happy Reading"
