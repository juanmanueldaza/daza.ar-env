// Dev Dashboard logic for daza.ar
// Edit the SITES array below to match your local setup

const SITES = [
  { name: 'cv',        port: 3001, folder: 'sites/cv',        url: 'http://cv.localhost:3001' },
  { name: 'onepager',  port: 3002, folder: 'sites/onepager',  url: 'http://onepager.localhost:3002' },
  { name: 'start',     port: 3003, folder: 'sites/start',     url: 'http://start.localhost:3003' },
  { name: 'navbar',    port: 3004, folder: 'sites/navbar',    url: 'http://navbar.localhost:3004' },
  { name: 'mdsite',    port: 3005, folder: 'sites/mdsite',    url: 'http://mdsite.localhost:3005' },
  { name: 'data',      port: 3006, folder: 'sites/data',      url: 'http://data.localhost:3006/README.md' },
  { name: 'wallpapers',port: 3007, folder: 'sites/wallpapers',url: 'http://wallpapers.localhost:3007' },
];

function checkStatus(site) {
  // Try to fetch the site root, consider up if fetch succeeds
  return fetch(site.url, { mode: 'no-cors' })
    .then(() => 'up')
    .catch(() => 'down');
}

function renderSiteRow(site, status, statusClass) {
  return `<tr>
    <td>${site.name}</td>
    <td><a href="${site.url}" target="_blank">${site.url}</a></td>
    <td class="status ${statusClass}">${status}</td>
    <td>${site.port}</td>
    <td class="quick-actions">
      <button class="btn" onclick="window.open('${site.url}', '_blank')">Open</button>
      <button class="btn" onclick="openFolder('${site.folder}')">Folder</button>
    </td>
  </tr>`;
}

async function renderDashboard() {
  const dashboard = document.getElementById('dashboard');
  let html = `<table class="site-list">
    <thead><tr><th>Site</th><th>URL</th><th>Status</th><th>Port</th><th>Quick Actions</th></tr></thead><tbody>`;
  for (const site of SITES) {
    let status = 'checking...';
    let statusClass = '';
    try {
      status = await checkStatus(site);
      statusClass = status === 'up' ? 'status-up' : 'status-down';
    } catch {
      status = 'down';
      statusClass = 'status-down';
    }
    html += renderSiteRow(site, status, statusClass);
  }
  html += '</tbody></table>';
  dashboard.innerHTML = html;
}

function openFolder(folder) {
  alert(
    'Open folder: ' +
      folder +
      '\n(Implement this action with a local server or helper script)'
  );
}

window.onload = renderDashboard;
