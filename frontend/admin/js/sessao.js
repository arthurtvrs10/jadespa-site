const originalFetch = window.fetch.bind(window);
window.fetch = async (...args) => {
 const response = await originalFetch(...args);
 if (response.status === 401) location.replace('/login.cadastro.html');
 return response;
};
document.addEventListener('DOMContentLoaded', () => {
 document.getElementById('sairAdmin').addEventListener('click', async () => {
  const response = await fetch('/api/admin/logout', {method:'POST'});
  if(response.ok){localStorage.removeItem('jadeSpaPerfil');location.replace('/login.cadastro.html');}
 });
});
