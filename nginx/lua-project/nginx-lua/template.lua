--local template = require "resty.template"
--template.render("view.html", { message = "Hello, World!" })
-- lua??redis??

-- ip??????


local config = {
    name = "testCluster",                   --rediscluster name
    serv_list = {                           --redis cluster node list(host and port),
        { ip = "47.98.147.49", port = 6391 },
        { ip = "47.98.147.49", port = 6392 },
        { ip = "47.98.147.49", port = 6393 },
        { ip = "47.98.147.49", port = 6394 },
        { ip = "47.98.147.49", port = 6395 },
        { ip = "47.98.147.49", port = 6396 }
    },
    keepalive_timeout = 60000,              --redis connection pool idle timeout
    keepalive_cons = 1000,                  --redis connection pool size
    connection_timout = 1000,               --timeout while connecting
    max_redirection = 5,                    --maximum retry attempts for redirection
    -- auth=""
}



local redis_cluster = require "rediscluster"
local red_c = redis_cluster:new(config)

-- ??
local function read_redis(key)
      local resp,err = red_c:get(key)

      if err then
          ngx.log(ngx.ERR, "err: ", err)
          return
      end

      if resp==ngx.null then
         resp=nil
      end
      return resp
end

--
function read_http(url)
    local http = require("resty.http")
    local httpc = http.new()
    local resp, err = httpc:request_uri(url,{
       method = "GET"
    })
    if not resp then
      ngx.log(ngx.ERR,"request error: ", err)  --????
      return
    end
    httpc:close()
    return resp.body
end

-- ?????????????????id???????????php?? ??
local content=read_redis("xxxx") --

if not content then
    ngx.log(ngx.INFO,"??http??")
    --ngx.say(read_http('http://47.98.147.49:9500')) --??http
    --?????????php-fpm
    return ngx.exec('/php', 'a=3&b=5&c=6');  -- ??php  location
end



ngx.say(content)

