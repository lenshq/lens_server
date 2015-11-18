module Api
  module V1
    module Applications
      module Sources
        class ScenariosController < Api::V1::Applications::Sources::ApplicationController
          def show
            response.headers["Access-Control-Allow-Origin"] = "*"

            scenario = event_source.scenarios.find(params[:id])

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
            rows = Event.find_by(application: application, scenario: scenario)

            # {
            #   "timestamp"=>"2015-11-12T00:33:47.000Z",
            #   "result" => {
            #     "duration" => {
            #       "probabilities" => [0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95],
            #       "quantiles" => [378.1423, 522.46515, 806.62585, 1789.3164, 2517.398, 2610.9329, 2723.3374, 2747.0056, 2841.2153, 2850.4753, 2880.0735, 2907.4556, 2949.139, 2953.9404, 3016.6045, 3484.596, 4185.0273, 13694.969, 14739.44],
            #       "min" => 0.036985,
            #       "max" => 16683.39
            #     },
            #     "raw_duration" => {
            #       "breaks" => [-2780.52197265625, 0.036865234375, 2780.595703125, 5561.154296875, 8341.712890625, 11122.271484375, 13902.830078125, 16683.390625],
            #       "counts" => [0.0, 17.0, 20.0, 0.0, 0.0, 1.0, 5.0]
            #     }
            #   }
            # }
            raw_quantiles = Request.find_quantiles_by(application: application, scenario: scenario).first

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

            render json: { events: events, quantiles: raw_quantiles['result']['duration'] }
          end
        end
      end
    end
  end
end
