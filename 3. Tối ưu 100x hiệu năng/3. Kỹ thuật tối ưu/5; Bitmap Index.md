[Video](https://wecommit.com.vn/courses/chuong-trinh-dao-tao-toi-uu-co-so-du-lieu-cao-cap/lesson/mot-so-lua-chon-dac-biet-03/)

## Bitmap Index

- Thuật toán: Sẽ dàn ngang giá trị của cột được đánh Bitmap Index ra và cột được dàn đó sẽ có giá trị là 0 hoặc 1 tướng ứng giá trị cột trong bảng. Ví dụ trường gênrá(giới trính) chỉ có 2 giá trị male và female thì bitmap Index có dạng:
| Name | Male | female |
|:----:|:----:|:----:-:|
| Hải  | 1    | 0      |
| Linh | 0    | 1      |

## trường hợp sử dụng

- Phù hợp với các cột có ít giá trị khác nhau. Dưới 1% giá trị khác nhau trong bảng (Select distinct cột đó ra chia cho tổng bản ghi).
- Phù hợp với các CSDL Data Warehouse thiết kế mô hình Star: Ít giá trị khác nhau, gần như không thay đổi dữ liệu.
- Nếu cột có nhiều dữ liệu khác nhau hoặc thường xuyên bị thay đổi giá trị thì có thể dẫn đến chết DB.
- Có tác dụng với giá trị NULL (**khác với BTree Index nếu NULL là không ăn**)/
