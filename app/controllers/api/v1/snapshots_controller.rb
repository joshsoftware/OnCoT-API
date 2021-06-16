# frozen_string_literal: true

module Api
  module V1
    class SnapshotsController < ApiController
      before_action :find_drives_candidate

      def presigned_url
        candidate = @drives_candidate.candidate
        filename = "#{@drives_candidate.drive.name}/#{candidate.id}-#{candidate.first_name}-#{candidate.last_name}/#{DateTime.current}"
        presigned_url = request_presigned_url(filename)

        render_success(data: { url: presigned_url }, message: I18n.t('success.message'))
      end

      def create
        snapshot = Snapshot.new(image_url: params[:presigned_url].split('?').first, drives_candidate: @drives_candidate)

        if snapshot.save
          render_success(data: { snapshot: serialize_resource(snapshot, SnapshotSerializer) },
                         message: I18n.t('create.success', model_name: Snapshot))
        else
          render_error(message: snapshot.errors.messages, status: 400)
        end
      end

      def index
        snapshots = Snapshot.where(drives_candidate: @drives_candidate)

        render_success(data: { snapshots: serialize_resource(snapshots, SnapshotSerializer) },
                       message: I18n.t('index.success', model_name: Snapshot))
      end

      private

      def request_presigned_url(filename)
        signer = Aws::S3::Presigner.new
        signer.presigned_url(:put_object,
                             bucket: ENV['S3_BUCKET'],
                             key: filename,
                             acl: 'public-read',
                             content_type: 'image/jpeg')
      end

      def find_drives_candidate
        @drives_candidate = DrivesCandidate.find_by(drive_id: params[:drive_id], candidate_id: params[:candidate_id])
        render_error(message: I18n.t('not_found.message')) unless @drives_candidate
      end

      def snapshot_params
        params.permit(:filename, :drive_id, :candidate_id, :image_url, :presigned_url)
      end
    end
  end
end
