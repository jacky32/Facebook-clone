class UserMailer < ApplicationMailer
  default from: 'jacky323132@seznam.cz'

  def welcome_email(user)
    @user = user
    @url  = 'https://fbclone-5ndy.onrender.com'
    mail(to: @user.email, subject: 'Welcome to fbclone!')
  end
end
