import smtplib,sys
    
from os.path import basename
from email.mime.application import MIMEApplication
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.utils import COMMASPACE, formatdate
    
def send_mail(receiver, receiver_email, text, file=None):
    
    msg = MIMEMultipart()
    msg['From'] = 'admin@homewebpage.com'
    msg['To'] = COMMASPACE.join([receiver_email])
    msg['Date'] = formatdate(localtime=True)
    msg['Subject'] = 'Home Page - Contact Form'
    
    msg.attach(MIMEText(text))
    
    if file !=None:
        with open(file, "rb") as fil:
            part = MIMEApplication(
                fil.read(),
                Name=basename(file)
            )
            part['Content-Disposition'] = 'attachment; filename="%s"' % basename(file)
            msg.attach(part)
    
    smtp = smtplib.SMTP('smtp.bgu.ac.il')
    send_from = 'admin@homewebpage.com'
    smtp.sendmail(send_from, [receiver_email], msg.as_string())
    smtp.close()

send_mail(sys.argv[1], sys.argv[2], sys.argv[3])     
