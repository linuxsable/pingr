def run_ping(host, ping_count)
  `ping -c #{ping_count} #{host} | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }'`
end

def send_email_alerts(msg, emails = [], host)
  emails.each do |email|
    
    `echo "#{msg}" | mail -s "ALERT: Host #{host} is down!" #{email}`
    puts "Email alert sent to #{email}!"
  end
end

# Use Twilio to send out text alerts
def send_text_alerts(account_sid, account_token, api_version, phone_nums = [], message)
  phone_nums.each do |phone_num|
    d = {
        'From'  => '415-599-2671',
        'To'    => phone_num,
        'Body'  => message,
    }
    account = Twilio::RestAccount.new(account_sid, account_token)
    begin
      resp = account.request("/#{api_version}/Accounts/#{account_sid}/SMS/Messages", 'POST', d)
      puts "Text alert sent to #{phone_num}!"
    rescue Exception => e
      puts "Error sending text to #{phone_num}!"
    end
  end
end