# Author: @_ty
#
# Made in Vegas. Enjoy!
#
require 'net/smtp'
require 'yaml'
require 'twiliolib'
require File.dirname(__FILE__) + '/lib/helpers'
require File.dirname(__FILE__) + '/lib/DB'

# Hosts which need to be checked
HOSTS = ['localhost']

# Emails which alerts will be sent to
EMAILS = ['linuxsable@gmail.com']

# Phone numbers which texts will be sent to
PHONE_NUMBERS = []

# Number of times ping checks the host.
# This shouldn't need to be changed.
PING_COUNT = 4

# Span in minutes between alerts
ALERT_INTERVAL = 5

# Twilio Config
TWILIO_API_VERSION   = '2010-04-01'
TWILIO_ACCOUNT_SID   = ''
TWILIO_ACCOUNT_TOKEN = ''

puts '-- Pingr running --'

start_time = Time.now

HOSTS.each do |host|
  puts "Checking #{host}.."
  c = run_ping(host, PING_COUNT)
  if c.to_i === 0
    message = "Host #{host} is down (ping failed) at #{Time.now.strftime("%Y-%m-%d %I:%M%p")}"
    puts message
    send_email_alerts(message, EMAILS, host)
    send_text_alerts(TWILIO_ACCOUNT_SID, TWILIO_ACCOUNT_TOKEN, TWILIO_API_VERSION, PHONE_NUMBERS, message)
  else
    puts "Host #{host} is up"
  end
end

elapsed_time = ("%.2f" % (Time.now - start_time))
puts "-- Pingr done - took #{elapsed_time} seconds - #{HOSTS.count} host(s) checked --"