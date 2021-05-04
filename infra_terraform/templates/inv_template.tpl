[server]
%{ for host in hosts ~}
%{ if host.role == "server" }${host.hostname}.dev-ops.live
%{ endif ~}
%{ endfor ~}

[client]
%{ for host in hosts ~}
%{ if host.role == "client" }${host.hostname}.dev-ops.live
%{ endif ~}
%{ endfor ~}
