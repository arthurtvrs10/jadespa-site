package br.com.jadespa.admin.security;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import java.io.IOException;
@Component
public class AdminAccessFilter extends OncePerRequestFilter {
 @Override
 protected void doFilterInternal(HttpServletRequest request,HttpServletResponse response,FilterChain chain) throws ServletException,IOException {
  String path=request.getServletPath(), method=request.getMethod();
  boolean protectedPath=path.equals("/admin") || path.startsWith("/admin/")
   || path.startsWith("/api/admin/")
   || path.startsWith("/api/solicitacoes-planos/admin/")
   || (path.equals("/api/clientes") && !method.equals("POST"))
   || (path.equals("/api/agendamentos") && !method.equals("POST"))
   || (path.matches("/api/agendamentos/[0-9]+/status") && method.equals("PATCH"))
   || ((path.startsWith("/api/servicos") || path.startsWith("/api/aulas") || path.startsWith("/api/planos")) && !method.equals("GET"));
  if((protectedPath || path.equals("/api/clientes/login")) && !method.equals("GET") && !method.equals("HEAD")) {
   String origin=request.getHeader("Origin"),expected=request.getScheme()+"://"+request.getHeader("Host");
   if((origin!=null && !origin.equals(expected)) || "cross-site".equals(request.getHeader("Sec-Fetch-Site"))){deny(response,403);return;}
  }
  if(protectedPath){
   var session=request.getSession(false);
   if(session==null || !Boolean.TRUE.equals(session.getAttribute("admin"))){
    if(path.startsWith("/admin"))response.sendRedirect("/login.cadastro.html");else deny(response,401);
    return;
   }
   response.setHeader("Cache-Control","no-store");
  }
  chain.doFilter(request,response);
 }
 private void deny(HttpServletResponse response,int status)throws IOException{
  response.setStatus(status);response.setContentType("application/json;charset=UTF-8");
  response.getWriter().write("{\"mensagem\":\"Acesso administrativo necessario.\"}");
 }
}
