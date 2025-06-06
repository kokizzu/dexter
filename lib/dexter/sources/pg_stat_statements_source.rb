module Dexter
  class PgStatStatementsSource
    def initialize(connection)
      @connection = connection
    end

    def perform(collector)
      stat_statements.each do |row|
        collector.add(row["query"], row["duration_ms"].to_f, row["calls"].to_i)
      end
    end

    # could group, sum, and filter min_time/min_calls in SQL, but keep simple for now
    def stat_statements
      sql = <<~SQL
        SELECT
          query,
          total_plan_time + total_exec_time AS duration_ms,
          calls
        FROM
          pg_stat_statements
        INNER JOIN
          pg_database ON pg_database.oid = pg_stat_statements.dbid
        WHERE
          datname = current_database()
        ORDER BY
          1
      SQL
      @connection.execute(sql)
    rescue PG::UndefinedTable => e
      raise Error, e.message
    end
  end
end
