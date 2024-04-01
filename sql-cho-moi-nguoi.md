- chi tiết các thông tin các cột trong bảng

``` SQL
 DESCRIBE emp;
 ```

- toán tử cộng chuỗi: ||
- Khi ORDER BY thì NULL luôn có trong số lớn nhất. Tức là khi ESC thì null xuống cuối, DESC null lên đầu. Việc này tùy thuộc vào loại server Oracle, Postgre thì đúng, Sql Server ngược lại.
- Trong phép toán logic thì ÁND luôn thực hiện trước OR. Tốt nhất cứ ().
- Hàm xử lý chuỗi: LOWER, UPPER, INITCAP (viết hoa chữ đầu), CONCAT, SUBSTR (cắt chuỗi), INSTR trả về vị trí trong chuỗi lưu ý tính từ 1,LPAD RPAD thêm cho đủ số ký tự, REPALCE, TRIM.
- Xử lý số: ROUND làm tròn, TRUNC cắt số, MOD chai lấy dư, CELL, FLOOR.
- Date:
  + SYSDATE: Ngày giờ hiện tại của OS.
  + CURRENTDATE: Giờ hiện tại theo múi giờ.
  + DATE - DATE = số ngày cách nhau.
  + MONTHS_BETWEEN
  + ADD_MONTHS
  + NEXT_DAY("01-SEP-95","FRIDATY"): Trả về thứ sáu tiếp theo từ ngày 01/11/1995.
- SUM, MAX, MIN, COUNT, AVG: Đều không tính giá trị null. VD: Có 14 nv, tổng COMM là 2200, COUNT(COMM) = 4 tức là chỉ có 4 người có hoa hồng thì AVG(COMM) = 2200 / 4 = 550.

``` SQL
SELECT
    COUNT(*) TOTAL_EMP,
    SUM(COMM) TOTAL_COMM,
    COUNT(COMM) COUNT_COMM_NOT_NULL,
    COUNT(NVL(COMM, 0)) COUNT_COMM,
    AVG(COMM) AVG_COMM,
    ROUND(SUM(COMM) / COUNT(*), 2) "AVG_COMM_HAS_NULL"
FROM EMP; 
```


| TOTAL_EMP | TOTAL_COMM | COUNT_COMM_NOT_NULL | COUNT_COMM | AVG_COMM | AVG_COMM_HAS_NULL |
|:----------|:----------:|:-------------------:|:----------:|:--------:|:-----------------:|
|     14    |    2200    |           4         |      14    |  550     |        157.14     |


- 3 mệnh đề kết hợp: Union/Union All hợp 2 tập hợp Unit = UnionAll Distinct, INTERSECT giao 2 tập hợp, MINOR lấy tập hợp A -B.
- Mệnh đề DML: INSERT, UPDATE, DELETE là 3 mệnh đề DML cần có COMMIT hoặc ROLL BACK để lưu lại trong DB.
- Khác với DELETE thì TRUNCATE là mệnh đề DDL nên không cần COMMIT.
- Sub Query là 2 câu query lồng nhau. Correlated SubQuery là câu sub query mà câu query còn sử dụng điều kiện ở trong câu query cha. Trong sub query nên query con trả về single value thì có thể dùng toán tử ( =, > , <, >=, <=, <>), còn nến trả về tập hợp thì phải dùng toán tử IN, NOT IN, > hoặc < ALL, > hoặc < ANY, EXiSTS. 
- Mếu sub query trả về NULL thì cả câu điều kiện sẽ luôn là FALSE vì NULL không thể so sánh với bất cứ kiểu gì. Cần xử lý như sau: 

``` SQL
SELECT *
FROM employees
WHERE salary > COALESCE((SELECT salary FROM employees WHERE name = 'John'), -1);
```

- EXiSTS luôn nhanh hơn IN vì chỉ cần 1 giá trị tồn tại sẽ trả về true.
- Mệnh đề OVER sẽ nhóm các hàng bản ghi lại với nhau, thực hiện tính toán trên các nhóm đó và trả về kết quả trên từng hàng. Nhóm các hàng trong mệnh đề OVER thường được gọi là các “Window”. Nếu không chỉ định gì trong OVER, Oracle sẽ tự động coi cả bảng đang được truy vấn là 1 Window và thực hiện tính toán trên cả bảng đó. Nếu muốn chỉ định cách Oracle đọc Window khác đi, ta thêm mệnh đề PARTITION BY trong OVER và sau đó là tên cột mà ta muốn Oracle nhóm lại để thực hiện tính toán. Ví dụ sau sẽ lấy danh sách nhân viên và tính toán tổng số lương mà công việc ở vị trí mỗi nhân viên đó nhận được trong cả công ty.

``` SQL
SELECT
    employee_id,
    first_name || ‘ ‘ || last_name AS full_name,
    salary,
    SUM(salary) OVER(PARTITION BY job_id)
    AS total_salary_by_job
FROM employees e;
```

- Sequance: 
``` SQL
CREATE SEQUENCE emp_seq
    MINVALUE 1000
    MAXVALUE 9999
    START WITH 1100
    INCREMENT BY 1
    CACHE 5; // Cho Oracle tính trước 5 giá trị tiếp theo, tăng hiệu năng
```

- Ví dụ sau ta sẽ xem thử các giá trị trong Sequence với hàm NEXTVAL của Sequence (thêm “CONNECT BY LEVEL <= 5” để thực hiện lại câu lệnh 5 lần).

``` SQL
SELECT emp_seq.NEXTVAL AS EMP_SEQ_VALUE FROM DUAL
CONNECT BY level <= 5;
```

- Không thể dùng Sequance trong INSERT ALL vì bản chất INSERT ALL chỉ là 1 cấu lệnh nên Sequance trả về giá trị giống nhau.
- View không phải là 1 bảng nên nó không chứa dữ liệu bên trong, nội dung của nó được định nghĩa là do câu lệnh truy vấn tạo nên. Dữ liệu trả về khi truy vấn View thực tế vẫn nằm ở bảng mà nó được lấy ra chứ không được chuyển vào hay copy sang View để lưu như nhiều người lầm tưởng.
-Kiểu dữ liệu “lớn” hay Large Object Data  (LOB). Đúng như tên gọi của mình, các kiểu dữ liệu này được dùng để lưu dữ liệu có kích thước lớn hơn dữ liệu text thông thường trên các bản ghi như ảnh, video, file PDF, v.v… .
 + BLOB hay Binary LOB dùng để lưu dữ liệu dạng Binary như file ảnh, âm thanh hay video.
 + CLOB (Character LOB) và NCLOB (National CLOB), dùng để lưu dữ liệu dạng chuỗi ký tự.
 + BFILE hay Binary File, dùng để lưu dữ liệu là các binary file. Thực chất là lưu 1 địa chỉ hay con trỏ đến file đó nằm bên ngoài Database (filesystem trên máy chủ).
Một lưu ý quan trọng với kiểu dữ liệu dạng LOB đó là bạn không thể đặt cột có kiểu dữ liệu này làm Primary Key. Các kiểu dữ liệu LOB cũng không thể dùng trong các mệnh đề thông thường như ORDER BY, GROUP BY hay từ khóa DISTINCT.
