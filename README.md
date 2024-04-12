# take-a-rest

API server build with Hertz and ent.

## Features

- Easy to build framework HTTP RESP API server with [hz](github.com/cloudwego/hertz/cmd/hz)
- ORM modeling with [ent.](https://github.com/ent/ent.git)
- Auto-reload for development with [air](https://github.com/cosmtrek/air)
- Define API with [Protobuf](https://github.com/protocolbuffers/protobuf.git)

## Getting Start

### Init project

```bash
# init project
make init

# add ent. model: User
make model name=User

# add sample idl:hello for rest api
make update idl=idl/hello/hello.proto
```

# run it

modify biz/handler/demo/hello_service.go

```go
	resp := new(demo.HelloResp)
+	resp.RespBody = "Hello, " + req.Name

	c.JSON(consts.StatusOK, resp)
```

```bash
go mod tidy
make dev
```

### Test

```bash
# expect: {"message":"pong"}
curl http://localhost:8888/ping

# expect: {"RespBody":"Hello, Andy"}
curl http://localhost:8888/hello?name=Andy
```
