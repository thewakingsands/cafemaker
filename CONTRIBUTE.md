# 贡献指南

## 搭建环境

### 运行 docker-compose

```bash
docker-compose up
```

### 导入数据库

```bash
cat web/vm/Database.sql  | docker exec -i cafemaker_mysql_1  mysql -uroot -proot
```

### 导入数据

参考 [INSTALL](INSTALL.md)
