# Author: @_ty
# Enjoy!
require 'net/smtp'
require 'twiliolib'

HOSTS = ['192.168.1.1', 'google.com']
EMAIL = 'linuxsable@gmail.com'
PHONE_NUMBER = '408'
PING_COUNT = 4

puts '-- Pinger Running --'

HOSTS.each do |host|
  puts "Checking #{host}"
  c = `ping -c #{PING_COUNT} #{host} | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }'`
  if c.to_i === 0
    message = "Host: #{host} is down (ping failed) at #{Time.now.strftime("%B %d, %Y")}"
    puts message
    `echo "#{message}" | mail -s "ALERT: Host #{host} is down!" #{EMAIL}`
  else
    puts "Host: #{host} is up"
  end
end

puts '-- Pinger Done --'