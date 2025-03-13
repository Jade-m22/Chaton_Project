class OrderMailer < ApplicationMailer
  default from: 'no-reply@catseyes.com'

  def confirmation_email(order)
    @order = order
    mail(to: @order.user.email, subject: 'Votre commande est confirmée')
  end

  def admin_notification(order)
    @order = order
    mail(to: 'admin@catseyes.com', subject: 'Nouvelle commande passée')
  end
end
