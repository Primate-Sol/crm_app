require 'json'
require 'fileutils'
require 'monitor'

class JsonFileStore
  include MonitorMixin

  def initialize(file_path)
    super()
    @file_path = file_path
    FileUtils.mkdir_p(File.dirname(@file_path))
    File.write(@file_path, "[]") unless File.exist?(@file_path)
  end

  def read
    synchronize do
      file = File.read(@file_path)
      JSON.parse(file, symbolize_names: true)
    rescue JSON::ParserError => e
      Rails.logger.error "Failed to parse #{@file_path}: #{e.message}"
      []
    end
  end

  def write(data)
    synchronize do
      json = JSON.pretty_generate(data)
      File.write(@file_path, json)
    end
  end
end
