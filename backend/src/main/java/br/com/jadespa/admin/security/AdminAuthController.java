package br.com.jadespa.admin.security;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;
import java.util.Map;
@RestController
@RequestMapping("/api/admin")
public class AdminAuthController {
 private final String email;
 private final String hash;
 private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
 public AdminAuthController(@Value("${jade.admin.email:}") String email, @Value("${jade.admin.password:}") String password) {
  this.email=email.trim(); this.hash=password.isBlank()?null:encoder.encode(password);
 }
 public boolean ownsEmail(String candidate) { return !email.isBlank() && candidate != null && email.equalsIgnoreCase(candidate.trim()); }

 public ResponseEntity<?> login(@RequestBody Map<String,String> body, HttpServletRequest request) {
  String password=body.getOrDefault("senha", "");
  boolean valid=password!=null && password.length()<=72 && hash!=null && encoder.matches(password,hash);
  if (!valid || !email.equalsIgnoreCase(body.get("email"))) return ResponseEntity.status(401).body(Map.of("mensagem","E-mail ou senha incorretos."));
  var old=request.getSession(false); if(old!=null) old.invalidate();
  var session=request.getSession(true); session.setAttribute("admin",Boolean.TRUE); session.setAttribute("perfil","ADMIN"); session.setMaxInactiveInterval(1800);
  return ResponseEntity.ok(Map.of("nome","Administrador","email",email,"perfil","ADMIN"));
 }
 @GetMapping("/sessao")
 public Map<String,String> session(){return Map.of("perfil","ADMIN","email",email);}
 @PostMapping("/logout")
 public Map<String,String> logout(HttpServletRequest request){var session=request.getSession(false);if(session!=null)session.invalidate();return Map.of("mensagem","Sessao encerrada.");}
}
