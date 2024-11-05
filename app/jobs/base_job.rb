class BaseJob < ActiveJob::Base
  attr_reader :max_execution_time, :performer, :unique_by
  queue_as :base

  class WrongArgumentsOrderError < StandardError; end

  around_enqueue do |job, block|
    next if job.unique? && self.class.enqueued_with_args?(arguments, unique_by)
    block.call
  end

  around_perform do |_, block|
    current_user = User.current
    User.current = performer

    begin
      Timeout.timeout(max_execution_time) { block.call }
    ensure
      User.current = current_user
    end
  end

  def initialize(*args)
    super

    @max_execution_time = self.class.max_execution_time
    @performer = self.class.performer
    @unique = self.class.unique?
    @unique_by = self.class.unique_by
  end

  def unique?
    @unique
  end

  def unique_by?
    @unique_by.present?
  end

  def service_information
    "\n\n{{collapse(Служебная информация)\n#{self.class.name}\n}}"
  end

  def delayed_job_record
    self.class.enqueued_jobs_with_args(self.class, arguments).find do |job|
      self.class.job_id(job) == job_id
    end
  end

  def delay_for(time)
    self.class.set(wait: time).perform_later(*arguments)
  end

  class << self
    attr_reader :unique_by

    # Время, за которое должно выполниться задание
    # По умолчанию не задано
    def max_execution_time(max_execution_time = nil)
      @max_execution_time ||= max_execution_time
    end

    # Пользователь, от имени которого будет запущено задание
    def performer(performer = nil)
      @performer = performer || @performer || User.admin
    end

    # unique(true) - проверка уникальности по всем аргументам.
    # unique(true, by: [User]) - проверка уникальности по первому аргументу, который должен принадлежать классу User
    # unique(true, by: [User, Issue]) - проверка по первому и второму аргументу.
    # unique(true, by: [User, false, Issue]) - проверка по первому и третьему аргументу
    # unique(true, by: [User, nil, Issue]) - проверка по первому и третьему аргументу
    def unique(unique = false, by: nil)
      @unique ||= unique
      @unique_by = by
    end

    # Возможно ли наличие двух заданий с одинаковым набором аргументов
    # По умолчанию уникальность не проверяется
    def unique?
      @unique.present?
    end

    # Получение заданий из очереди по классу +job_class+
    def enqueued_jobs_by_class(job_class)
      ::Delayed::Job.where("handler LIKE '%job_class: #{job_class.name}%'")
    end

    # Задания класса +job_class+, добавленные в очередь с указанными параметрами
    # Параметры должны идти в том же порядке, что и в самом задании
    # +checked_args+ - определяет нужные аргументы для проверки и их типы
    def enqueued_jobs_with_args(job_class, args, checked_args = nil)
      arguments = filter_args_to_check args, checked_args
      enqueued_jobs_by_class(job_class).select do |job|
        arguments == filter_args_to_check(job_arguments(job), checked_args)
      end
    end

    # Проверка, есть ли в очереди задание с указанными параметрами
    # Параметры должны идти в том же порядке, что и в самом задании
    # +checked_args+ - определяет нужные аргументы для проверки и их типы
    def enqueued_with_args?(args, checked_args = nil)
      enqueued_jobs_with_args(self, args, checked_args).present?
    end

    # Получить из массива аргументов только те, которые удовлетворяют условиям +checked_args+
    def filter_args_to_check(args, checked_args = nil)
      return args if checked_args.blank?

      args.select.with_index do |argument, index|
        next false if checked_args[index].blank? || !checked_args[index]
        raise WrongArgumentsOrderError unless argument.is_a?(checked_args[index])
        true
      end
    end

    # Десериализованные аргументы для задания
    def job_arguments(job)
      args = job_handler(job).job_data['arguments']
      ActiveJob::Arguments.deserialize(args)
    end

    def job_id(job)
      job_handler(job).job_data['job_id']
    end

    def job_handler(job)
      handler_class = 'ActiveJob::QueueAdapters::DelayedJobAdapter::JobWrapper'
      YAML.safe_load(job.handler, [handler_class, 'Symbol'])
    end
  end
end
