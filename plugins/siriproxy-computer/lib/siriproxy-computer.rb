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
            playingname = %x[osascript -e 'tell application "iTunes" to name of current track as string']
            playingartist = %x[osascript -e 'tell application "iTunes" to artist of current track as string']
		say "Playing #{playingname} by #{playingartist}"
	elsif userAction == "next" or userAction == "next " or userAction == "next track" or userAction == "next track " or userAction == "next song " then
		`osascript -e 'tell application "iTunes" to next track'`
            playingname = %x[osascript -e 'tell application "iTunes" to name of current track as string']
            playingartist = %x[osascript -e 'tell application "iTunes" to artist of current track as string']
        say "Playing the next track: #{playingname} by #{playingartist}"
	elsif userAction == "previous" or userAction == "previous " or userAction == "previous track" or userAction == "previous track " or userAction == "previous song " then
		`osascript -e 'tell application "iTunes" to previous track'`
    playingname = %x[osascript -e 'tell application "iTunes" to name of current track as string']
    playingartist = %x[osascript -e 'tell application "iTunes" to artist of current track as string']
		say "Playing the previous track: #{playingname} by #{playingartist}"
	elsif userAction == "mute" or userAction == "mute " then
		`osascript -e 'tell application "iTunes" to set mute to true'`
		say "iTunes was muted."
	elsif userAction == "mute off" or userAction == "mute off " or userAction == "unmute" or userAction == "unmute " then
		`osascript -e 'tell application "iTunes" to set mute to false'`
		say "iTunes was unmuted."
	elsif userAction == "volume up" or userAction == "volume up " or userAction == "turn it up " or userAction == "raise the volume " or userAction == "louder " then
		currentvol = `osascript -e 'tell application "iTunes" to sound volume as integer'`
		newvol = (currentvol.to_i + 20)
		if newvol > 100 then
			newvol = 100
		end
		`osascript -e 'tell application "iTunes" to set sound volume to #{newvol}'`
		say "Volume was raised to #{newvol} percent."
        begin
            keepgoing = ask "Is that good?"
            keepgoing.strip!
            if keepgoing == "No" or keepgoing == "Nope" or keepgoing == "Keep going" or keepgoing == "That isn't good" or keepgoing == "That's not good" then
                keepgoing = "1"
                currentvol = `osascript -e 'tell application "iTunes" to sound volume as integer'`
                newvol = (currentvol.to_i + 20)
                if newvol < 0 then
                    newvol = 0
                end
                `osascript -e 'tell application "iTunes" to set sound volume to #{newvol}'`
                say "Volume was raised to #{newvol} percent."
                else
                keepgoing = "0"
                say "Ok. Keeping volume at #{newvol} percent."
            end
        end while keepgoing == "1"
    elsif userAction == "volume down" or userAction == "volume down " or userAction == "turn it down " or userAction == "lower the volume " or userAction == "softer " or userAction == "quieter " then
		currentvol = `osascript -e 'tell application "iTunes" to sound volume as integer'`
		newvol = (currentvol.to_i - 20)
		if newvol < 0 then
			newvol = 0
		end
		`osascript -e 'tell application "iTunes" to set sound volume to #{newvol}'`
		say "Volume was lowered to #{newvol} percent."
        begin
        keepgoing = ask "Is that good?"
            keepgoing.strip!
        if keepgoing == "No" or keepgoing == "Nope" or keepgoing == "Keep going" or keepgoing == "That isn't good" or keepgoing == "That's not good" then
            keepgoing = "1"
            currentvol = `osascript -e 'tell application "iTunes" to sound volume as integer'`
            newvol = (currentvol.to_i - 20)
            if newvol < 0 then
                newvol = 0
            end
            `osascript -e 'tell application "iTunes" to set sound volume to #{newvol}'`
            say "Volume was lowered to #{newvol} percent."
        else
            keepgoing = "0"
            say "Ok. Keeping volume at #{newvol} percent."
        end
        end while keepgoing == "1"
            
	else
		say "That isn't something I can do right now."
	end
	request_completed
   end
  listen_for /open program (.*)/i do |userAction|
	`osascript -e 'tell application "#{userAction.chop}" to activate'`
	say "Opening #{userAction.chop}."
  request_completed
  end
  listen_for /quit program (.*)/i do |userAction|
	`osascript -e 'tell application "#{userAction.chop}" to quit'`
	say "Quitting #{userAction.chop}."
  request_completed
  end
  listen_for /type on my computer/i do
	begin
	whattotype = ask "What should I type for you?"
	`osascript -e 'tell application "System Events" to keystroke "#{whattotype}"'`
	more = ask "Anything else?"
        more.strip!
	if more == "Yes" or more == "Yeah" or more == "Sure"
        more = "1"
        say "Ok."
    else
        more = "0"
        say "Ok, I won't type anything else. Goodbye."
    end
    end while more == "1"
    request_completed
  end
  listen_for /open a website/i do
      url = ask "What URL?"
      url.gsub!(/ /,'')
      `osascript -e 'open location "http://#{url.downcase}"'`
      say "Opening #{url.downcase} in your web browser."
  request_completed
  end
  listen_for /spotlight search/i do
      text = ask "What do you want to search for?"
      text.strip!
      `osascript -e 'tell application "System Events" to keystroke space using {command down, option down}'`
      sleep(1)
      `osascript -e 'tell application "System Events" to keystroke "#{text}"'`
      say "Searching for #{text}."
      request_completed
  end
  listen_for /hide all windows/i do
      `osascript -e 'tell application "System Events" to set visible of (every process whose visible is true) to false'`
      say "I hid your windows, can you find them?"
      request_completed
  end
  listen_for /show all windows/i do
      `osascript -e 'tell application "System Events" to set visible of (every process whose visible is false) to true'`
      say "All windows are now visible."
      request_completed
  end
end