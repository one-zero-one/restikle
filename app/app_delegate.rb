class AppDelegate
  include CDQ

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    RKlcl_configure_by_name("Restkit", RKlcl_vDebug)
    RKlcl_configure_by_name("App", RKlcl_vDebug)
    RKlcl_configure_by_name("RestKit/Network*", RKlcl_vTrace)
    RKlcl_configure_by_name("RestKit/ObjectMapping", RKlcl_vTrace)

    return true if RUBYMOTION_ENV == 'test'

    cdq.setup
    true
  end
end
