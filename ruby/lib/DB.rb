# Yaml flat database
class DB
  @@database_path = File.dirname(__FILE__) + '/../db/db.yaml'
  
  def self.save(data)
    open(@@database_path, 'w') { |f| YAML.dump(data, f) }
  end
  
  def self.load
    out = {}
    open(@@database_path) do |f|
      loaded_data = YAML.load(f)
      if loaded_data
        out = loaded_data
      end
    end
    out
  end
  
  # Returns false if record can't be found
  def self.get_record(record)
    data = self.load
    if data[record] == nil
      false
    else
      data[record]
    end
  end
  
  # Return 'new' if it's a new save,
  # 'update' if it's an update
  def self.update_record(record)
    data = self.load
    out = 'update'
    if data[record] == nil
      out = 'new'
    end
    data[record] = Time.new
    self.save(data)
    out
  end
end