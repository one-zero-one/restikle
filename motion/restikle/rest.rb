module Restikle

  # Simple wrapper for REST commands using the ResourceManager
  class Rest

    HTTP_METHODS = [:get, :post, :put, :delete, :head, :patch]
    MANAGER_COMMANDS = {
      get:      'getObject:path:parameters:success:failure:',
      post:     'postObject:path:parameters:success:failure:',
      put:      'putObject:path:parameters:success:failure:',
      delete:   'deleteObject:path:parameters:success:failure:',
      head:     'headObject:path:parameters:success:failure:',
      patch:    'patchObject:path:parameters:success:failure:'
    }

    def self.normalise_args(args)
      args           ||= {}
      args[:path]    ||= ''
      args[:params]  ||= nil
      args[:success] ||= ->(op,res) { Rest.default_handle_success(op, res) }
      args[:failure] ||= ->(op,err) { Rest.default_handle_failure(op, err) }
      args
    end

    # TODO: The following 13 lines (25..38) should be able to replace the
    # lines from 41..124, but for some reason, there's a weird iOS method
    # invocation problem. Issue raised on RubyMotion groups here:
    # https://groups.google.com/forum/?fromgroups=#!topic/rubymotion/yZYwAnzIDDE

    # class << self
    #   HTTP_METHODS.each do |http_method|
    #     define_method "#{http_method.to_s}", -> (obj, args) do
    #       Dispatch::Queue.concurrent(:default).async {
    #         args = normalise_args(args)
    #         Restikle::ResourceManager.manager.send(
    #           MANAGER_COMMANDS[http_method],
    #           [ obj, args[:path], args[:params], args[:success], args[:failure] ]
    #         )
    #       }
    #     end
    #   end
    # end

    def self.get(obj, args={})
      Dispatch::Queue.concurrent(:default).async {
        args = normalise_args(args)
        Restikle::ResourceManager.manager.getObject(
          obj,
          path:       args[:path],
          parameters: args[:params],
          success:    args[:success],
          failure:    args[:failure]
        )
      }
    end
    def self.post(obj, args={})
      Dispatch::Queue.concurrent(:default).async {
        args = normalise_args(args)
        Restikle::ResourceManager.manager.postObject(
          obj,
          path:       args[:path],
          parameters: args[:params],
          success:    args[:success],
          failure:    args[:failure]
        )
      }
    end
    def self.post(obj, args={})
      Dispatch::Queue.concurrent(:default).async {
        args = normalise_args(args)
        Restikle::ResourceManager.manager.putObject(
          obj,
          path:       args[:path],
          parameters: args[:params],
          success:    args[:success],
          failure:    args[:failure]
          )
      }
    end
    def self.delete(obj, args={})
      Dispatch::Queue.concurrent(:default).async {
        args = normalise_args(args)
        Restikle::ResourceManager.manager.deleteObject(
          obj,
          path:       args[:path],
          parameters: args[:params],
          success:    args[:success],
          failure:    args[:failure]
          )
      }
    end
    def self.delete(obj, args={})
      Dispatch::Queue.concurrent(:default).async {
        args = normalise_args(args)
        Restikle::ResourceManager.manager.deleteObject(
          obj,
          path:       args[:path],
          parameters: args[:params],
          success:    args[:success],
          failure:    args[:failure]
        )
      }
    end
    def self.head(obj, args={})
      Dispatch::Queue.concurrent(:default).async {
        args = normalise_args(args)
        Restikle::ResourceManager.manager.headObject(
          obj,
          path:       args[:path],
          parameters: args[:params],
          success:    args[:success],
          failure:    args[:failure]
        )
      }
    end
    def self.patch(obj, args={})
      Dispatch::Queue.concurrent(:default).async {
        args = normalise_args(args)
        Restikle::ResourceManager.manager.patchObject(
          obj,
          path:       args[:path],
          parameters: args[:params],
          success:    args[:success],
          failure:    args[:failure]
        )
      }
    end

    def self.default_handle_success(op, res)
      NSLog " op: #{op}"
      NSLog "res: #{res}"
    end

    def self.default_handle_failure(op, err)
      NSLog " op: #{op}"
      NSLog "err: #{err}"
    end

    private

    def self._rkom_hack
      if @rkom_hack
        Restikle::ResourceManager.manager.getObject   (nil, path: nil, parameters: nil, success: nil, failure: nil)
        Restikle::ResourceManager.manager.postObject  (nil, path: nil, parameters: nil, success: nil, failure: nil)
        Restikle::ResourceManager.manager.putObject   (nil, path: nil, parameters: nil, success: nil, failure: nil)
        Restikle::ResourceManager.manager.deleteObject(nil, path: nil, parameters: nil, success: nil, failure: nil)
        Restikle::ResourceManager.manager.headObject  (nil, path: nil, parameters: nil, success: nil, failure: nil)
        Restikle::ResourceManager.manager.patchObject (nil, path: nil, parameters: nil, success: nil, failure: nil)
      end
    end
  end
end
