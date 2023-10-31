#迁移wsl2
wsl -l -v
```bash
C:\Users\xxx\Desktop>wsl -l -v
  NAME      STATE           VERSION
* Ubuntu    Stopped         2
```
导出
wsl --export Ubuntu D:\UbuntuWSL\ubuntu.tar
卸载
wsl --unregister Ubuntu
查看
wsl -l -v
导入
wsl --import Ubuntu D:\UbuntuWSL\ D:\UbuntuWSL\ubuntu.tar --version 2

打开wsl ubuntu之后，默认以root身份登录。
ubuntu.exe config --default-user jws


# powershell 
```bash
notepad $profile
Set-PoshPrompt -Theme zash
Set-PSReadLineOption -PredictionSource History
```



# ssh
ssh-keygen -t rsa

# wsl 配置 粘贴
## https://github.com/neovim/neovim/wiki/FAQ#how-to-use-the-windows-clipboard-from-wsl
![](https://raw.githubusercontent.com/xiaojia21190/my_blog/main/images/Snipaste_2022-12-05_14-19-42.png)

# wsl 删除文件
![Snipaste_2023-10-30_17-22-29](https://github.com/xiaojia21190/config/assets/16084693/1976821e-4360-4cb9-8721-721477679925)
