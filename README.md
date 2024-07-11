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
重置wsl的网络
 wsl --shutdown netsh winsock reset netsh int ip reset all netsh winhttp reset proxy ipconfig /flushdns


# powershell 
```bash
notepad $profile
Set-PoshPrompt -Theme zash
Set-PSReadLineOption -PredictionSource History



winget install JanDeDobbeleer.OhMyPosh -s winget

oh-my-posh init pwsh  --config "$env:POSH_THEMES_PATH\zash.omp.json" | Invoke-Expression
Set-PSReadLineOption -PredictionSource History


oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/amro.omp.json" | Invoke-Expression
Set-PSReadLineOption -PredictionSource History # 设置预测文本来源为历史记录 
Set-PSReadlineKeyHandler -Key Tab -Function Complete # 设置 Tab 键补全
Set-PSReadLineKeyHandler -Key "Ctrl+d" -Function MenuComplete # 设置 Ctrl+d 为菜单补全和 Intellisense
Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo # 设置 Ctrl+z 为撤销
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward # 设置向上键为后向搜索历史记录
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward # 设置向下键为前向搜索历史纪录




```

# === NPM BINARY CHINA ===
# https://github.com/cnpm/binary-mirror-config/blob/master/package.json#L53
$Env:NODEJS_ORG_MIRROR="https://cdn.npmmirror.com/binaries/node"
$Env:NVM_NODEJS_ORG_MIRROR="https://cdn.npmmirror.com/binaries/node"
$Env:PHANTOMJS_CDNURL="https://cdn.npmmirror.com/binaries/phantomjs"
$Env:CHROMEDRIVER_CDNURL="https://cdn.npmmirror.com/binaries/chromedriver"
$Env:OPERADRIVER_CDNURL="https://cdn.npmmirror.com/binaries/operadriver"
$Env:ELECTRON_MIRROR="https://cdn.npmmirror.com/binaries/electron/"
$Env:ELECTRON_BUILDER_BINARIES_MIRROR="https://cdn.npmmirror.com/binaries/electron-builder-binaries/"
$Env:SASS_BINARY_SITE="https://cdn.npmmirror.com/binaries/node-sass"
$Env:SWC_BINARY_SITE="https://cdn.npmmirror.com/binaries/node-swc"
$Env:NWJS_URLBASE="https://cdn.npmmirror.com/binaries/nwjs/v"
$Env:PUPPETEER_DOWNLOAD_HOST="https://cdn.npmmirror.com/binaries"
$Env:SENTRYCLI_CDNURL="https://cdn.npmmirror.com/binaries/sentry-cli"
$Env:SAUCECTL_INSTALL_BINARY_MIRROR="https://cdn.npmmirror.com/binaries/saucectl"
$Env:npm_config_sharp_binary_host="https://cdn.npmmirror.com/binaries/sharp"
$Env:npm_config_sharp_libvips_binary_host="https://cdn.npmmirror.com/binaries/sharp-libvips"
$Env:npm_config_robotjs_binary_host="https://cdn.npmmirror.com/binaries/robotj"
# For Cypress >=10.6.0, https://docs.cypress.io/guides/references/changelog#10-6-0
$Env:CYPRESS_DOWNLOAD_PATH_TEMPLATE='https://cdn.npmmirror.com/binaries/cypress/${version}/${platform}-${arch}/cypress.zip'



# ssh
ssh-keygen -t rsa

# wsl 配置 粘贴
## https://github.com/neovim/neovim/wiki/FAQ#how-to-use-the-windows-clipboard-from-wsl
![](https://raw.githubusercontent.com/xiaojia21190/my_blog/main/images/Snipaste_2022-12-05_14-19-42.png)

# wsl 删除文件
![Snipaste_2023-10-30_17-22-29](https://github.com/xiaojia21190/config/assets/16084693/1976821e-4360-4cb9-8721-721477679925)
