class ConsolidadeClicksJob < ApplicationJob
  queue_as :default


  def perform(*args)
    sqlite_sql = <<-SQL
      SELECT 
        link_id as link_id,
        strftime('%Y-%m-%d %H:00:00', created_at) as period,
        COUNT(*) as occurrences
      FROM 
        clicks
      WHERE
        datetime(created_at) > datetime('now', '-24 hours')
      GROUP BY 
        period, link_id
      ORDER BY 
        period;
    SQL

    results = ActiveRecord::Base.connection.execute(sqlite_sql)
    results.each do |row|
      click_statistic = ClickStatistic.find_by(period: row[:period], link_id: row[:link_id])
      if click_statistic
        click_statistic.update(occurrences: row[:occurrences])
      else
        ClickStatistic.create(link_id: row[:link_id], period: row[:period], occurences: row[:occurrences])
      end
    end
  end
end
