- chi tiết các thông tin các cột trong bảng.

``` SQL
 DESCRIBE emp;
 ```

- toán tử cộng chuỗi: ||
- Khi thực hiện truy vấn mà không có sắp xếp dữ liệu thì các bản ghi được trả về từ kết quả câu truy vấn sẽ được xếp theo thứ tự INSERT vào bảng lúc đầu.
- Khi thực hiện sắp xếp theo một cột duy nhất, nếu có 2 giá trị bằng nhau thì CSDL sẽ lại sắp xếp theo thứ tự được insert vào bảng. Để tránh điều này xảy ra ta có thể chỉ định mệnh đề order by sắp xếp theo 2 cột trong bảng.
- Có thể thực hiện sắp xếp mà không cần chỉ định rõ tên cột mà chỉ cần vị trí hay số thứ tự của cột đó trong câu lệnh truy vấn

``` SQL
select 
    course_name, price, rank, purchased_date
from courses
order by 2, 4;
```

- Khi ORDER BY thì NULL luôn có trong số lớn nhất. Tức là khi ESC thì null xuống cuối, DESC null lên đầu. Việc này tùy thuộc vào loại server Oracle, Postgre thì đúng, Sql Server ngược lại.
- Nếu muốn các giá trị null này đẩy lên đầu kết quả mà không làm thay đổi thứ tự mong muốn (không dùng desc để đảo lại lên đầu) ta sẽ dùng từ khóa nulls first như sau.

``` SQL
select * from courses
order by expried_date nulls first;
```

- Không thể so sánh (=,>,>=,<,<=,<>) với NULL phỉa dùng toán tử IS NULL | IS NOT NULL. Cần chú ý khi dùng nhỏ hơn <, <= với cột có thể null.

``` SQL
SELECT EMPNO, COMM
FROM EMP
WHERE COMM < 1500 OR COMM IS NULL
```

- Trong phép toán logic thì ÁND luôn thực hiện trước OR. Tốt nhất cứ ().
- Hàm xử lý chuỗi: LOWER, UPPER, INITCAP (viết hoa chữ đầu), CONCAT, SUBSTR (cắt chuỗi), INSTR trả về vị trí trong chuỗi lưu ý tính từ 1,LPAD RPAD thêm cho đủ số ký tự, REPALCE, TRIM.
- Xử lý số: ROUND làm tròn, TRUNC cắt số, MOD chai lấy dư, CELL, FLOOR.
- Date:
  - SYSDATE: Ngày giờ hiện tại của OS.
  - CURRENTDATE: Giờ hiện tại theo múi giờ.
  - DATE - DATE = số ngày cách nhau.
  - MONTHS_BETWEEN
  - ADD_MONTHS
  - NEXT_DAY("01-SEP-95","FRIDATY"): Trả về thứ sáu tiếp theo từ ngày 01/11/1995.
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
- CREATE

``` SQL
CREATE TABLE courses (
    course_name VARCHAR2(100) NOT NULL,
    rank NUMBER DEFAULT 1 NOT NULL ,
    price NUMBER CHECK( price > 1000),
    purchased_date DATE,
    expired_date DATE
);

INSERT ALL
INTO COURSES VALUES ('JS', 1, 2000, '01-JAN-24', '05-JUN-24')
INTO COURSES VALUES ('HTML/CSS', 5, 1100, '01-FEB-24', '25-APR-24')
INTO COURSES VALUES ('C#', 2, 2000, '01-JAN-24', '25-JUN-24')
INTO COURSES VALUES ('C# nang cao', 3, 3900, '01-JUN-24', '20-OCT-24')
INTO COURSES VALUES ('JAVA', 4, 2500, '01-JAN-24', '10-JUN-24')
SELECT 1 FROM DUAL;

SELECT * FROM COURSES;
```

- INSERT: INSERT INTO <tên bảng> (<tên các cột>) VALUES (<GIÁ TRỊ TƯƠNG ỨNG>). Tên các cột nếu để trống sẽ đúng theo thứ tự trong bảng, có thể không thêm tất cả cột, cột không nêu ra mặc định có giá trị NULL

``` SQL
INSERT INTO employees VALUES (97, ‘Steven’, ‘Gerrald’, ‘george@gmail.com’, ‘511.111.4567’, ’17-JUN-03′, ‘AD_PRES’, 24000, NULL, NULL, 90)
-- INSERT ALL thêm nhiều bản ghi. 
-- CHú ý ở cuối luôn phải có 1 mệnh đề SELECT
INSERT ALL
INTO employees VALUES (97, ‘Steven’, ‘Gerrald’, ‘george@gmail.com’, ‘511.111.4567’, ’17-JUN-03′, ‘AD_PRES’, 24000, NULL, NULL, 90)
INTO employees VALUES (98, ‘Alexander’, ‘Arnold’, ‘trent@gmail.com’, ‘512.112.4567’, ’03-JAN-06′, ‘IT_PROG’, 9000, NULL, 102, 60)
SELECT 1 FROM DUAL;
-- Thêm từ 1 câu query
INSERT INTO job_history
SELECT employee_id,
hire_date, ADD_MONTHS(hire_date, 10),
job_id, department_id FROM employees
WHERE employee_idINn (97, 98, 99);
```

- Update: UPDATE <tên bảng> SET <tên cột 1> = <giá trị>, <cột 2> = <giá trị 2>... WHERE <điều kiện>

``` SQL
UPDATE employees
SET salary = salary * 1.5
WHERE department_id in (60, 90);

UPDATE employees
SET salary = salary * 1.5
WHERE employee_id IN (
SELECT employee_id
FROM employees
WHERE manager_id IS NULL
);

```

- DELETE : DELETE FROM <tên bảng> WHERE <điều kiện>

``` SQL
DELETE FROM job_history
WHERE employee_id IN (
SELECT employee_id
FROM employees
WHERE manager_id IS NULL
);
```

- CASCADE: Khi xóa bản ghi ở bảng cha nếu nó có fk đến bảng con thì sẽ báo lỗi. Để xóa bản ghi cha thì cần sửa fk thêm DELETE CASCADE. Khi DROP bảng cha cần thêm CASCADE CONSTRAINTS. Khi thêm CASCADE nếu bản ghi cha bị xóa sẽ tự động xóa các bản ghi con.

``` SQL
CREATE TABLE supplier
( supplier_id numeric(10) not null,
  supplier_name varchar2(50) not null,
  contact_name varchar2(50),
  CONSTRAINT supplier_pk PRIMARY KEY (supplier_id)
);

CREATE TABLE products
( product_id numeric(10) not null,
  supplier_id numeric(10) not null,
  CONSTRAINT fk_supplier
    FOREIGN KEY (supplier_id)
    REFERENCES supplier(supplier_id)
);

INSERT INTO supplier values(10, '1st Supplier', 'John Dollan');
INSERT INTO supplier values(20, '2nd Supplier', 'Steve Reeves');
INSERT INTO supplier values(30, '3rd Supplier', 'Peter Marcello');

INSERT INTO products values(1, 10);
INSERT INTO products values(2, 10);
INSERT INTO products values(3, 10);
INSERT INTO products values(4, 20);
INSERT INTO products values(5, 20);
INSERT INTO products values(6, 30);

-- Lỗi
-- DELETE FROM supplier WHERE supplier_id = 10; 

ALTER TABLE products
DROP CONSTRAINT fk_supplier;

ALTER TABLE products
ADD CONSTRAINT fk_supplier
  FOREIGN KEY (supplier_id)
  REFERENCES supplier(supplier_id)
  ON DELETE CASCADE;
Ta thấy câu lệnh xóa bản ghi bên trên đã thực hiện thành công và bản ghi trên bảng con cũng tự động được xóa theo bảng cha nhờ điều kiện ON DELETE CASCADE.

DELETE FROM supplier WHERE supplier_id = 10;
SELECT * FROM products WHERE supplier_id = 10;

-- Lỗi
-- DROP TABLE supplier;

DROP TABLE supplier CASCADE CONSTRAINTS;

```

- RUNCATE TABLE = DELETE không có điều kiện. Khác với DELETE thì TRUNCATE là mệnh đề DDL nên không cần COMMIT. Trong một số trường hợp thì TRUNCATE  sẽ nhanh hơn nhiều so với DELETE vì nó xóa toàn bộ bảng chứ không xóa từng còng. Tuy nhiên TRUNCATE rất khó khôi phục dữ liệu.
- Câu truy vấn nằm trong mệnh đề FROM được gọi là Inline View (hay Derived Table theo thuật ngữ của các hệ quản trị  CSDL khác).
- Sub Query là 2 câu query lồng nhau. Correlated SubQuery là câu sub query mà câu query còn sử dụng điều kiện ở trong câu query cha. Trong sub query nên query con trả về single value thì có thể dùng toán tử ( =, > , <, >=, <=, <>), còn nến trả về tập hợp thì phải dùng toán tử IN, NOT IN, > hoặc < ALL, > hoặc < ANY, EXiSTS.

``` SQL
-- Sub Query
select * from books
where category = (
    select category_name from categories
where minimum_quantity = (
select max(minimum_quantity) 
     from categories
));
-- Correlated Sub Query
select * from employees e
where salary > (
   select avg(salary) from employees
   where department_id = e.department_id
);
```

- Truy vấn con vô hướng hay Scalar Subquery là câu lệnh truy vấn chỉ trả về 1 cột và tối đa 1 bản ghi.

``` SQL
--  Nếu không làm như vậy, kết quả trả về sẽ có 4 dòng cho mỗi danh mục khác nhau của sách và dẫn đến thông báo lỗi ORA-01427.
select category_name, (
select count(*) from books b
where  b.category = c.category_name
group  by b.category
) book_counts from categories c;
-- tìm sách có số lượng ít hơn số lượng tối thiểu cho phép như sau.
select category, count(*) c
from   books b
group  by category
having count(*) < (
  select c.minimum_quantity
  from   categories c
  where  c.category_name = b.category
);
```

- Mếu sub query trả về NULL thì cả câu điều kiện sẽ luôn là FALSE vì NULL không thể so sánh với bất cứ kiểu gì. Cần xử lý như sau:

``` SQL
SELECT *
FROM employees
WHERE salary > COALESCE((SELECT salary FROM employees WHERE name = 'John'), -1);
```

- EXiSTS luôn nhanh hơn IN vì chỉ cần 1 giá trị tồn tại sẽ trả về true. Còn toán tử IN buộc phải quét tất cả bản ghi trả về từ truy vấn con thì với ra kết quả được. Hơn nữa, toán tử IN không so sánh được với giá trị NULL, nhưng toán tử EXISTS thì có.

``` SQL
-- Không trả về dữ liệu
select * from employees
where employee_id in (null);
-- Trả về taofn bộ bảng employees
select * from employees
where exists ( select null from DUAL );
```

- Common Table Expression cho phép người dùng đặt tên cho 1 đoạn truy vấn trong SQL. Sau đó ta có thể sử dụng lại nó ở bất kỳ đâu trong câu lệnh truy vấn.

``` SQL
-- Ví dụ câu lệnh truy vấn sau tìm danh mục có số lượng sách nhiều hơn số lượng tối thiểu và số lượng sách trung bình của danh mục đó.
-- Sử dụng sub query
select c.category_name, 
       c.minimum_quantity, (
         select avg ( count(*) )
         from   books b
         group  by b.category
       ) mean_books_per_category
from   categories c
where  c.minimum_quantity < (
  select count(*) c
  from   books b
  where  b.category = c.category_name
  group  by b.category
);

-- Sử dụng Common Table Expression
with book_counts as (
  select b.category, count(*) c
  from   books b
  group  by b.category
)
select c.category_name, 
c.minimum_quantity, (
        select avg ( bc.c )
        from   book_counts bc
    ) mean_books_per_category
from   categories c
where  c.minimum_quantity < (
select bc.c
from   book_counts bc
where  bc.category = c.category_name
);
```

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

- BLOB hay Binary LOB dùng để lưu dữ liệu dạng Binary như file ảnh, âm thanh hay video.
- CLOB (Character LOB) và NCLOB (National CLOB), dùng để lưu dữ liệu dạng chuỗi ký tự.
- BFILE hay Binary File, dùng để lưu dữ liệu là các binary file. Thực chất là lưu 1 địa chỉ hay con trỏ đến file đó nằm bên ngoài Database (filesystem trên máy chủ).
Một lưu ý quan trọng với kiểu dữ liệu dạng LOB đó là bạn không thể đặt cột có kiểu dữ liệu này làm Primary Key. Các kiểu dữ liệu LOB cũng không thể dùng trong các mệnh đề thông thường như ORDER BY, GROUP BY hay từ khóa DISTINCT.
