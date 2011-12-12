require 'cora'
require 'siri_objects'

#######
# This is a plugin for sending Google Voice SMS messages.
# Edit to your heart's content!
# 
# Created by Ian McDowell - www.ianmcdowell.net
######

class SiriProxy::Plugin::GoogleVoice < SiriProxy::Plugin
  def initialize(config)
    #if you have custom configuration options, process them here!
  end
  
  listen_for /Send a text using Google Voice/i do
    gvnumber = ask "What number?"
    gvmessage = ask "What should it say?"
    say "New message to #{gvnumber}"
    say "It says: #{gvmessage}"
    sendyn = ask "Ready to send?"
    sendyn.strip!
	if sendyn == "Yes"
	`php ./plugins/siriproxy-googlevoice/lib/sendsms.php #{gvnumber} "#{gvmessage}"`
	say "Message Sent."
	else
	say "OK. I won't send it!"
	end
    request_completed
  end
end