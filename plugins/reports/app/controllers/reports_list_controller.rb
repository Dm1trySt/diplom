class ReportsListController < AccountController
  before_action :require_login

  def index
    @reports = Reports::Base::Report.descendants.select do |report|
      report.access_for_user? && report.title && report.path rescue false
    end
    @reports.sort_by!(&:title)
  end
end
