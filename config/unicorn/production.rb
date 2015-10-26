name = 'lens-unicorn'
pids_root = "/srv/www/lens/shared/pids/"
logs_root = "/srv/www/lens/shared/log/"

# GC.respond_to?(:copy_on_write_friendly=) and
# GC.copy_on_write_friendly = true

listen 9000

worker_processes 10
timeout 30

pid "#{pids_root}#{name}.pid"
stderr_path "#{logs_root}unicorn.err.log"
stdout_path "#{logs_root}unicorn.log"

preload_app true


before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = "/srv/www/lens/current/Gemfile"
end

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

  old_pid = "#{pids_root}/#{name}.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
  #GC.disable
end
