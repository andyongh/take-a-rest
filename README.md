# take-a-rest

API server build with Hertz and ent.

## Features

- Easy to build framework HTTP RESP API server with [hz](github.com/cloudwego/hertz/cmd/hz)
- ORM modeling with [ent.](https://github.com/ent/ent.git)
- Auto-reload for development with [air](https://github.com/cosmtrek/air)
- Define API with [Protobuf](https://github.com/protocolbuffers/protobuf.git)

## Getting Start

```bash
# init project
make init

# add ent. model: User
make model name=User

# add sample idl:hello for rest api
make update idl=idl/hello/hello.proto
```
