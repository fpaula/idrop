class Vote < ActiveRecord::Base
  scope :created_between, lambda { |start_date, end_date|
    where("created_at >= ? AND created_at <= ?", start_date.strftime('%Y-%m-%d'), end_date.strftime('%Y-%m-%d'))
  }

  # TODO
  def self.count_by_date(start_date, end_date)
    created_between(7.days.ago, Time.now)
    .select("DATE_FORMAT(created_at, '%Y-%m-01') AS date, count(id) AS total")
    #.map {|x| [:id, :created_at]}
    #.group_by(&:created_at)
  end
end