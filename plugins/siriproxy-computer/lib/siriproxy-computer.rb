require 'cora'
require 'siri_objects'

#######
# This is a plugin for controlling your computer.
# Edit to your heart's content, but just give me some credit :)
# 
# Created by Ian McDowell - www.ianmcdowell.net
######

class SiriProxy::Plugin::Computer < SiriProxy::Plugin
  def initialize(config)
    #if you have custom configuration options, process them here!
  end

  playingname = %x[osascript -e 'tell application "iTunes" to name of current track as string']
  playingartist = %x[osascript -e 'tell application "iTunes" to artist of current track as string']

  listen_for /itunes (.*)/i do |userAction|
	if userAction == "pause" or userAction == "pause " or userAction == "stop playing" or userAction == "stop playing " or userAction == "stop" or userAction == "stop " then
		`osascript -e 'tell application "iTunes" to pause'`
		say "I paused iTunes for you."
	elsif userAction == "play" or userAction == "play " or userAction == "start playing" or userAction == "start playing " or userAction == "start" or userAction == "start " then
		`osascript -e 'tell application "iTunes" to play'`
		say "Playing #{playingname} by #{playingartist}"
	elsif userAction == "next" or userAction == "next " or userAction == "next track" or userAction == "next track " then
		`osascript -e 'tell application "iTunes" to next track'`
		say "Playing the next track: #{playingname} by #{playingartist}"
	elsif userAction == "previous" or userAction == "previous " or userAction == "previous track" or userAction == "previous track " then
		`osascript -e 'tell application "iTunes" to previous track'`
		say "Playing the previous track: #{playingname} by #{playingartist}"
	elsif userAction == "mute" or userAction == "mute " then
		`osascript -e 'tell application "iTunes" to set mute to true'`
		say "iTunes was muted."
	elsif userAction == "mute off" or userAction == "mute off " or userAction == "unmute" or userAction == "unmute " then
		`osascript -e 'tell application "iTunes" to set mute to false'`
		say "iTunes was unmuted."
	elsif userAction == "volume up" or userAction == "volume up " then
		currentvol = `osascript -e 'tell application "iTunes" to sound volume as integer'`
		newvol = (currentvol.to_i + 20)
		if newvol > 100 then
			newvol = 100
		end
		`osascript -e 'tell application "iTunes" to set sound volume to #{newvol}'`
		say "Volume was raised to #{newvol}."
	elsif userAction == "volume down" or userAction == "volume down " then
		currentvol = `osascript -e 'tell application "iTunes" to sound volume as integer'`
		newvol = (currentvol.to_i - 20)
		if newvol < 0 then
			newvol = 0
		end
		`osascript -e 'tell application "iTunes" to set sound volume to #{newvol}'`
		say "Volume was lowered to #{newvol}."
	else
		say "That isn't something I can do right now."
	end
	request_completed
   end
  listen_for /open program (.*)/i do |userAction|
	`osascript -e 'tell application "#{userAction.chop}" to activate'`
	say "Opening #{userAction.chop}."
  end
  listen_for /quit program (.*)/i do |userAction|
	`osascript -e 'tell application "#{userAction.chop}" to quit'`
	say "Quitting #{userAction.chop}."
  end
end