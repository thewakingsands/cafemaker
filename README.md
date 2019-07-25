# CafeMaker

> A fork of [xivapi](https://github.com/xivapi/xivapi.com) for Chinese players.

## 初始化

### 安装 docker

```bash
apt-get update
apt-get install --no-install-recommends docker.io
docker network create --subnet=172.16.54.0/24 cafemaker 
```

### 起服务

TODO: 可以给出使用 docker-compose 启动服务的范例

```bash
docker pull thewakingsands/cafemaker
mkdir -p /srv/cafemaker/data/redis /srv/cafemaker/data/mysql /srv/cafemaker/data/elasticsearch /srv/cafemaker/data/web
wget -O /srv/cafemaker/dotenv https://raw.githubusercontent.com/thewakingsands/cafemaker-web/cn/.env.dist
docker run -d --name=cafemaker__redis --restart=always --network=cafemaker -v /srv/cafemaker/data/redis:/data redis
docker run -d --name=cafemaker__mysql --restart=always --network=cafemaker -v /srv/cafemaker/data/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:5.7
docker run -d --name=cafemaker__elasticsearch --restart=always --network=cafemaker -e "discovery.type=single-node" -v /srv/cafemaker/data/elasticsearch:/usr/share/elasticsearch/data elasticsearch
docker run -d --name=cafemaker__web --restart=always --network=cafemaker -p 8081:80 -v /srv/cafemaker/data/web:/vagrant/data -v /srv/cafemaker/dotenv:/vagrant/.env thewakingsands/cafemaker
```

### 导入数据库

```bash
curl https://raw.githubusercontent.com/thewakingsands/cafemaker-web/cn/vm/Database.sql | docker exec -it cafemaker__mysql mysql -uroot -proot
```

到这里你应该可以访问服务器的 8081 端口，看到 xivapi 的界面了。

### Discord 登录

去 https://discordapp.com/developers/applications/ 申请一个 app，设置回调 url 为 `hxxp://yourdomain.example/account/login/discord/success` 。

编辑服务器上的 `/srv/cafemaker/dotenv` 文件，设置 `DISCORD_CLIENT_ID`, `DISCORD_CLIENT_SECRET`, `DISCORD_BOT_USAGE_KEY` 即可。

## 导入游戏数据

每次游戏更新，或者第一次初始化，都需要重新导入游戏数据。导入游戏数据的时候，准备一个 Windows 机器，需要安装 .NET Framework 4.5 以上版本，并且安装了 FF14 客户端。

回到服务器，在服务器上执行：

```bash
docker exec -it cafemaker__web bash
```

进入 cafemaker__web 的容器 shell。以下操作均在 cafemaker web 容器的 shell 中完成。

### 下载 SaintCoinach 和定义文件

```bash
bash /cafemaker/bin/sc-download.sh
```

这里会从 GitHub 上拖文件。如果国内服务器，可能拖不回来，自己想办法。手动下载不行，因为除了下载还做了一些拼 json 的操作。

### 解包游戏数据

到服务器上，下载 /srv/cafemaker/data/web/SaintCoinach.Cmd 整个文件夹到 Windows 电脑中。

编辑 `extract-allrawexd.bat` 文件，将其中游戏路径改为你自己安装的游戏路径。保存后，双击运行该文件。

下载 https://github.com/xivapi/ffxiv-datamining/raw/master/csv/ENpcResident.csv 文件，并将它放到 游戏版本号/raw-exd-all/ 文件夹下，改名为 `ENpcResident.en.csv` 。如果你有和国服对应版本的这个文件，用对应版本的更佳。

然后把生成的以游戏版本号命名的文件夹传回服务器上。

### 导入游戏数据到 Redis

这部分比较麻烦，需要有一个大点内存的服务器， 16G 最好。继续在容器 shell 中操作：

```bash
bash /cafemaker/bin/sc-import-redis.sh
bash /cafemaker/bin/sc-custom-redis.sh
```

执行两个脚本大概需要……呃，半小时左右。

### 导入游戏数据到 ElasticSearch

TBD
