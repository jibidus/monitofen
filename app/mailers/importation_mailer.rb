class ImportationMailer < ApplicationMailer
  default from: 'monitofen@gmail.com'

  def send_importation_report(importation)
    raise "Cannot sent email report for running importation" if importation.running?

    @importation = importation
    mail to: 'jibidus@gmail.com',
         subject: "Importation of file #{importation.file_name}"
  end
end
