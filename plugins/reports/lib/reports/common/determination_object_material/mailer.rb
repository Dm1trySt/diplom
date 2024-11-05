module Reports
  module Common
    module DeterminationObjectMaterial
      class Mailer < ActionMailer::Base
        default from: "from@example.com"

        layout "mailer"


        def _prefixes
          @_prefixes ||= ['mailer/common/determination_object_material']
        end


        def report(recipient, data )
          @data = data

          mail to: recipient&.mail, subject: "Определение материалов бытовых отходов за #{(Date.today - 1.day).strftime('%d.%m.%Y')}"
        end
      end
    end
  end
end
