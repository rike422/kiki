require 'pathname'
module Rounders
  module Plugins
    module Pluggable
      class << self
        def included(klass)
          klass.extend ClassMethods
          PluginLoader.register(klass)
        end
      end

      module ClassMethods
        def feature_name
          @feature_name ||= begin
            name_spaces = name.to_s.split('::')
            class_name = name_spaces.last
            Rounders::Util.infrect(class_name).underscore
          end
        end

        def directory_name
          @directory_name ||= Util.infrect(feature_name).pluralize
        end

        def load_path
          @load_path ||= File.join(Rounders::APP_PATH, directory_name)
        end

        def load_plugins
          Pathname.glob("#{load_path}/*.rb").each do |plugin|
            begin
              puts "load #{plugin.expand_path}"
              require_relative plugin.expand_path
            rescue => e
              puts e
            end
          end
        end
      end
    end
  end
end
