# Cấu hình server trong 5 phút cùng zash script
1. Cài đặt zash script
```
curl https://raw.githubusercontent.com/beebeo/me/main/shell/zash.sh -o zash.sh && sh zash.sh && source ~/.bashrc
```

2. Cài đặt git
```
zash install git
```
> Sau khi cài đặt git, bạn sẽ có ssh key, nhập ssh key vào project trên git của bạn.

3. Cài đặt docker
```
zash install docker
```

4. Khởi tạo dự án

```
cd /home
git clone [GIT_URL] && cd "$(basename "$_" .git)"
nano .env
```

5. Build container

```
zash pull
```
