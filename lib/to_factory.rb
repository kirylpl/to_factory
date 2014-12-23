require "to_factory/version"
require "to_factory/generator"
require "to_factory/auto_generator"

module ToFactory
  class MissingActiveRecordInstanceException < Exception;end
  class MustBeActiveRecordSubClassException < Exception;end

  def self.included base
    base.class_eval do
      unless ancestors.include? ActiveRecord::Base
        raise MustBeActiveRecordSubClassException
      end
    end
  end

  def to_factory
    Generator.new(self).to_factory
  end

  class << self
    def generate!(options)
      model_dir   = options.fetch(:models)
      factory_dir = options.fetch(:factories)

      AutoGenerator.new(model_dir, factory_dir).all!
    end
  end
end

#think about making this optional for next release
ActiveRecord::Base.send(:include, ToFactory)
