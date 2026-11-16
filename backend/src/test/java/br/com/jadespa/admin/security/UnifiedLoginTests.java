package br.com.jadespa.admin.security;
import br.com.jadespa.admin.controller.ClienteController;
import br.com.jadespa.admin.dto.LoginRequest;
import br.com.jadespa.admin.model.Cliente;
import br.com.jadespa.admin.repository.ClienteRepository;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.*;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.test.util.ReflectionTestUtils;
import java.lang.reflect.Proxy;
import java.util.*;
import static org.junit.jupiter.api.Assertions.*;
class UnifiedLoginTests {
 private final AdminAuthController admin=new AdminAuthController("admin@example.test","AdminPassword123!");
 private final Cliente client=new Cliente();
 private ClienteController controller(){
  client.setNome("Cliente");client.setEmail("client@example.test");client.setSenhaHash(new BCryptPasswordEncoder().encode("ClientPassword123!"));ReflectionTestUtils.setField(client,"id",1L);
  var repo=(ClienteRepository)Proxy.newProxyInstance(getClass().getClassLoader(),new Class[]{ClienteRepository.class},(proxy,method,args)->{
   if(method.getName().equals("findByEmail")) return "client@example.test".equals(args[0])?Optional.of(client):Optional.empty();
   throw new AssertionError("Unexpected repository call: "+method.getName());
  });return new ClienteController(repo,admin);
 }
 private LoginRequest credentials(String email,String password){var body=new LoginRequest();body.setEmail(email);body.setSenha(password);return body;}
 @Test void sameLoginRecognizesAdmin(){
  var c=controller();var request=new MockHttpServletRequest();
  var response=c.login(credentials(" ADMIN@example.test ","AdminPassword123!"),request);
  assertEquals(200,response.getStatusCode().value());assertEquals("ADMIN",((Map<?,?>)response.getBody()).get("perfil"));assertEquals(true,request.getSession().getAttribute("admin"));
 }
 @Test void clientLoginRemovesPreviousAdminPrivileges(){
  var c=controller();var request=new MockHttpServletRequest();request.getSession().setAttribute("admin",true);String old=request.getSession().getId();
  var response=c.login(credentials("client@example.test","ClientPassword123!"),request);
  assertEquals(200,response.getStatusCode().value());assertEquals("CLIENTE",((Map<?,?>)response.getBody()).get("perfil"));assertNull(request.getSession().getAttribute("admin"));assertNotEquals(old,request.getSession().getId());assertEquals(1L,request.getSession().getAttribute("clienteId"));
 }
 @Test void wrongOrUnknownCredentialsDoNotCreateSession(){
  var c=controller();for(var email:List.of("admin@example.test","client@example.test","missing@example.test")){
   var request=new MockHttpServletRequest();assertEquals(401,c.login(credentials(email,"wrong"),request).getStatusCode().value());assertNull(request.getSession(false));
  }
 }
}
