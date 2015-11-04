require 'rails_helper'

RSpec.describe Normalizer do
  describe '#klass' do
    subject { described_class.new(record).klass }

    {
      'halted_callback.action_controller' => Normalizers::ActionController::HaltedCallback,
      'process_action.action_controller' => Normalizers::ActionController::ProcessAction,
      'read_fragment.action_controller' => Normalizers::ActionController::ReadFragment,
      'redirect_to.action_controller' => Normalizers::ActionController::RedirectTo,
      'send_data.action_controller' => Normalizers::ActionController::SendData,
      'start_processing.action_controller' => Normalizers::ActionController::StartProcessing,
      'write_fragment.action_controller' => Normalizers::ActionController::WriteFragment,
      'deliver.action_mailer' => Normalizers::ActionMailer::Deliver,
      'render_collection.action_view' => Normalizers::ActionView::RenderCollection,
      'render_partial.action_view' => Normalizers::ActionView::RenderPartial,
      'render_template.action_view' => Normalizers::ActionView::RenderTemplate,
      'sql.active_record' => Normalizers::ActiveRecord::Sql,
      'request.net_http' => Normalizers::NetHttp::Request,
      'unknown_type111!!' => Normalizers::Base
    }.each_pair do |event_type, klass|
      describe "returns correct class for #{event_type}" do
        let(:record) { { etype: event_type } }

        it { is_expected.to eq klass }
      end
    end
  end
end
