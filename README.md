### ActiveMQ
---
[ActiveMQ](http://activemq.apache.org)是Apache出品,最流行的,能力强劲的开源消息总线。


### 变量
---
- `ACTIVEMQ_BASE` 指定家目录
- `ACTIVEMQ_CONF` 指定配置目录
- `ACTIVEMQ_DATA` 指定存储目录
 

### 版本
---
- `5.15.4` (docker tags: `5.15.4`, `latest`) : activemq 版本为`5.15.4`


### 使用
---
```bash
# 拉取镜像
docker pull lework/activemq

# 运行镜像
docker run -p 61616:61616 -p 8161:8161 lework/activemq

# 指定变量
docker run -p 61616:61616 -p 8161:8161 -e ACTIVEMQ_CONF=/etc/activemq/conf -e ACTIVEMQ_DATA=/var/lib/activemq/data lework/activemq

# 挂在目录
docker run -p 61616:61616 -p 8161:8161 -v /opt/activemq/conf:/usr/local/activemq/conf -v /opt/activemq/data:/usr/local/activemq/data lework/activemq
```