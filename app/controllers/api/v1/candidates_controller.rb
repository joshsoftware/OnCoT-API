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
          update_drives_candidate

          render_success(data: { candidate: serialize_resource(candidate, CandidateSerializer) },
                         message: I18n.t('update.success', model_name: 'Candidate'))
        else
          render_error(data: { candidate: serialize_resource(candidate, CandidateSerializer) },
                       message: I18n.t('update.failed', model_name: 'Candidate'))
        end
      end

      def candidate_test_time_left
        @drive_candidate.save if @drive_candidate && @drive_candidate.start_time.nil?

        time_left = @drive_candidate.end_time.localtime - DateTime.now.localtime

        message = if time_left.negative?
                    I18n.t('test.time_over')
                  else
                    I18n.t('test.time_remaining')
                  end
        render_success(data: { time_left: time_left }, message: message)
      end

      def invite # rubocop:disable Metrics/AbcSize
        candidate_emails = params[:emails].split(',')
        candidate_emails.each do |candidate_email|
          candidate = Candidate.find_or_initialize_by(email: candidate_email)
          candidate.save
          drive_candidate = DrivesCandidate.new(candidate_id: candidate.id, drive_id: @drive.id, drive_start_time: @drive.start_time || DateTime.current,
                                                drive_end_time: @drive.end_time || DateTime.current + 1.year)
          drive_candidate.generate_token
          next unless candidate

          save_drive_candidate(candidate, drive_candidate)
        end
        render_success(message: I18n.t('ok.message'))
      end

      def save_drive_candidate(candidate, drive_candidate)
        if drive_candidate.save
          CandidateMailer.invitation_email(candidate, drive_candidate).deliver_later
        else
          render_error(message: drive_candidate.errors.full_messages)
        end
      end

      private

      def candidate_params
        params.permit(:first_name, :last_name, :email, :is_profile_complete, :mobile_number,
                      :created_by_id, :updated_by_id)
      end

      def load_drive
        @drive = Drive.find_by!(id: params[:drife_id])
      end

      def load_drive_candidate
        @drive_candidate = DrivesCandidate.find_by(token: params[:token])
      end

      def set_start_time
        @drive_candidate.start_time = DateTime.now.localtime
      end

      def check_emails_present
        return render_error(message: I18n.t('blank_input.message')) if params[:emails].blank?
      end

      def update_drives_candidate
        drives_candidate = DrivesCandidate.find_by(token: params[:token])
        drive_problems = DrivesProblem.where(drive_id: drives_candidate.drive.id)

        return unless drives_candidate.start_time.nil?

        start_time = DateTime.now.localtime
        end_time = start_time + total_time(drive_problems).minutes
        drives_candidate.update(start_time: start_time, end_time: end_time)
        if drive_candidate.drive.is_assessment?
          AssessmentWebhookWorker.perform_at(end_time, drives_candidate.id.to_s)
          # AssessmentWebhookWorker.perform_now(drives_candidate.id.to_s) # For testing purpose
        end
      end

      def total_time(drive_problems)
        Problem.where(id: drive_problems.collect(&:problem_id)).collect(&:time_in_minutes).sum
      end
    end
  end
end
