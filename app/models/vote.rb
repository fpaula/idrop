class Vote < ActiveRecord::Base
  scope :created_between, lambda { |start_date, end_date|
    where("created_at >= ? AND created_at <= ?", start_date.strftime('%Y-%m-%d'), end_date.strftime('%Y-%m-%d'))
  }

  def self.count_by_date(start_date, end_date)
    date = 'DATE(created_at)'

    created_between(start_date, end_date)
      .select("#{date} AS created_at, count(id) AS total")
      .group(date)
      .map { |vote| [vote.created_at.strftime('%Y-%m-%d'), vote['total']] }
  end
end