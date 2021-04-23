# frozen_string_literal: true

module Api
  module V1
    class SnapshotsController < ApiController
      before_action :find_data, except: :show

      def create
        snapshot = Snapshot.new(snapshot_params)

        if snapshot.save
          render_success(data: { snapshot: serialize_resource(snapshot, SnapshotSerializer) },
                         message: I18n.t('create.success', model_name: Snapshot))
        else
          render_error(message: snapshot.errors.messages, status: 400)
        end
      end

      def index
        snapshots = Snapshot.where(drive_id: @drive.id, candidate_id: @candidate.id)

        render_success(data: { snapshots: serialize_resource(snapshots, SnapshotSerializer) },
                       message: I18n.t('index.success', model_name: Snapshot))
      end

      def show
        snapshot = Snapshot.find(params[:id])

        render_success(data: { snapshot: serialize_resource(snapshot, SnapshotSerializer) },
                       message: I18n.t('show.success', model_name: Snapshot))
      end

      private

      def find_data
        @drive = Drive.find(params[:drive_id])
        @candidate = Candidate.find(params[:candidate_id])
      end

      def snapshot_params
        params.permit(:url, :drive_id, :candidate_id)
      end
    end
  end
end
