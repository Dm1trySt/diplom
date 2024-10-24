module Reports
  module Base
    class Report
      attr_accessor :date_from, :date_to, :user, :data

      def initialize(*args)
        @user = User.current
        @data = nil
        @date_from = nil
        @date_to = nil
      end

      def date_from=(value)
        if value.respond_to? :to_date
          @date_from = value.to_date
        else
          raise 'Invalid date_from'
        end
      end

      def date_to=(value)
        if value.respond_to? :to_date
          @date_to = value.to_date
        else
          raise 'Invalid date_to'
        end
      end

      def get_data
        raise 'Not implemented'
      end

      def generate_data
        raise 'Not implemented'
      end

      def self.access_for_user?(user = User.current)
        user.admin?
      end

      def self.title
        raise 'Not implemented'
      end

      def self.path
        name = self.name.split('::')
        "#{name.third}_#{name.fourth}_path".downcase
      end
    end
  end
end
