# Tạo SSH và sử dụng nó để kết nối với github
> Cách tạo và sử dụng cũng tương tự như [sử dụng SSH để kết nối với server](ssh-local-and-server.md). Nhưng thay vì kết nối từ máy tính cá nhân tới server, ở đây chúng ta sẽ kết nối từ server đến github để pull, push code không cần mật khẩu mà vẫn bảo mật.

## Lý do sử dụng
- SSH Key bảo mật hơn HTTPS vì nó không yêu cầu các thông tin để truy cập tới tài khoản Github của bạn. Nếu một ai đó hack vào server và lấy được private key của bạn thì họ có thể làm một số thứ với các repository của bạn (Ví dụ: force push một repository rỗng, nó sẽ xóa history của bạn), để tránh điều này, bạn chỉ cần cho SSH Key quyền đọc, ko cho quyền **Write** là được.
- Nếu key của bạn bị đánh cắp, bạn vẫn có thể truy cập tới tài khoản Github và xóa bất kỳ key nào bị mất hoặc bị đánh cắp.

## 1. Tạo SSH Key trên Server
```
ssh-keygen -t rsa -b 4096 -C "example@gmail.com"
```

## 2. Copy SSH vào repo github
```
cat ~/.ssh/id_rsa.pub
```
Sau đó bạn hãy tiến hành copy toàn bộ nội dung từ `ssh-rsa` đến `@gmail.com` (mail của bạn) và paste nó vào https://github.com/[username]/[repositories]/settings/keys/new (**GitHub** > **Your repository** > **Settings** > **Deploy Keys** > **Add deploy key** > **Paste in your public key**)
> Chọn **Allow write access** nếu bạn muốn cấp quyền ghi cho ssh này tức là có thể push code lên repository của bạn. Bạn nào server chỉ dùng pull code về thì không cần tích chọn đâu.

## 3. Kiểm tra lại kết nối
```
ssh -T git@github.com
```
<img src="https://i.imgur.com/vWbJEQz.png" />

> Đến bước này các bạn có thể `git clone` các repository của bạn về. Nếu repo của bạn đã clone về trước đó và đang sử dụng HTTPS thì có thể đổi nó sang SSH bằng lệnh:
```
cd PROJECT_PATH
git remote set-url origin [ssh-url]
git pull
```
