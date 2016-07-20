module WriteLogFile
  def puts_log_file(name_log_file, error, description)
    begin
      Dir.mkdir("#{LOG_FILE_PATH}/#{Time.now.strftime("%F")}")
    rescue

    end
    dir_log_files = "#{LOG_FILE_PATH}/#{Time.now.strftime("%F")}"

    begin
      log_file = File.open("#{dir_log_files}/#{name_log_file}_#{Time.now.strftime("%F")}_#{@token_key.to_s.gsub('"','')}.txt", "a")
    rescue
      log_file = File.new("#{dir_log_files}/#{name_log_file}_#{Time.now.strftime("%F")}_#{@token_key.to_s.gsub('"','')}.txt",'wb')
    end
    log_file.write("#{Time.now.strftime("%H:%M:%S")} #{error}\n   DESCRIPTION: #{description}\n".to_s)
    log_file.close
  end

end