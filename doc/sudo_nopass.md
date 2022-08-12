# sudoのパスワードを不要にする

個人用PCのWSL2でsudoのパスワードは不要であろう。
利便性のため解除する。

```sh
# nano -> vim
sudo update-alternatives --set editor /usr/bin/vim.basic
sudo visudo
```

以下のように編集する。

```
- %sudo   ALL=(ALL:ALL) ALL
+ %sudo   ALL=(ALL:ALL) NOPASSWD: ALL
```
