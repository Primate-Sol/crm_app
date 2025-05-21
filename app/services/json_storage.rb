require "json"

class JsonStorage
  def self.read(file)
    path = Rails.root.join("data", file)
    JSON.parse(File.read(path))
  end

  def self.write(file, records)
    path = Rails.root.join("data", file)
    File.write(path, JSON.pretty_generate(records))
  end

  def self.find(file, id)
    read(file).find { |record| record["id"].to_i == id.to_i }
  end

  def self.save(file, new_record)
    records = read(file)
    new_id = (records.map { |r| r["id"].to_i }.max || 0) + 1
    new_record["id"] = new_id
    records << new_record
    write(file, records)
    new_record
  end

  def self.update(file, id, updated_record)
    records = read(file)
    records.map! do |r|
      r["id"].to_i == id.to_i ? updated_record.merge("id" => id.to_i) : r
    end
    write(file, records)
  end

  def self.delete(file, id)
    records = read(file).reject { |r| r["id"].to_i == id.to_i }
    write(file, records)
  end
end

