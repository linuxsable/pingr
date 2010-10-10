# Send an email alert
def send_email_alert(msg, email, host)
  `echo "#{msg}" | mail -s "ALERT: Host #{host} is down!" #{email}`
  puts "Email alert sent to #{email}!"
end

def run_ping(host, ping_count)
  `ping -c #{ping_count} #{host} | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }'`
end