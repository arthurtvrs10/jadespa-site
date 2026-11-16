package br.com.jadespa.admin.security;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.*;
import java.util.Map;
import static org.junit.jupiter.api.Assertions.*;
class AdminAccessTests {
 private MockHttpServletRequest request(String method,String path){var r=new MockHttpServletRequest(method,path);r.setServletPath(path);return r;}
 @Test void redirectsAnonymousPanel() throws Exception {
  var response=new MockHttpServletResponse();new AdminAccessFilter().doFilter(request("GET","/admin/administracao.html"),response,new MockFilterChain());
  assertEquals(302,response.getStatus());assertEquals("/login.cadastro.html",response.getRedirectedUrl());
 }
 @Test void deniesAnonymousAndClientOnAllAdminApis() throws Exception {
  String[][] routes={{"GET","/api/clientes"},{"GET","/api/agendamentos"},{"PATCH","/api/agendamentos/1/status"},{"GET","/api/solicitacoes-planos/admin/pendentes"},{"PUT","/api/solicitacoes-planos/admin/1/aprovar"},{"GET","/api/admin/sessao"}};
  for(var route:routes){var r=request(route[0],route[1]);r.getSession().setAttribute("clienteId",1L);var response=new MockHttpServletResponse();new AdminAccessFilter().doFilter(r,response,new MockFilterChain());assertEquals(401,response.getStatus(),route[1]);}
 }
 @Test void publicCatalogAndRegistrationRemainAccessible() throws Exception {
  for(var path:new String[]{"/api/servicos","/api/aulas","/api/planos","/login.cadastro.html"}){
   var chain=new MockFilterChain();new AdminAccessFilter().doFilter(request("GET",path),new MockHttpServletResponse(),chain);assertNotNull(chain.getRequest());
  }
  var chain=new MockFilterChain();new AdminAccessFilter().doFilter(request("POST","/api/clientes"),new MockHttpServletResponse(),chain);assertNotNull(chain.getRequest());
 }
 @Test void validLoginRotatesSessionAndLogoutRevokesAccess() throws Exception {
  var auth=new AdminAuthController("admin@example.test","TestPassword123!");var r=request("POST","/api/admin/login");String old=r.getSession().getId();
  assertEquals(401,auth.login(Map.of("email","admin@example.test","senha","wrong"),r).getStatusCode().value());
  assertEquals(200,auth.login(Map.of("email","admin@example.test","senha","TestPassword123!"),r).getStatusCode().value());assertNotEquals(old,r.getSession().getId());
  var panel=request("GET","/admin/administracao.html");panel.setSession((MockHttpSession)r.getSession());var chain=new MockFilterChain();new AdminAccessFilter().doFilter(panel,new MockHttpServletResponse(),chain);assertNotNull(chain.getRequest());
  auth.logout(r);assertNull(r.getSession(false));
 }
 @Test void rejectsCrossOriginMutation() throws Exception {
  var r=request("POST","/api/clientes/login");r.addHeader("Host","localhost:8080");r.addHeader("Origin","https://other.example");var response=new MockHttpServletResponse();new AdminAccessFilter().doFilter(r,response,new MockFilterChain());assertEquals(403,response.getStatus());
 }
 @Test void missingCredentialsNeverAuthenticate(){var auth=new AdminAuthController("","");assertEquals(401,auth.login(Map.of("email","","senha",""),request("POST","/api/admin/login")).getStatusCode().value());}
}
