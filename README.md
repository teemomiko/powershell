# powershell
## 练习powershell ,练手一些基本功能<br>
- 1.checkADpasswordexpire   用于清理AD的过期账户。 <br>
- 2.cleanupmail  用于清理短期内无收发记录的共享邮箱。<br>
- 3.有其他需求，一起探讨。

在 PowerShell 中，你可以使用字符串的 TrimEnd() 方法来去除末尾的换行符和空格
'''
原始字符串
原始字符串 = "这是一个带有换行和空格的字符串 
使用TrimEnd()方法去除换行符和空格
$处理后的字符串 = $原始字符串.TrimEnd()
打印处理后的字符串
Write-Host $处理后的字符串
'''

- DumpFile analyse
    - we can use  windbg for analyse dump file to find error
    as follows:
    u can see:
 ```

SYMBOL_NAME:  nt!RtlXSaveS+29

MODULE_NAME: nt

IMAGE_NAME:  ntkrnlmp.exe

IMAGE_VERSION:  10.0.22621.2428

STACK_COMMAND:  .cxr; .ecxr ; kb

BUCKET_ID_FUNC_OFFSET:  29

FAILURE_BUCKET_ID:  AV_R_nt!RtlXSaveS

OS_VERSION:  10.0.22621.1928

BUILDLAB_STR:  ni_release_svc_prod3

```
That seems   AV_R_nt!RtlXSaveS cause the error , u can  find  defender  or check  Memory  .

