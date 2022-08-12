# Don't append windows path

遅くなるので無効化しておく。

```sh
sudo vi /etc/wsl.conf
```

```txt
[interop]
appendWindowsPath = false
```

反映には再起動が必要。

```powershell
wsl.exe --shutdown
```
