APIKEY = 'your_api_key'

mod = require( "Mod" )
mod:init( { apikey = APIKEY } )

-- show default status bar (iOS)
display.setStatusBar( display.DefaultStatusBar )

-- include Corona's "widget" library
local widget = require "widget"
local composer = require "composer"


composer.gotoScene( "home" )
