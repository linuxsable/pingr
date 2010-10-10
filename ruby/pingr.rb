# Author: @_ty
# Enjoy!
require 'net/smtp'
require 'twiliolib'
require File.dirname(__FILE__) + '/lib/helpers'

HOSTS = ['google.com', '192.168.1.1']
EMAIL = 'linuxsable@gmail.com'
PHONE_NUMBER = '408'
PING_COUNT = 4

puts '-- Pingr running --'
start_time = Time.now

HOSTS.each do |host|
  puts "Checking #{host}.."
  c = run_ping(host, PING_COUNT)
  if c.to_i === 0
    message = "Host: #{host} is down (ping failed) at #{Time.now.strftime("%B %d, %Y")}"
    puts message
    send_email_alert(message, EMAIL, host)
  else
    puts "Host: #{host} is up"
  end
end

elapsed_time = ("%.2f" % (Time.now - start_time))
puts "-- Pingr done. Took #{elapsed_time} seconds --"