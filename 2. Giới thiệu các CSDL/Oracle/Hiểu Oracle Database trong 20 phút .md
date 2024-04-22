[Video](https://www.youtube.com/watch?v=6icn0a5lKi4)

- Bản chất Database là tập hợp các file vật lý. Người dùng không thể tương tác trực tiếp với các file đó mà phải qua 1 trung gian gọi là **Database instance**
- Database instance gồm 2 phần chính:
  - Memory.
  - Background Process: Định kỳ tương tác với Memory.

## Kiến trúc bộ nhớ (Memory)

Gồm 2 phần:

- SGA bộ nhớ dùng chung, tất cả các process trong DB cùng chia sẻ bộ nhớ này
  - Shared Pool: Vùng nhớ dùng để phân tích câu lệnh: kiểm tra cú pháp, kiểm tra object tồn tại và có quyền truy cập không, phân tích chiến lược thực thi tối ưu nhất.
  - Database Buffer Cache: Sau khi phân tích câu lệnh ở Shared Pool xong. Nếu dữ liệu đã có trong Memory thì lấy luôn từ Buffer Cache. Nếu không có thì phải lấy từ Disk lên rồi load vào Buffer Cache sau đó trả về cho ngời dùng.
  - Redo Log Buffer: Lưu các thông tin thay đổi trong hệ thống. Ví dụ khi chạy câu lệnh DML (insert, update, delete), DDL thay đổi cấu trúc.
  - Large Pool: Thiết kế dùng riêng cho các hoạt động dùng nhiều đến tài nguyên IO: Backup, Restore...
  - Stream Pool
  - Java Pool
- PGA bộ nhớ dùng riêng, mỗi process sẽ có vùng riêng này

## Kiến trúc Process

- DB writer: Định kỳ ghi dữ liệu từ Buffer Cache xuống Data File. Sẽ ghi trong các trường hợp sau
  - Quá nhiều Dirty Block (khi load dữ liệu từ Data File lên Buffer sau đó dữ liệu bị thay đổi sẽ chuyển trạng thái sang Dirty)
  - Khi tiến trình CheckPoint xảy ra.
- Log writer:
  - Khi thực hiện lệnh commit.
  - Switch Log: Ví dụ có 3 log group 1,2,3 . Nếu ghi đầy log group 1 thì switch sang group 2.
  - Đầy 1/3 Redo Log Buffer.
  - Ghi trước khi DB writer ghi.
- Archive Process: Khi ghi đầy cả 3 log group thì quay lại ghi Log group 1, nếu DB chạy ở Archive Mode thì sẽ chạy tiến trình Archive backup log sang Archive Log File trước khi ghi đè log group 1.
- CheckPoint Process: Ghi thông tin SCN của DB vào các file: control file, data file header.
  - Định kỳ xảy ra trong DB.

## Kiến trúc vật lý

- **Control File** cực kỳ quan trọng của DB, như 1 tấm bản đồ của DB
  - Lưu thông tin DB.
  - Đường dẫn chi tiết của các Data FIle
  - Đường dẫn chi tiết của các Redo Log FIle
  - CheckPoint
  - Character Set
- **Data File**: Lưu dữ liệu
- **Redo Log File**: Lưu thông tin thay đổi.
- Paramester File: Lưu thông tin cấu hình DB.
- Backup File
- Archive Log File: Bản sao thông tin của Redo Log FIle. Bởi vì Redo Log hoạt động theo cơ chế xoay vòng nên có thể bị ghi đè.
- Password File: Lưu thông tin của User Quản trị (SYS).Cần lưu thông tin User quản trị vì không thể lưu thông tin User quản trị trong DB vì khi tắt DB thì không xác thực được.
- Alert Log, Trace File: Lưu thông tin cảnh báo.
