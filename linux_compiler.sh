#!/bin/sh


#设置当前显示字符集
export LANG=C

#当前目录
DIR=`pwd`

#Clean
echo 'make clean'
make clean


#执行cmake
echo 'Cmake Release'
cmake -DCMAKE_BUILD_TYPE=Release .

#执行make指令
echo 'make'
make 2>&1|tee ./compile_out.log

#检查编译输出
echo 'start check compile warning'

#注意这个WARNING，可能导致数据错乱，产生诡异的问题
#尽量完全屏蔽这个WARNING，直接视为ERROR
#warning C4456: declaration of 'i' hides previous local declaration

#由于服务器经常因为类printf参数类型不匹配导致异常宕机，所以加强判断
#先判断是否有printf-like参数类型不匹配的信息
#warning: unknown conversion type character 0x20 in format [-Wformat=]
#上面这个比较特殊，暂不判断是否需要了

#扫描一
ret=$(grep "format" -n ./compile_out.log | grep "expects a matching" | grep "argument")
if [ "$ret" = "" ] 
then
	echo "no expects a matching warning"
else
	echo "${ret}" > ./all_printf_like_warning.txt
fi

#扫描二
ret=$(grep "format" -n ./compile_out.log | grep "unknown conversion type character")
if [ "$ret" = "" ] 
then
	echo "no unknown conversion type character"
else
	echo "${ret}" >> ./all_printf_like_warning.txt
fi

#扫描三
ret=$(grep "format" -n ./compile_out.log | grep "expects argument of type")
echo "${ret}" >> ./all_printf_like_warning.txt
#增加过滤条件
ret=$(
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type 'int'" -n ./all_printf_like_warning.txt |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type 'long int'" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type 'long unsigned int'" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type 'long long int'" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type 'unsigned long long int'" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type 'unsigned long int'" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type 'char[^*]" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type 'unsigned char[^*]" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type 'short[^*]" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type 'unsigned short[^*]" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type 'size_t'" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type 'std::size_t'" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type 'time_t'" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type 'std::time_t'" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type 'float'" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type 'double'" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type 'unsigned int[^*]" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type 'long int[^*]" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type 'long unsigned int[^*]" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type 'unsigned long int[^*]" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type 'long long int[^*]" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type 'unsigned long long int[^*]" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type 'long long[^*]" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type '.*{aka char}" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type '.*{aka unsigned char}" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type '.*{aka short}" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type '.*{aka unsigned short}" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type '.*{aka int}" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type '.*{aka unsigned int}" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type '.*{aka long int}" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type '.*{aka long unsigned int}" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type '.*{aka unsigned long int}" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type '.*{aka long long int}" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type '.*{aka unsigned long long int}" |
	grep -v "format '%lld' expects argument of type 'long long int', but argument [0-9]\+ has type '.*{aka long long}" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'int'" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'long int'" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'long unsigned int'" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'long long int'" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'unsigned long long int'" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'unsigned long int'" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'char[^*]" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'unsigned char[^*]" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'short[^*]" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'unsigned short[^*]" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'size_t'" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'std::size_t'" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'time_t'" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'std::time_t'" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'float'" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'double'" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'unsigned int[^*]" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'long int[^*]" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'long unsigned int[^*]" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'unsigned long int[^*]" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'long long int[^*]" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'unsigned long long int[^*]" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'long long[^*]" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka char}" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka unsigned char}" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka short}" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka unsigned short}" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka int}" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka unsigned int}" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka long int}" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka long unsigned int}" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka unsigned long int}" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka long long int}" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka unsigned long long int}" |
	grep -v "format '%llx' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka long long}" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'int'" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'long int'" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'long unsigned int'" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'long long int'" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'unsigned long long int'" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'unsigned long int'" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'char[^*]" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'unsigned char[^*]" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'short[^*]" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'unsigned short[^*]" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'size_t'" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'std::size_t'" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'time_t'" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'std::time_t'" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'float'" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'double'" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'unsigned int[^*]" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'long int[^*]" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'long unsigned int[^*]" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'unsigned long int[^*]" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'long long int[^*]" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'unsigned long long int[^*]" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'long long[^*]" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka char}" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka unsigned char}" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka short}" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka unsigned short}" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka int}" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka unsigned int}" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka long int}" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka long unsigned int}" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka unsigned long int}" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka long long int}" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka unsigned long long int}" |
	grep -v "format '%llX' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka long long}" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'int'" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'long int'" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'long unsigned int'" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'long long int'" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'unsigned long long int'" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'unsigned long int'" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'char[^*]" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'unsigned char[^*]" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'short[^*]" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'unsigned short[^*]" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'size_t'" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'std::size_t'" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'time_t'" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'std::time_t'" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'float'" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'double'" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'unsigned int[^*]" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'long int[^*]" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'long unsigned int[^*]" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'unsigned long int[^*]" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'long long int[^*]" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'unsigned long long int[^*]" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type 'long long[^*]" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka char}" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka unsigned char}" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka short}" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka unsigned short}" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka int}" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka unsigned int}" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka long int}" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka long unsigned int}" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka unsigned long int}" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka long long int}" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka unsigned long long int}" |
	grep -v "format '%llu' expects argument of type 'long long unsigned int', but argument [0-9]\+ has type '.*{aka long long}" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type 'int'" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type 'long int'" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type 'long unsigned int'" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type 'long long int'" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type 'unsigned long long int'" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type 'char[^*]" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type 'unsigned char[^*]" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type 'short[^*]" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type 'unsigned short[^*]" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type 'size_t'" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type 'std::size_t'" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type 'time_t'" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type 'std::time_t'" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type 'float'" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type 'double'" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type 'unsigned int[^*]" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type 'long int[^*]" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type 'long unsigned int[^*]" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type 'unsigned long int[^*]" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type 'long long int[^*]" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type 'unsigned long long int[^*]" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type 'long long[^*]" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type '.*{aka char}" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type '.*{aka unsigned char}" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type '.*{aka short}" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type '.*{aka unsigned short}" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type '.*{aka int}" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type '.*{aka unsigned int}" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type '.*{aka long int}" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type '.*{aka long unsigned int}" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type '.*{aka unsigned long int}" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type '.*{aka long long int}" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type '.*{aka unsigned long long int}" |
	grep -v "format '%ld' expects argument of type 'long int', but argument [0-9]\+ has type '.*{aka long long}" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type 'int'" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type 'long int'" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type 'long unsigned int'" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type 'long long int'" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type 'unsigned long long int'" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type 'char[^*]" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type 'unsigned char[^*]" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type 'short[^*]" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type 'unsigned short[^*]" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type 'size_t'" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type 'std::size_t'" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type 'time_t'" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type 'std::time_t'" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type 'float'" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type 'double'" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type 'unsigned int[^*]" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type 'long int[^*]" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type 'long unsigned int[^*]" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type 'unsigned long int[^*]" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type 'long long int[^*]" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type 'unsigned long long int[^*]" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type 'long long[^*]" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type '.*{aka char}" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type '.*{aka unsigned char}" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type '.*{aka short}" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type '.*{aka unsigned short}" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type '.*{aka int}" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type '.*{aka unsigned int}" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type '.*{aka long int}" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type '.*{aka long unsigned int}" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type '.*{aka unsigned long int}" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type '.*{aka long long int}" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type '.*{aka unsigned long long int}" |
	grep -v "format '%lu' expects argument of type 'long unsigned int', but argument [0-9]\+ has type '.*{aka long long}" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type 'int'" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type 'long int'" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type 'long unsigned int'" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type 'long long int'" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type 'unsigned long long int'" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type 'char[^*]" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type 'unsigned char[^*]" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type 'short[^*]" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type 'unsigned short[^*]" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type 'size_t'" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type 'std::size_t'" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type 'time_t'" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type 'std::time_t'" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type 'float'" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type 'double'" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type 'unsigned int[^*]" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type 'long int[^*]" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type 'long unsigned int[^*]" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type 'unsigned long int[^*]" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type 'long long int[^*]" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type 'unsigned long long int[^*]" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type 'long long[^*]" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type '.*{aka char}" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type '.*{aka unsigned char}" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type '.*{aka short}" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type '.*{aka unsigned short}" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type '.*{aka int}" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type '.*{aka unsigned int}" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type '.*{aka long int}" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type '.*{aka long unsigned int}" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type '.*{aka unsigned long int}" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type '.*{aka long long int}" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type '.*{aka unsigned long long int}" |
	grep -v "format '%d' expects argument of type 'int', but argument [0-9]\+ has type '.*{aka long long}" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type 'int'" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type 'long int'" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type 'long unsigned int'" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type 'long long int'" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type 'unsigned long long int'" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type 'char[^*]" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type 'unsigned char[^*]" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type 'short[^*]" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type 'unsigned short[^*]" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type 'size_t'" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type 'std::size_t'" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type 'time_t'" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type 'std::time_t'" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type 'float'" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type 'double'" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type 'unsigned int[^*]" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type 'long int[^*]" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type 'long unsigned int[^*]" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type 'unsigned long int[^*]" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type 'long long int[^*]" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type 'unsigned long long int[^*]" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type 'long long[^*]" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type '.*{aka char}" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type '.*{aka unsigned char}" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type '.*{aka short}" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type '.*{aka unsigned short}" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type '.*{aka int}" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type '.*{aka unsigned int}" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type '.*{aka long int}" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type '.*{aka long unsigned int}" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type '.*{aka unsigned long int}" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type '.*{aka long long int}" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type '.*{aka unsigned long long int}" |
	grep -v "format '%u' expects argument of type 'unsigned int', but argument [0-9]\+ has type '.*{aka long long}" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type 'int'" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type 'long int'" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type 'long unsigned int'" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type 'long long int'" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type 'unsigned long long int'" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type 'char[^*]" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type 'unsigned char[^*]" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type 'short[^*]" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type 'unsigned short[^*]" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type 'size_t'" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type 'std::size_t'" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type 'time_t'" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type 'std::time_t'" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type 'float'" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type 'double'" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type 'unsigned int[^*]" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type 'long int[^*]" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type 'long unsigned int[^*]" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type 'unsigned long int[^*]" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type 'long long int[^*]" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type 'unsigned long long int[^*]" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type 'long long[^*]" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type '.*{aka char}" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type '.*{aka unsigned char}" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type '.*{aka short}" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type '.*{aka unsigned short}" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type '.*{aka int}" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type '.*{aka unsigned int}" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type '.*{aka long int}" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type '.*{aka long unsigned int}" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type '.*{aka unsigned long int}" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type '.*{aka long long int}" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type '.*{aka unsigned long long int}" |
	grep -v "format '%f' expects argument of type 'double', but argument [0-9]\+ has type '.*{aka long long}"
)
echo "${ret}" > ./all_printf_like_error.txt
if [ "$ret" = "" ] 
then
	rm -rf ./all_printf_like_error.txt
	echo 'no printf-like error...'
else
	echo 'compile error(with printf-like error)!!!'
	echo 'please look all_printf_like_error.txt'
	if [ -x ./Server ]; then  
		rm -rf ./Server
	fi
	exit 1
fi


#当前目录是否有Server文件，判断编译是否成功
if [ ! -x ./Server ]; then
	echo 'complie error...'
	exit 1
fi

#彻底编译完毕
echo 'congratulations, compile 100% done, success...'
exit 0