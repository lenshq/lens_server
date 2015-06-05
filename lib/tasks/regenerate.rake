namespace :regenerate do
  desc "Generate fake data for all apps"
  task :fake_data => :environment do
    Application.all.each do |app|
      5000.downto(0) do |i|
        data = {
          action: ["index", "show"].pick, controller: ["users", "posts"].pick,
          params: {id: "123", msg: "test evt"},
          url: "/view/#{rand(123_123_123)}",
          time: (Time.now - i.minutes).to_s,
          duration: [50, 100, 300, 550, 800, 900, 1400, 1900, 3000].pick,
          records: [{
           "sql" => "SELECT  \"channels\".* FROM \"channels\"  WHERE \"channels\".\"user_id\" = 51 AND \"channels\".\"being_deleted\" = 'f' AND \"channels\".\"default_channel\" = 't' ORDER BY created_at ASC LIMIT 1",
           "name" => "Channel Load",
           "connection_id" => 70334014529560,
           "binds" => nil,
           "connection_name" => nil
        }],
          method: ["GET", "POST"].pick,
          meta: {client_version: 123}
        }

        app.rec_data(data)
      end

      puts "Added 5000 events to app #{app.id}"
    end
  end
end

