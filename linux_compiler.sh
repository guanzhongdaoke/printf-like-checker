#!/bin/sh


#���õ�ǰ��ʾ�ַ���
export LANG=C

#��ǰĿ¼
DIR=`pwd`

#Clean
echo 'make clean'
make clean


#ִ��cmake
echo 'Cmake Release'
cmake -DCMAKE_BUILD_TYPE=Release .

#ִ��makeָ��
echo 'make'
make 2>&1|tee ./compile_out.log

#���������
echo 'start check compile warning'

#ע�����WARNING�����ܵ������ݴ��ң��������������
#������ȫ�������WARNING��ֱ����ΪERROR
#warning C4456: declaration of 'i' hides previous local declaration

#���ڷ�����������Ϊ��printf�������Ͳ�ƥ�䵼���쳣崻������Լ�ǿ�ж�
#���ж��Ƿ���printf-like�������Ͳ�ƥ�����Ϣ
#warning: unknown conversion type character 0x20 in format [-Wformat=]
#��������Ƚ����⣬�ݲ��ж��Ƿ���Ҫ��

#ɨ��һ
ret=$(grep "format" -n ./compile_out.log | grep "expects a matching" | grep "argument")
if [ "$ret" = "" ] 
then
	echo "no expects a matching warning"
else
	echo "${ret}" > ./all_printf_like_warning.txt
fi

#ɨ���
ret=$(grep "format" -n ./compile_out.log | grep "unknown conversion type character")
if [ "$ret" = "" ] 
then
	echo "no unknown conversion type character"
else
	echo "${ret}" >> ./all_printf_like_warning.txt
fi

#ɨ����
ret=$(grep "format" -n ./compile_out.log | grep "expects argument of type")
echo "${ret}" >> ./all_printf_like_warning.txt
#���ӹ�������
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


#��ǰĿ¼�Ƿ���Server�ļ����жϱ����Ƿ�ɹ�
if [ ! -x ./Server ]; then
	echo 'complie error...'
	exit 1
fi

#���ױ������
echo 'congratulations, compile 100% done, success...'
exit 0