class ContactMailer < ActionMailer::Base
  default :subject => "Contact from superpacapp.org"

  def superpacapp_contact(contact)
    @contact = contact
      mail(:to => "jennifer@glassymedia.com",
             :from => @contact.email,
             :template_path => 'contact_mailer',
             :template_name => 'contact_mailer')
  end

  def failed_ad(failed_ad)
  	@failed_ad = failed_ad
  	mail(:to => "support@glassymedia.com",
  			 :subject => "Faild ad feedback",
             :from => "failed-ad@glassymedia.com",
             :template_path => 'contact_mailer',
             :template_name => 'failed_ad_mailer')
  end

end
