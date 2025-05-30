module Dexter
  class LogParser
    REGEX = /duration: (\d+\.\d+) ms  (statement|execute [^:]+): (.+)/

    def initialize(logfile)
      @logfile = logfile
    end

    private

    def add_parameters(active_line, details)
      if details.start_with?("parameters: ")
        params = Hash[details[12..-1].split(", ").map { |s| s.split(" = ", 2) }]

        # make sure parsing was successful
        unless params.value?(nil)
          params.each do |k, v|
            active_line.sub!(k, v)
          end
        end
      end
    end
  end
end
