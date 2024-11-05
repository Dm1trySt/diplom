require 'delayed_job'
require 'delayed_job_active_record'
#
# Delayed::Worker.destroy_failed_jobs = false
# Delayed::Worker.raise_signal_exceptions = :term
class DelayedErrorHandler < Delayed::Plugin
  callbacks do |lifecycle|
    lifecycle.around(:invoke_job) do |job, *args, &block|
      begin
        block.call(job, *args)
      rescue Exception => exception
        ExceptionNotifier.notify_exception exception, data: { job: job.attributes.except(:last_error) }
        raise exception
      end
    end
  end
end

Delayed::Worker.plugins << DelayedErrorHandler
Delayed::Worker.queue_attributes = {
  oto_features: { priority: 1 }
}
Delayed::Backend::ActiveRecord.configure do |config|
  config.reserve_sql_strategy = :default_sql # default is still :optimized_sql
end
