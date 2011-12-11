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
    
listen_for /open program (.*)/i do |userAction|
    while userAction.empty? do
    userAction = ask "What program?"
    end
	`osascript -e 'tell application "#{userAction.chop}" to activate'`
	say "Opening #{userAction.chop}."
    request_completed
end
listen_for /quit program (.*)/i do |userAction|
    while userAction.empty? do
        userAction = ask "What program?"
    end
    `osascript -e 'tell application "#{userAction.chop}" to quit'`
	say "Quitting #{userAction.chop}."
    request_completed
end
  playingname = %x[osascript -e 'tell application "iTunes" to name of current track as string']
  playingartist = %x[osascript -e 'tell application "iTunes" to artist of current track as string']

  listen_for /itunes (.*)/i do |userAction|
      userAction.strip!
	if userAction == "pause" or userAction == "stop playing" or userAction == "stop" then
		`osascript -e 'tell application "iTunes" to pause'`
		say "I paused iTunes for you."
	elsif userAction == "play" or userAction == "start playing" or userAction == "start" then
		`osascript -e 'tell application "iTunes" to play'`
            playingname = %x[osascript -e 'tell application "iTunes" to name of current track as string']
            playingartist = %x[osascript -e 'tell application "iTunes" to artist of current track as string']
		say "Playing #{playingname} by #{playingartist}"
	elsif userAction == "next" or userAction == "next track" or userAction == "next song" then
		`osascript -e 'tell application "iTunes" to next track'`
            playingname = %x[osascript -e 'tell application "iTunes" to name of current track as string']
            playingartist = %x[osascript -e 'tell application "iTunes" to artist of current track as string']
        say "Playing the next track: #{playingname} by #{playingartist}"
	elsif userAction == "previous" or userAction == "previous track" or userAction == "previous song" then
		`osascript -e 'tell application "iTunes" to previous track'`
    playingname = %x[osascript -e 'tell application "iTunes" to name of current track as string']
    playingartist = %x[osascript -e 'tell application "iTunes" to artist of current track as string']
		say "Playing the previous track: #{playingname} by #{playingartist}"
	elsif userAction == "mute" then
		`osascript -e 'tell application "iTunes" to set mute to true'`
		say "iTunes was muted."
	elsif userAction == "mute off" or userAction == "unmute" then
		`osascript -e 'tell application "iTunes" to set mute to false'`
		say "iTunes was unmuted."
	elsif userAction == "volume up" or userAction == "turn it up" or userAction == "raise the volume" or userAction == "louder" then
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
    elsif userAction == "volume down" or userAction == "turn it down" or userAction == "lower the volume" or userAction == "softer" or userAction == "quieter" then
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
    elsif userAction == "visuals" or userAction == "visualizer" then
        `osascript -e 'tell application "iTunes" to activate' -e 'tell application "iTunes" to set visuals enabled to true'`
        say "Damn...look at those visuals!"
    elsif userAction == "stop visuals" or userAction == "stop the visualizer" then
        `osascript -e 'tell application "iTunes" to activate' -e 'tell application "iTunes" to set visuals enabled to false'`
        say "Ok. I turned off the visualizer."
    else
		say "That isn't something I can do right now."
	end
	request_completed
   end
  listen_for /type on my computer/i do
	begin
	whattotype = ask "What should I type for you?"
        if whattotype == "Tab "
            `osascript -e 'tell application "System Events" to keystroke tab'`
            say "Tab key."
            more = "1"
        elsif whattotype == "down" or whattotype == "down arrow"
            `osascript -e 'tell application "System Events" to keystroke (ASCII character 31) --down arrow'`
            say "Going down."
            more = "1"
        elsif whattotype == "up" or whattotype == "up arrow"
            `osascript -e 'tell application "System Events" to keystroke (ASCII character 30) --up arrow'`
            say "Going up."
            more = "1"
        elsif whattotype == "right" or whattotype == "right arrow"
            `osascript -e 'tell application "System Events" to keystroke (ASCII character 29) --right arrow'`
            say "Going right."
            more = "1"
        elsif whattotype == "left" or whattotype == "left arrow"
            `osascript -e 'tell application "System Events" to keystroke (ASCII character 28) --left arrow'`
            say "Going left."
            more = "1"
        elsif whattotype == "Nothing " or whattotype == "Stop "
            more = "0"
            say "Ok, I won't type anything. Goodbye."
        else
            `osascript -e 'tell application "System Events" to keystroke "#{whattotype}"'`
            more = ask "Anything else?"
            more.strip!
            if more == "Tab" or more == "Next"
                more = "1"
                `osascript -e 'tell application "System Events" to keystroke tab'`
                say "Ok."
                elsif more == "Yes" or more == "Yeah" or more == "Sure"
                more = "1"
                say "Ok."
                else
                more = "0"
                say "Ok, I won't type anything else. Goodbye."
            end
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
  listen_for /hide this window/i do
      `osascript -e 'tell application "System Events" to keystroke "h" using command down'`
      say "Ok. I hid that window. Oh no..can you find it?"
      request_completed
  end
  listen_for /hide all other windows/i do
      `osascript -e 'tell application "System Events" to keystroke "h" using {command down, option down}'`
      say "I hid all of the other windows. Where did they go??"
      request_completed
  end
  listen_for /show the desktop/i do
      `osascript -e 'do shell script "/Applications/Utilities/Expose.app/Contents/MacOS/Expose 1"'`
      say "I hid your windows, can you find them?"
      request_completed
  end
  listen_for /show all windows/i do
      `osascript -e 'tell application "System Events" to set visible of (every process whose visible is false) to true'`
      say "All windows are now visible."
      request_completed
  end
  listen_for /start my screensaver/i do
      `osascript -e 'do shell script "/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine"'`
      say "Screensaver started."
      request_completed
  end
  listen_for /toggle fullscreen/i do
      `osascript -e 'tell application "System Events" to keystroke "f" using {control down, command down}'`
      say "Full screen mode toggled."
      request_completed
  end
  listen_for /mission control/i do
      `osascript -e 'tell application "System Events" to keystroke (ASCII character 30) using control down --up arrow'`
      say "There you go."
      request_completed
  end
  listen_for /next space/i do
      `osascript -e 'tell application "System Events" to keystroke (ASCII character 29) using control down -- right arrow'`
      say "Moving to the next space in Mission Control."
      request_completed
  end
  listen_for /previous space/i do
      `osascript -e 'tell application "System Events" to keystroke (ASCII character 28) using control down -- right arrow'`
      say "Moving to the previous space in Mission Control."
      request_completed
  end
  listen_for /mail (.*)/i do |userAction|
  userAction.strip!
      if userAction == "check for new" or userAction == "check" or userAction == "unread" or userAction == "get new" then
          `osascript -e 'tell application "Mail" to check for new mail for every account'`
          numofnew = `osascript -e 'tell application "Mail" to unread count of inbox as integer'`
          numofnew = Integer(numofnew)
          if numofnew < 1 then
              say "You have no new messages."
          elsif numofnew == 1 then
              say "You have 1 new message."
          else
              say "You have #{numofnew} new messages."
          end
      elsif userAction == "new" or userAction == "new message" then
          `osascript -e 'tell application "Mail" to make new outgoing message with properties {visible:true}'`
          say "New message created."
      elsif userAction == "send" then
          `osascript -e 'tell application "Mail" to send theMessage'`
          say "Message sent."
      else
          say "That isn't something I can do right now."
      end
  request_completed
  end
  listen_for /transmission (.*)/i do |userAction|
  userAction.strip!
      if userAction == "pause" or userAction == "pause all" or userAction == "pause transfers" then
          `osascript -e 'tell application "Transmission" to activate' -e 'tell application "System Events" to tell process "Transmission" to keystroke "." using {option down, command down}'`
          say "All transfers were paused."
      elsif userAction == "start" or userAction == "start all" or userAction == "start transfers" then
          `osascript -e 'tell application "Transmission" to activate' -e 'tell application "System Events" to tell process "Transmission" to keystroke "/" using {option down, command down}'`
          say "All transfers were started."
      else
          say "That isn't something I can do right now."
      end
  request_completed
  end
end