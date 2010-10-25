# Yaml flat database
class DB
  @@database_path = File.dirname(__FILE__) + '/../db/db.yaml'
    
  def initialize
    load
    p get_last_email_sent_date('linuxsable@gmail.com')
  end
  
  def save(data)
    open(@@database_path, 'w') { |f| YAML.dump(data, f) }
  end
  
  def load
    @data = open(@@database_path) { |f| YAML.load(f) }
  end
  
  # email => last_sent
  def get_last_email_sent_date(email)
    @data[email]
  end
  
  def update_last_sent_date(email)
    @data[email] => Time.now
  end
  
  # phone_number => last_sent
  def get_last_text_sent_date(phone_number)
    @data[phone_number]
  end
  
  def updated_last_text_sent(phone_number)
    @data[phone_number] => Time.now
  end
end