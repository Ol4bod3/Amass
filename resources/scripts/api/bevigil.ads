local json = require("json")

name = "BeVigil"
type = "api"

function start()
    set_rate_limit(2)
end

function check()
    local c
    local cfg = datasrc_config()
    if cfg ~= nil then
        c = cfg.credentials
    end

    if (c ~= nil and c.key ~= nil and c.key ~= "") then
        return true
    end
    return false
end

function vertical(ctx, domain)
    local c
    local cfg = datasrc_config()
    if cfg ~= nil then
        c = cfg.credentials
    end

    -- if (c == nil or c.key == nil or c.key == "") then
    --     return
    -- end

    local vurl = "http://osint.bevigil.com/api/" .. domain .. "/subdomains/"
    local resp, err = request(ctx, {
        url=vurl,
        headers={['X-Access-Token']=c.key},
    })
    if (err ~= nil and err ~= "") then
        log(ctx, "vertical request to service failed: " .. err)
        return
    end

    local d = json.decode(resp)
    if (d == nil or #(d.subdomains) == 0) then
        return
    end

    for i, v in pairs(d.subdomains) do
        new_name(ctx, v)
    end

end