module Dexter
  class JsonLogParser < LogParser
    FIRST_LINE_REGEX = /\A.+/

    def perform
      @logfile.each_line do |line|
        row = JSON.parse(line.chomp)
        if (m = REGEX.match(row["message"]))
          # replace first line with match
          # needed for multiline queries
          active_line = row["message"].sub(FIRST_LINE_REGEX, m[3])

          add_parameters(active_line, row["detail"]) if row["detail"]
          process_entry(active_line, m[1].to_f)
        end
      end
    rescue JSON::ParserError => e
      raise Dexter::Abort, "ERROR: #{e.message}"
    end
  end
end
