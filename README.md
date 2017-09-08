# devops

DevOps Deploy Time Series API

### Prerequisites

[__VirtualBox__]

[__Docker__]

[__Redis__]

### Testing on macOS

```sh
docker run -d -e REDIS_URL="redis://{REDISSERVER}:6379" -p 4567:4567 brodriguesneto/devops
```

Where {REDISSERVER} is your redis server

Import DevOPs.postman_collection.json to [__Postman__] then RUN it.

[__VirtualBox__]: https://www.virtualbox.org/
[__Docker__]: https://www.docker.com/
[__Redis__]: https://redis.io/
[__Postman__]: https://www.getpostman.com/