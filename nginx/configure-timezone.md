# Cấu hình múi giờ cho server
Đôi khi code phía backend lệch giờ với frontend khiến thời gian không nhất quán. Cài đặt này sẽ đảm bảo rằng server của bạn hoạt động đúng theo múi giờ bạn mong muốn.

## Kiểm tra múi giờ hiện tại của server
```
timedatectl status
```
<img src="https://i.imgur.com/EZBR2s9.png" />

## Tìm múi giờ theo khu vực
```
timedatectl list-timezones | egrep  -o "Asia/.*"
```

## Đặt múi giờ (thay thành múi giờ bạn muốn)
```
timedatectl set-timezone Asia/Ho_Chi_Minh
```

## Xem lại thay đổi
```
timedatectl status
```
<img src="https://i.imgur.com/Vy7Qwrx.png">
