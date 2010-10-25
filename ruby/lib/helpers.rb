def run_ping(host, ping_count)
  `ping -c #{ping_count} #{host} | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }'`
end

def send_email_alerts(msg, emails = [], host)
  emails.each do |email|
    send = false
    last_sent = DB.get_record(email)
    
    if last_sent
      if Time.now > (last_sent + (ALERT_INTERVAL * 60))
        DB.save_or_update_time(email)
        send = true
      else
        puts "Email alert to #{email} was supressed."
      end
    else
      DB.save_or_update_time(email)
      send = true
    end
    
    if send
      `echo "#{msg}" | mail -s "ALERT: Host #{host} is down!" #{email}`
      puts "Email alert sent to #{email}!"
    end
  end
end

# Use Twilio to send out text alerts
def send_text_alerts(account_sid, account_token, api_version, phone_nums = [], message)
  phone_nums.each do |phone_num|
    send = false
    last_sent = DB.get_record(phone_num)
    
    if last_sent
      if Time.now > (last_sent + (ALERT_INTERVAL * 60))
        DB.save_or_update_time(phone_num)
        send = true
      else
        puts "Text alert to #{phone_num} was supressed."
      end
    else
      DB.save_or_update_time(phone_num)
      send = true
    end
    
    if send
      account = Twilio::RestAccount.new(account_sid, account_token)
      begin
        resp = account.request("/#{api_version}/Accounts/#{account_sid}/SMS/Messages", 'POST', {
            'From'  => TWILIO_PHONE_NUMBER,
            'To'    => phone_num,
            'Body'  => message,
        })
        puts "Text alert sent to #{phone_num}!"
      rescue Exception
        puts "Error sending text to #{phone_num}!"
      end
    end
  end
end