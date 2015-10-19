namespace :scenarios do
  desc 'Add scenario to requests without it'
  task fill_scenario_in_requests: :environment do
    requests_to_fill = Page.where(scenario: nil)
    requests_to_fill.each do |r|
      hash = Scenario.hash_from_string(r.events.each.inject("") { |h, r| h << r.event_type })
      scenario = r.event_source.scenarios.find_or_create_by(events_hash: hash)
      r.update(scenario: scenario)
    end
  end
end
