#/bin/env bash
#一次查询一个单词，多个单词会单做句子翻译
#参数中包含字母，且个数为1，就当做单词查询


if [[ $@ =~ [a-z] ]]&&[[ $# == 1 ]];then
	Input_key=$@
else
	Input_key=$(echo $@| tr -d '\n' | xxd -plain | sed 's/\(..\)/%\1/g'|tr '[a-z]' '[A-Z]') #汉字URL编码
fi

PPRINT(){ #value是list，循环输出
	curl_command="curl -s http://fanyi.youdao.com/openapi.do?keyfrom=easysearch&\
key=64700458&type=data&doctype=json&version=1.1&q=$Input_key"
	Key_word=$($curl_command)  #返回的完整数据
	SEARCH_PATH=$(for argv in $@;do echo -n .$argv;done)
	echo "$Key_word"|jq $SEARCH_PATH|egrep -v '\[|\]'|sed 's/[",]//g'
}

if [ -n "$Input_key" ];then  #有参数
	echo -e "\033[35m【基础翻译】\033[0m"
	PPRINT translation
	echo -e "\033[35m【拼音/音标】\033[0m"
	PPRINT basic phonetic
	# PHRASES=$(echo "$Key_word"|jq .basic.web|egrep -v '\[|\]'|sed 's/[", ]//g')
	echo -e "\033[35m【更多翻译】\033[0m"
	PPRINT basic explains
else
	echo "Input Key_word"
fi
