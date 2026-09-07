package com.chams.tpe_backend.service;

import com.chams.tpe_backend.model.Role;
import com.chams.tpe_backend.model.Utilisateur;
import com.chams.tpe_backend.repository.UtilisateurRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    private UtilisateurRepository utilisateurRepository;

    @Async
    public void envoyerNotificationsInscription(Utilisateur nouvelUtilisateur) {
        envoyerEmailBienvenue(nouvelUtilisateur);
        envoyerNotificationAdmins(nouvelUtilisateur);
    }

    private void envoyerEmailBienvenue(Utilisateur utilisateur) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(utilisateur.getEmail());
        message.setSubject("Bienvenue sur Gestion TPE");
        message.setText(
                "Bonjour " + utilisateur.getPrenom() + ",\n\n" +
                        "Votre compte a été créé avec succès sur l'application Gestion TPE.\n" +
                        "Email : " + utilisateur.getEmail() + "\n" +
                        "Rôle : " + utilisateur.getRole() + "\n\n" +
                        "Vous pouvez dès à présent vous connecter.\n\n" +
                        "Cordialement,\nL'équipe Gestion TPE"
        );
        mailSender.send(message);
    }

    private void envoyerNotificationAdmins(Utilisateur nouvelUtilisateur) {
        List<Utilisateur> admins = utilisateurRepository.findAll().stream()
                .filter(u -> u.getRole() == Role.ADMIN)
                .filter(u -> !u.getEmail().equals(nouvelUtilisateur.getEmail()))
                .toList();

        for (Utilisateur admin : admins) {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo(admin.getEmail());
            message.setSubject("Nouveau compte créé sur Gestion TPE");
            message.setText(
                    "Bonjour " + admin.getPrenom() + ",\n\n" +
                            "Un nouvel utilisateur vient de créer un compte :\n" +
                            "Nom : " + nouvelUtilisateur.getPrenom() + " " + nouvelUtilisateur.getNom() + "\n" +
                            "Email : " + nouvelUtilisateur.getEmail() + "\n" +
                            "Rôle : " + nouvelUtilisateur.getRole() + "\n\n" +
                            "Cordialement,\nL'équipe Gestion TPE"
            );
            mailSender.send(message);
        }
    }
}