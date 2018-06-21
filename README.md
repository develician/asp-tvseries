# asp-tvseries
asp-tvseries

### MSSQL (SQL)

```SQL
CREATE TABLE tvseries.dbo.Account (
id int IDENTITY(1, 1) NOT NULL,
username varchar(200) NOT NULL PRIMARY KEY,
password varchar(200) NOT NULL,
email varchar(200) NOT NULL,
isAdmin int NOT NULL
);
​
CREATE TABLE tvseries.dbo.Series (
id int IDENTITY(1, 1) NOT NULL PRIMARY KEY,
title varchar(500) NOT NULL,
genre varchar(500) NOT NULL,
year varchar(500) NOT NULL,
trailerImage varchar(1000) NOT NULL,
story varchar(5000) NOT NULL
);


** 참고사항
MSSQL 계정 아이디: killi8n
비밀번호: admin1234
```
