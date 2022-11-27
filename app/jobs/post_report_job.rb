class PostReportJob < ApplicationJob
  queue_as :default # This is the queue in which the job will be executed

  # This is the main class in which the job is executed
  def perform(user_id, post_id)
    user = User.find(user_id)
    post = Post.find(post_id)
    report = PostReport.generate(post)

    # Do something later
    # user -> request post report -> send report by email using application mailer
    PostReportMailer.post_report(user, post, report).deliver_now
  end
end
