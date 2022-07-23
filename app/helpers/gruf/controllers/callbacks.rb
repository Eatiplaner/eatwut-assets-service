module Gruf
  module Controllers
    module Callbacks
      extend ActiveSupport::Concern

      include ActiveSupport::Callbacks

      included do
        define_callbacks :process_action
      end

      def process_action(*)
        run_callbacks(:process_action) do
          super
        end
      end

      module ClassMethods
        def _normalize_callback_options(options)
          _normalize_callback_option(options, :only, :if)
          _normalize_callback_option(options, :except, :unless)
        end

        def _normalize_callback_option(options, from, to) # :nodoc:
          if from = options[from]
            _from = Array(from).map(&:to_s).to_set
            from = proc do |c|
              _from.include? c.request.method_key.to_s
            end
            options[to] = Array(options[to]).unshift(from)
          end
        end

        def _insert_callbacks(callbacks, block = nil)
          options = callbacks.extract_options!
          _normalize_callback_options(options)
          callbacks.push(block) if block
          callbacks.each do |callback|
            yield callback, options
          end
        end

        [:before, :after, :around].each do |callback|
          define_method "#{callback}_action" do |*names, &blk|
            _insert_callbacks(names, blk) do |name, options|
              set_callback(:process_action, callback, name, options)
            end
          end

          define_method "prepend_#{callback}_action" do |*names, &blk|
            _insert_callbacks(names, blk) do |name, options|
              set_callback(:process_action, callback, name, options.merge(prepend: true))
            end
          end

          define_method "skip_#{callback}_action" do |*names|
            _insert_callbacks(names) do |name, options|
              skip_callback(:process_action, callback, name, options)
            end
          end

          alias_method :"append_#{callback}_action", :"#{callback}_action"
        end
      end
    end
  end
end
