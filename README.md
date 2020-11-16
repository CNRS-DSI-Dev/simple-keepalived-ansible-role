Role Name
=========

Ce rôle Anisble maintient un composant keepalived sur une machine virtuelle Red Hat. Deux usages de keepalived sont possibles, correspondant aux modes suivants :
- Mode failover (par défaut) : Pour faire du failover automatique d'un service installé sur deux machines virtuelles. Les démons du service sont en actif-passif et keepalived doit être installé sur les deux machines virtuelles.
- Mode HA : Pour faire un loadbalancer L4 (tcp) avec au moins deux serveurs keepalived. Le loadbalancer fait du source NAT pour que se soit transparent pour les real servers.

Fonctionnalités notables :
- VIP multiples, serveurs virtuels multiples
- Notifications par mail sur events keepalived et real servers
- Modes unicast et multicast
- Scripts custom pour les checks des real servers
- Pondération des real servers sur l'algorithme round-robin et real server de backup
- Log dans syslog ou dans un fichier dédié

Requirements
------------

Supporte Red Hat 7 et 8. Testé avec keepalived 1.3.5 et 2.0.10.

Attention, si unicast actif alors le playbook a besoin des anisble_facts de l'ensemble des serveurs keepalived (à cause des peer address à remplir dans le fichier de conf). En d'autres termes, en unicast, il faut exécuter le playbook sur tous les LB en même temps (pas de serial 1).

Mode failover : Role Variables
--------------

Exemple de configuration, voir le fichier default/main.yml pour l'ensemble des variables disponibles.
```
# Keepalived
keepalived_state: "present" #present ou absent
keepalived_check_failover: "/usr/sbin/pidof httpd" #check du process local
keepalived_routerid: "50" #id du LVS, doit etre unique sur le reseau
keepalived_master: "lb1.domain.local" #fqdn du noeud actif, doit matcher dans l'inventaire ansible
keepalived_alert: true #active les notifications par mail
keepalived_mail: "keepalived@toto.fr" #expéditeur des alertes
keepalived_admin: "admin@toto.fr" #destinatire des alertes
keepalived_passwd: "toto" #mot de passe utilise pour la communication entre les noeuds keepalived
keepalived_interface: "eth0" #interface physique où seront attachées les VIP
keepalived_vip: "192.168.0.254"
```

Mode HA : Role Variables
--------------

Exemple de configuration, voir le fichier default/main.yml pour l'ensemble des variables disponibles.
```
# Keepalived
keepalived_state: "present" #present ou absent
keepalived_mode: "ha"
keepalived_routerid: "51"
keepalived_unicast: true
keepalived_master: "lb1.domain.local"
keepalived_backup: "lb2.domain.local"
keepalived_passwd: "toto" #mot de passe utilise pour la communication entre les noeuds keepalived
keepalived_interface: "eth0" #interface physique ou seront attaches les VIP
keepalived_logfile: '/var/log/keepalived.log'
keepalived_history: '7' #semaines de retention

# VIP configuration
keepalived_vip:
- name: 'vipldap'
  vip: 192.168.1.254 #adresse du serveur virtuel sur le keepalived actif
  port: 636 #port d'ecoute du server virtuel
  check_script: 'check_ldaps.sh' #script custom ou l'on passe l'ip et le port du serveur reel
  servers: #pool de serveur reel
  - name: 'ldap1.domain.local'
    ip: 192.168.1.1
    port: 636
    weight: 100 #ce serveur aura 100 fois plus de requetes que le serveur ldap2
  - name: 'ldap2.domain.local'
    ip: 192.168.1.2
    port: 636
    weight: 1
  - name: 'ldap3.domain.local'
    ip: 192.168.1.3
    port: 636
    weight: 0 #ce serveur est passif
```

Dependencies
------------

Pas de dépendance, le paquet keepalived présent dans les dépôts Red Hat standards. Peut utiliser unicast si le multicast n'est pas autorisé sur les équipements reseaux.

License
-------

AGPLv3 

Author Information
------------------

Gilian GAMBINI @ DSI-CNRS
