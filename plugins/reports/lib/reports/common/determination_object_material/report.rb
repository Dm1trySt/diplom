module Reports::Common::DeterminationObjectMaterial
  class Report < Reports::Base::Report

    def initialize(date, per_day=false)
      super()

      period = Reports::Base::Period.new(date, per_day)

      @date_from = period.start_date.beginning_of_day
      @date_to = period.end_date.end_of_day
    end

    def get_data
        DeterminationObjectMaterial.where(date: @date_from..@date_to).map do |record|
        {
          type: record.object_type,
          count: record.count,
          month: record.month,
          year: record.year,
          details: get_details(record)
        }
      end
    end

    def self.available_periods
      periods = DeterminationObjectMaterial.order('date DESC').pluck(:date).uniq.map { |s| Reports::Base::Period.new(s) }

      [Reports::Base::Period.new] | periods
    end

    def self.title
      'Определение материалов бытовых отходов'
    end

    def self.path
      'determination_object_material_report_path'
    end


    private

    def get_details(record)
      DeterminationObjectMaterialDetail.where(determination_object_material_id: record.id,
                                              year: record.year,
                                              month: record.month).order('day ASC').map do |detail|
        {object: detail.object_name,
         data: detail.created_at.strftime('%d.%m.%Y %H:%M'),
         address: detail.address,
         object_type: detail.determination_object_material&.object_type}
      end
    end
  end
end
