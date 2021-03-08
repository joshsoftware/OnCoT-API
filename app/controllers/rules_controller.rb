class RulesController < ApiController
  def show
    rules=Rule.find_by(drive_id: params[:id])
    if rules
      return render_success(data: rules, message: I18n.t("#{:ok}.message"))
    else
      return render_error(message:I18n.t("#{:not_found}.message"), status: :not_found)
    end
  end
end