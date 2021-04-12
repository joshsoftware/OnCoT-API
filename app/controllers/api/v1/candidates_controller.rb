# frozen_string_literal: true

module Api
  module V1
    class CandidatesController < ApiController
      before_action :load_drive, only: %i[candidate_test_time_left invite]
      before_action :load_drive_candidate, only: :candidate_test_time_left
      before_action :set_start_time, only: :candidate_test_time_left
      before_action :check_emails_present, only: :invite

      def show
        candidate = Candidate.find(params[:id])
        return unless candidate

        render_success(data: { candidate: serialize_resource(candidate, CandidateSerializer) },
                       message: I18n.t('show.success', model_name: 'Candidate'))
      end

      def update
        candidate = Candidate.find(params[:id])
        if candidate.update(candidate_params)
          render_success(data: { candidate: serialize_resource(candidate, CandidateSerializer) },
                         message: I18n.t('update.success', model_name: 'Candidate'))
        else
          render_error(data: { candidate: serialize_resource(candidate, CandidateSerializer) },
                       message: I18n.t('update.failed', model_name: 'Candidate'))
        end
      end

      def candidate_test_time_left
        @drive_candidate.save if @drive_candidate && @drive_candidate.start_time.nil?

        time_left = @drive.end_time.in_time_zone(TZInfo::Timezone.get('Asia/Kolkata')) -
                    DateTime.now.in_time_zone(TZInfo::Timezone.get('Asia/Kolkata'))
        time_left -= 330.minutes
        message = if time_left.negative?
                    I18n.t('test.time_over')
                  else
                    I18n.t('test.time_remaining')
                  end
        render_success(data: { time_left: time_left }, message: message)
      end

      def invite
        candidate_emails = params[:emails].split(',')
        candidate_emails.each do |candidate_email|
          candidate = Candidate.find_or_initialize_by(email: candidate_email)

          drive_candidate = candidate.drives_candidates.build(drive_id: @drive.id)
          drive_candidate.generate_token
          next unless candidate.save

          CandidateMailer.invitation_email(candidate, drive_candidate).deliver_later
        end
        render_success(message: I18n.t('ok.message'))
      end

      private

      def candidate_params
        params.permit(:first_name, :last_name, :email, :is_profile_complete, :created_at, :mobile_number,
                      :updated_at, :created_by_id, :updated_by_id)
      end

      def load_drive
        @drive = Drive.find_by!(id: params[:drife_id])
      end

      def load_drive_candidate
        @drive_candidate = DrivesCandidate.find_by!(drive_id: params[:drife_id], candidate_id: params[:candidate_id])
      end

      def set_start_time
        @drive_candidate.start_time = DateTime.now.in_time_zone(TZInfo::Timezone.get('Asia/Kolkata'))
      end

      def check_emails_present
        return render_error(message: I18n.t('blank_input.message')) if params[:emails].blank?
      end
    end
  end
end
