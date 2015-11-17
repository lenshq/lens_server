module Api
  module V1
    module Applications
      module Sources
        class ScenariosController < Api::V1::Applications::Sources::ApplicationController
          def show
            scenario = event_source.scenarios.find(params[:id])

            rows = Event.find_by(application: application, scenario: scenario)

            response.headers["Access-Control-Allow-Origin"] = "*"

            # {
            #   "version"=>"v1",
            #   "timestamp"=>"2015-11-05T01:01:26.000Z",
            #   "event"=> {
            #     "duration"=>286.44073486328125,
            #     "avg_duration"=>95.48024495442708,
            #     "event_type"=>"db.sql.query",
            #     "finished_at"=>4341543936.0,
            #     "count"=>3,
            #     "started_at"=>4341543936.0,
            #     "position"=>"9",
            #     "content"=>
            #     "SELECT \"users\".* FROM \"users\" WHERE \"users\".\"id\" IN (?)"
            #   }
            # }
            events = rows.map do |row|
              row if row['event']['duration'].round > 0
            end.compact.sort_by { |k| k['event']['started_at'].to_f }.each_with_index.map do |row, index|
              event = row['event']
              {
                started_at: event['started_at'].to_f,
                finished_at: event['finished_at'].to_f,
                duration: event['avg_duration'].to_f,
                event_type: event['event_type'],
                position: index,
                content: event['content']
              }
            end

            render json: { events: events }
          end
        end
      end
    end
  end
end
