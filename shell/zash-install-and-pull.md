# Cấu hình server trong 5 phút cùng zash script
## 1. Cài đặt zash script
```
curl https://raw.githubusercontent.com/beebeo/me/main/shell/zash.sh -o zash.sh && sh zash.sh && source ~/.bashrc
```

## 2. Bảo mật SERVER bằng SSH Key và thay đổi port SSH
```
zash setup
```
> Nhập khóa công khai của bạn, điền port SSH mới và dán cấu hình mới vào ssh_config [(Xem hướng dẫn)](./../ssh/ssh-home-to-server.md#bước-5-cấu-hình-ssh-client)

## 3. Cài đặt git
```
zash install git
```
> Sau khi cài đặt git, bạn sẽ có ssh key, nhập ssh key vào project trên git của bạn.

## 4. Cài đặt docker
```
zash install docker
```

## 5. Khởi tạo dự án

```
cd /home
git clone [GIT_URL] && cd "$(basename "$_" .git)"
nano .env
```

## 6. Build container

```
zash pull
```
