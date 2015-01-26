module Restikle

  # Simple wrapper for REST commands using the ResourceManager
  class Rest

    MANAGER_COMMANDS = {
      get:      'getObject',
      post:     'postObject',
      put:      'putObject',
      delete:   'deleteObject',
      head:     'headObject',
      patch:    'patchObject'
    }

    def self.get(args={})
      cmd(:get, args)
    end
    def self.post(args={})
      cmd(:post, args)
    end
    def self.put(args={})
      cmd(:put, args)
    end
    def self.delete(args={})
      cmd(:delete, args)
    end
    def self.head(args={})
      cmd(:head, args)
    end
    def self.patch(args={})
      cmd(:patch, args)
    end

    def self.cmd(cmd, args={})
      object  = args[:object]
      path    = args[:path]
      params  = args[:params]
      success = args[:success] || ->(op,res) { handle_success(op, res) }
      failure = args[:failure] || ->(op,err) { handle_failure(op, err) }
      Dispatch::Queue.concurrent(:default).async do
        Restikle::ResourceManager.manager.send(
          MANAGER_COMMANDS[cmd],
          object,
          path:    path,
          params:  params,
          success: success,
          failure: failure
        )
      end
    end

    def self.handle_success(op, res)
    end

    def self.handle_failure(op, err)
    end
  end
end
