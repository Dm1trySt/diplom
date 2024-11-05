module Reports
  module Base
    class Period
      include Comparable

      attr_reader :name, :start_date, :end_date, :identifier, :identifier_params

      def initialize(identifier=nil, per_day=false)


        if per_day
          day = identifier.nil? ? Date.today : Date.strptime(identifier.to_s, '%Y-%m-%d')
          @start_date = day
          @end_date = day
        else
          date = identifier.nil? ? Date.today : Date.strptime(identifier.to_s, '%Y-%m')
          @start_date = self.class.prepare_start_date(date)
          @end_date = self.class.prepare_end_date(date)
          raise 'Invalid period' if @start_date > @end_date
          generate_name(@start_date)
          generate_identifier(@start_date)
        end
      end

      def to_s
        @identifier
      end

      def month_name(date)
        I18n.t('date.standalone_month_names')[date.month]
      end

      protected

      # 1-ый день месяца
      def self.prepare_start_date(date)
        date.at_beginning_of_month
      end

      # последний день месяца
      def self.prepare_end_date(date)
        date.at_end_of_month
      end

      def generate_identifier(date)
        @identifier = date.strftime('%Y-%m')

        @identifier_params = {
            :month      => date.month,
            :year       => date.year,
            :month_name => month_name(date)
        }
      end

      def generate_name(date)
        @name = date.strftime( month_name(date) + ' %Y' )
      end
    end
  end
end
