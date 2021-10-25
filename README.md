# printf-like-checker
## c/c++类printf,fprintf,scanf等字符串拼接安全性检查工具
#### 1:c/c++的这些字符串操作，经常因为传入类型不合法导致各种崩溃，都是血泪教训
#### 2:无需改变大部分人的编程习惯，无需引入其他库或自己扫描拼接等代码，例如FMT
#### 3:基本无需修改项目代码，开发人员还是按照教科书上教大家的方式编写代码（普通字符串拼接，日志拼接，MYSQL Statment模式拼接SQL语句等）
#### 4:仅借助GCC编译的警告等信息，通过编写大量的SHELL过滤代码即可实现；该方式完全可以放置在自动化编译的最后一步

## 接入步骤
##### 1:修改项目编译脚本，编译时支持以下参数：-Werror=format-contains-nul -Werror=format-extra-args -Werror=format-zero-length -Werror=format-nonliteral -Wall
##### 2:假定项目通过CMAKE编译，目标文件名Server，参考./linux_compiler.sh中的扫描一，二，三（尤其是三，还可以继续扩展规则），一旦发现编译输出文件中有不合法警告，则编译失败，开发人员查看all_printf_like_error.txt文件
