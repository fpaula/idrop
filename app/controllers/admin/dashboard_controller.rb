class Admin::DashboardController < Admin::AdminController
  def index
    @votes_per_day = Vote.count_by_date(7.days.ago, Time.now)
  end
end