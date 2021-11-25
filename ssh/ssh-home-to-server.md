# Tạo SSH và sử dụng nó để kết nối với server
> SSH là viết tắt của `Secure Socket Shell`, là giao thức đăng nhập vào server từ xa, cho phép người dùng kiểm soát, chỉnh sửa và quản trị dữ liệu của server thông qua nền tảng Internet. SSH cũng giúp việc kết nối của mạng lưới máy chủ và máy khách an toàn, hiệu quả và bảo mật thông tin tốt hơn.

## Ưu điểm
- Bảo mật các kết nối của máy tính với server.
- Không phải nhập mật khẩu server mỗi lần đăng nhập.

## Cơ chế làm việc
- Bạn sẽ có 2 key: `public key` và `private key`. Bạn sẽ gửi public key của mình cho server và giữ lại private key trên `máy tính cá nhân`.

- Sau đó mỗi lần bạn đăng nhập, máy tính của bạn sẽ tự gửi kèm các thông tin chứng thực đi, server sẽ nhận diện ra bạn và bạn không cần phải nhập mật khẩu nữa.

## Tạo SSH Key
- ### Bước 1: Kiểm tra xem máy bạn có SSH Key nào chưa
```
ls -la ~/.ssh
```
Mặc định, các file ssh thường có dạng:
```
id_rsa
id_rsa.pub
```
`public key` sẽ có đuôi `.pub` (id_rsa.pub), `private key` thì không có đuôi (id_rsa). Nếu có một cặp ssh key nào trong thư mục này (giả sử là id_rsa và id_rsa.pub), bạn có thể bỏ qua **Bước 2** và chuyển thẳng sang **Bước 3**.

- ### Bước 2: Tạo SSH Key mới

Mở Terminal và chạy lệnh sau
```
ssh-keygen -t rsa
```
Đợi 1 lúc máy tính sẽ hỏi
```
Enter file in which to save the key (/Users/demo/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
```
Chọn vị trí lưu file và điền passphrase. Việc sử dụng passphrase mang lại một số lợi ích: tính bảo mật của key không bao giờ được hiển thị với bất kỳ ai khác, cho dù nó được mã hóa như thế nào. Nếu private key được bảo vệ bằng passphrase rơi vào tay user trái phép, họ sẽ không thể đăng nhập vào các tài khoản cho đến khi tìm ra được passphrase. Tất nhiên, nhược điểm duy nhất của passphrase là phải nhập nó mỗi khi sử dụng key pair.

Public key nằm trong `/Users/demo/.ssh/id_rsa.pub`. Private key nằm trong `/Users/demo/.ssh/id_rsa`

- ### Bước 3: Thêm SSH Key vào server của bạn

Việc tiếp theo bạn cần làm là upload public key lên server muốn sử dụng, nhớ thay đổi đường dẫn file .pub và ip server của bạn
```
cat ~/.ssh/id_rsa.pub | ssh root@192.168.0.1 "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
```
Bước này server sẽ hỏi mật khẩu, bạn nhập và tiếp tục như bình thường

- ### Bước 4: Vô hiệu hóa đăng nhập bằng mật khẩu

Khi đã sao chép các SSH Key vào server của mình và đảm bảo rằng có thể đăng nhập bằng SSH Key. Hãy hạn chế root login và chỉ có thể đăng nhập thông qua SSH Key.

Đầu tiên, mở file SSH config

```
sudo nano /etc/ssh/sshd_config
```

Tìm 3 dòng này và sửa theo mẫu (nếu có dấu # ở đầu dòng thì loại bỏ nó đi)

```
AuthorizedKeysFile	/root/.ssh/authorized_keys
...
PasswordAuthentication no
...
UsePAM no
```

`Ctrl O` + `Ctrl X` để lưu lại cấu hình và chạy lệnh để làm mới cài đặt

```
sudo systemctl reload sshd.service
```

Đến bước này coi như đã xong phần cấu hình SSH cho server, để truy cập server bằng ssh không cần mật khẩu bạn chỉ cần gõ `ssh root@IP_SERVER` và nhập passphrase nếu có. Nhưng nếu bạn quản trị nhiều web server thì việc nhớ hết từng ip của mỗi server là việc rất khó khăn, vậy làm như thế nào ? Hãy xem tiếp bước 5 nhé.

- ### Bước 5: Cấu hình SSH Client

Mở Termial ở máy tính bạn và chạy lệnh
```
sudo nano ~/.ssh/config
```

Paste đoạn dưới đây và thay đổi thông tin server của bạn và đường dẫn file public_key đã tạo
```
Host server_test
     User root
     Port 22
     HostName 192.168.0.1
     IdentityFile /Users/demo/.ssh/id_rsa.pub
```
`Ctrl O` + `Ctrl X` để lưu lại cấu hình

Bây giờ để ssh vào server 192.168.0.1 thay vì `ssh root@192.168.0.1` bây giờ chỉ cần gõ `ssh server_test` vậy là xong.
