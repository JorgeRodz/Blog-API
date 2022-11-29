# frozen_string_literal: true

# Main class for sending post reports
class PostReportMailer < ApplicationMailer
  def post_report(user, post, _post_report)
    @post = post # Instance variable => available in view
    mail to: user.email, subject: "Post #{post.id} report" # The data you need to pass to the mailer
  end
end
