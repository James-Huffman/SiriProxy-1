require 'cora'
require 'siri_objects'
require 'rubygems'
require 'csv'
require 'socket'

module MyConfig
    @mac_address_hash = {}
    @host_hash = {}
    @local_hash = {}
    @port_hash = {}
    CSV.foreach("./plugins/siriproxy-wakeonlan/lib/config.csv") do |row|
    name, mac_address, host, local, port = row
    next if name == "Name"
    @mac_address_hash[name] = mac_address
    @host_hash[name] = host
    @local_hash[name] = local
    @port_hash[name] = port
end

def self.mac_address(computer_name)
@mac_address_hash[computer_name]
end

def self.host(computer_name)
@host_hash[computer_name]
end

def self.local(computer_name)
@local_hash[computer_name]
end

def self.port(computer_name)
@port_hash[computer_name]
end

end

class SiriProxy::Plugin::WakeOnLAN < SiriProxy::Plugin
    def initialize(config)
        #if you have custom configuration options, process them here!
    end
    
listen_for /wake up my (.*)/i do |userAction|
	userAction.strip!
	userAction.capitalize!
	if userAction == "computer" then
		userAction = ask "Which one should I wake up?"
	else
        mac_address = MyConfig.mac_address("#{userAction}")
        host = MyConfig.host("#{userAction}")
        local = MyConfig.local("#{userAction}")
        port = MyConfig.port("#{userAction}")
        message = (0xff.chr)*6+(mac_address.split(/:/).pack("H*H*H*H*H*H*"))*16
        txbytes = UDPSocket.open do |so|
            if local == "true" then
                so.setsockopt( Socket::SOL_SOCKET, Socket::SO_BROADCAST, true )
            end
        so.send(message, 0, host, port)
    end
    say "Wake on LAN packet sent successfully!"
	end
request_completed
end
end