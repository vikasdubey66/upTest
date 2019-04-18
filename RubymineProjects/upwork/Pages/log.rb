# Logger Initialization


class Log
  @logger = Logger.new(STDOUT)
  @logger.level = Logger::INFO

  # #######################################################
  # Variable for step counting
  # Variables for warn/error counting
  # Used for publish results
  # ######################################################
  @count_last_step = 1
  @warnings = 0
  @errors = 0



  # step message
  def self.step(message)
    @logger.unknown(" [#{@count_last_step}] #{message}:")
    @count_last_step += 1
  end

  # when action is completed
  def self.done(message = nil)
    self.message(message) unless message.nil?

    puts "\n"
  end

  # regular messages(INFO LOGGER)
  def self.message(message)
    @logger.info(message)
  end

  # warning message(WARN LOGGER)
  def self.warning(message)
    @logger.warn(message)

    @warnings += 1
  end

  # unhandled fatal errors(FATAL LOGGER)
  def self.error(message, is_fatal = false)
    if is_fatal
      @logger.fatal(message)
      exit
    else
      @logger.error(message)
    end

    @errors += 1
  end

  # display results in the end
  def self.publish_results
    puts '*************************'
    puts 'Execution Finished'
    puts '*************************'
    puts " > Total Steps: [#{@count_last_step - 1}]"
    puts " > Total Warns: [#{@warnings}]"
    puts " > Total Errors: [#{@errors}]"
    puts '*************************'
  end
end