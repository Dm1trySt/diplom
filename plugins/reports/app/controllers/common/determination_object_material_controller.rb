class Common::DeterminationObjectMaterialController < BaseReportController
  # before_action :check_access

  def index
    @title = Reports::Common::DeterminationObjectMaterial::Report.title


  end

  def generate_data

  end

  def get_data
    report = Reports::Common::DeterminationObjectMaterial::Report.new(params[:period])

    render json: report.get_data || { success: false }
  end

  def get_xlsx_data
    report = Reports::Common::DeterminationObjectMaterial::Report.new(params[:period])

    @data = report.get_data

    filename = "#{report.class.title} (#{report.date_from} - #{report.date_to}).xlsx"
    respond_to do |format|
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="' + filename + '"'
      }
    end
  end

  private

  def check_access
    #render_403 unless Reports::OKO::ProjectsTimeSpent::Report.access_for_user?
  end
end
