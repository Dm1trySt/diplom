namespace :project do
  namespace :reports do
    namespace :common do

      desc 'Сбор отчета по материалов бытовых отходов'
      task :determination_material_of_the_object => :environment do
        report = Reports::Common::DeterminationObjectMaterial::Report.new((Date.today - 2.day), true)
        data = report.get_data
        recipients = User.find [1, 5]
        recipients.each do |recipient|
          Reports::Common::DeterminationObjectMaterial::Mailer.report(recipient, data).deliver_now
        end
      end

        desc 'Определение материалов бытовых отходов'
        task :determination_material_of_the_object => :environment do
          worker = Delayed::Worker.new
          worker.run Delayed::Job.first
          ::Common::DeterminationObjectMaterialJob.perform_later
       end
    end
  end
end
