package com.eventhorizon.service;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.MessagingException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailService {

    // Replace with your Gmail address
    private static final String FROM_EMAIL = "abcsraththanayaka21@gmail.com";

    // Replace with your 16-character Gmail App Password
    private static final String APP_PASSWORD = "snkybxkueazdagzc";

    public boolean sendVerificationEmail(String toEmail, String token, String baseUrl) {
        String verifyLink = baseUrl + "/user?action=verify&token=" + token;

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Verify Your EventHorizon Account");

            String html = "<h2>Welcome to EventHorizon</h2>"
                    + "<p>Thank you for registering.</p>"
                    + "<p>Please verify your email by clicking the link below:</p>"
                    + "<p><a href=\"" + verifyLink + "\">Verify My Account</a></p>"
                    + "<p>If you did not create this account, please ignore this email.</p>";

            message.setContent(html, "text/html; charset=UTF-8");

            Transport.send(message);
            return true;

        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
}