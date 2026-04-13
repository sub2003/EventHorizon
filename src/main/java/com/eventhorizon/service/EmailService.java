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

    private static final String FROM_EMAIL = System.getenv("FROM_EMAIL");
    private static final String APP_PASSWORD = System.getenv("APP_PASSWORD");

    public boolean sendVerificationEmail(String toEmail, String token, String baseUrl) {
        String verifyLink = baseUrl + "/user?action=verify&token=" + token;

        if (FROM_EMAIL == null || APP_PASSWORD == null
                || FROM_EMAIL.trim().isEmpty() || APP_PASSWORD.trim().isEmpty()) {
            System.out.println("EMAIL ERROR: FROM_EMAIL or APP_PASSWORD is missing.");
            return false;
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        // IMPORTANT: prevent request from hanging too long
        props.put("mail.smtp.connectiontimeout", "10000"); // 10 seconds
        props.put("mail.smtp.timeout", "10000");           // 10 seconds
        props.put("mail.smtp.writetimeout", "10000");      // 10 seconds

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

            System.out.println("EMAIL DEBUG START");
            System.out.println("TO_EMAIL = " + toEmail);
            System.out.println("VERIFY_LINK = " + verifyLink);

            Transport.send(message);

            System.out.println("EMAIL SENT SUCCESSFULLY to: " + toEmail);
            return true;

        } catch (MessagingException e) {
            System.out.println("EMAIL SEND FAILED");
            e.printStackTrace();
            return false;
        }
    }
}