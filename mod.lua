local Mod = {
	
	apikey = nil,
  	showStatus = false,
  	endpoint = "http://beta.comicvine.com/api/",
  	POST = "POST",
  	GET ="GET",
  	Nil = nil,
  	requestQueue = {}
  
}

local json = require("json")

local inspect = require("inspect")


function Mod:init( o )
  self.apikey = o.apikey
end

function Mod:characters(filter,_callback)

	native.setActivityIndicator(true);
	
  
  local uri = Mod.endpoint .. "characters/?" .. "api_key=" .. Mod.apikey .. "&filter=gender:" ..filter.."&format=json" 
  print("the uri is".. uri)
  network.request(uri,Mod.GET,function(e) Mod:onResponse(e,_callback); end)
end

function Mod:character(filter,_callback)
	
	native.setActivityIndicator(true);	  
  
  local uri = Mod.endpoint .. "characters/?" .. "api_key=" .. Mod.apikey .. "&filter=id:" ..filter.."&format=json" 
  network.request(uri,Mod.GET,function(e) Mod:onResponse(e,_callback); end)

end



-- RESPONSE --
function Mod:onResponse(event,_callback)
  if event.phase == "ended" then

native.setActivityIndicator(false);
	

  if event.status == 200 then
  	--print(inspect(json.decode(event.response)))
  	_callback(event)

  end
  
 end   

end

return Mod
