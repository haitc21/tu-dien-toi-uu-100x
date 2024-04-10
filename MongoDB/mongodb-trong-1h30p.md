# Học MongoDB trọn vẹn trong 1 giờ 30 phút

[Link khóa học](https://www.youtube.com/watch?v=8Nx7cdwT86c&t=1247s)

## Thuật ngữ trong MongoDB

| RDBMS (CSDL quan hệ) | MongoDB    | Khác                                    |
|:--------------------:|:----------:|:---------------------------------------:|
| Database             | Database   |                                         |
| Table                | Collection |                                         |
| Coloumn              | Feild      | Feild không cần định nghĩa kiểu dữ liệu |
| Index                | Index      |                                         |

## Các mô hình triển khai MongoDB

- Standalone:
  - Triển khia trên 1 server duy nhất.
  - Ưu điểm: Đơn giản.
  - Nhược điểm: Tính sẵn sàng, hiệu năng, chỉ có thể mở rộng theo chiều dọc **vertical scale** tức là muốn nâng cấp phải nâng cấu hình server.
- Replication:
  - Có nhiều server cài MongoDB. Trong đó có 1 sv chính là sv **Primary** nhận lệnh từ các client rồi đẩy dữ liệu thay đổi đó sang các sv dự phòng **Secondary**
  - Ưu điểm: Tính sẵn sàng cao vì khi Primary gặp sự cố thì 1 Secondary có thể trở thành Primary.
  - Nhược điểm: Phức tạp, cũng chỉ có thể **vertical scale**.

- Sharding
  - Dữ liệu được phân chia lưu trữ ở nhiều server
  - Mở rộng theo chiều ngang **horizontal scale**
  - Có thể kết hợp với mô hình Replication.

## Các cách triển khai

- Cloud: ![MongoDB Atlas](https://www.mongodb.com/atlas/database) free 512MB, tạo theo mô hình Replication 1 Primary và 2 Secondatry.
- On-promise: Cài trực tiếp MongoDB trên server của mình.
  - [MongoDB Community Server](https://www.mongodb.com/try/download/community)
  - Port: 27017
  - [Mongo Shell](https://www.mongodb.com/try/download/shell)
  - Mongosh:

  ``` CMD
  cd C:\Users\haitc\AppData\Local\Programs\mongosh\
  .\mongosh.exe
  ```

## Kiến trúc Logic

- Database
  - Collection
    - Document
      - Document con
- Kiến trúc hoạt động
  - MOngoDB được cài trên Server và được cấp phát tài nguyên.
  - Dữ liệu của DB được lưu vào Memory sau đó chuyển về File lưu trên Disk.
  - **Storage Engine**: Quyết định thành phần Memory và FIle, giải thuật tương tác giữa chúng:
    - WireTiger Storage Engine (Default)
    - In-Memory Storage Engine: Chỉ có trong phiên bản Enterprise.

- Cách kiểm tra Storage Engine
  - Cách 1: Dùng mongosh

  ``` CMD
  cd C:\Users\haitc\AppData\Local\Programs\mongosh\
  .\mongosh.exe
  ```

  ![Storage Engine](images/storage-engine1.png)

  - Cách 2: Xem định dạng file trong thư mục lưu trữ Data: C:\Program Files\MongoDB\Server\7.0\data
  ![Kiểm tra Storage Engine hiện tại](images/storage-engine2.png)

- Thay đổi Storage Engine
  - Vào file: C:\Program Files\MongoDB\Server\7.0\bin\mongod.cfg
  ![Thay đổi Storage Engine](images/storage-engine3.png)
