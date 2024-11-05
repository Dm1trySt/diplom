module Common
  class DeterminationObjectMaterialJob < BaseJob
    queue_as :common_features

    # Прогон сделанных фото через API Hugging Face
    # https://huggingface.co/Salesforce/blip-image-captioning-large
    def perform
      records = Dir.glob("#{Rails.root}/plugins/reports/assets/determination_material_images/*.txt")
      records.each do |record|
        address_images = File.read(record)
        next if address_images.blank?
        address_images.split(/\n/).each do |address|

          #Authorization: hf_YOUR_API_KEY
          request = HTTParty.post("https://api-inference.huggingface.co/models/Salesforce/blip-image-captioning-large",
                                  :headers => {Authorization: 'Bearer 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' },
                                  :body => "#{address}")

          obj_description = JSON.parse(request.body, symbolize_names: true)&.first[:generated_text] if request.ok?


          urn_address = "г. Тамбов, ул.Советская 149Б"
          case
          when obj_description.include?("plastic")
            type = "Пластик"
          when obj_description.include?("glass")
            type = "Стекло"
          when obj_description.include?("aluminum")
            type = "Алюминий"
          when obj_description.include?("paperboard")
            type = "Картон"
          else
            type = "Не удалось определить"
          end

          case
          when obj_description.include?("bottle")
            object = "Бутылка"
          when obj_description.include?("pot")
            object = "Банка"
          else
            object = "Не удалось определить"
          end


          check_or_create_report_object(object, type, urn_address) if object && type

        end
        File.open(record, "w") {}
      end
    end

    private

    def check_or_create_report_object(object, type, address)

      date = Date.current

      material = DeterminationObjectMaterial.where(object_type: type,
                                                   year: date.year,
                                                   month: date.month).first
      unless material.present?
        material = DeterminationObjectMaterial.create!(object_type: type,
                                                       month: date.month,
                                                       year: date.year,
                                                       date: date)
      else
        material.update_attribute :count, material.count + 1
      end

      if material.present?

        DeterminationObjectMaterialDetail.create!(determination_object_material_id: material.id,
                                                  object_name: object,
                                                  address: address,
                                                  day: date.day,
                                                  month: date.month,
                                                  year: date.year)
      end
    end
  end
end
