Role Name
=========

Ce role Anisble maintient un composant keepalived sur une machine virtuelle Red Hat. Deux usages de keepalived sont possibles, correspondant aux modes suivants :
- Mode failover : Pour faire du failover automatique d'un service installe sur le meme serveur que keepalived. Necessite deux serveurs en actif-passif avec keepalived et le service installes.
- Mode HA : Pour faire un loadbalancer L4 (tcp) avec deux serveurs keepalived en actif-passif. Le loadbalancer fait du source NAT pour que se soit transparent pour les real servers.

Fonctionnalites notables :
- VIP multiples, serveurs virtuels multiples
- Notifications par mail sur events keepalived et real servers
- Mode unicast et multicast
- Scripts custom check real servers
- Ponderation real servers sur l'algorithme round-robin et real server de backup
- Log dans syslog ou dans un fichier didie

Requirements
------------

Supporte Red Hat 7 et 8. Teste avec keepalived 2.0.10 et ansible 2.8.4.

Attention, si unicast actif alors le playbook a besoin des anisble_facts de l'ensemble des serveurs keepalived (a cause des peer address a remplir dans le fichier de conf).

Mode failover : Role Variables
--------------

Exemple de configuration, voir le fichier default/main.yml pour l'ensemble des variables disponibles.
```
# Keepalived
keepalived_state: "present" #present ou absent
keepalived_process: "httpd" #process local monitore
keepalived_routerid: "50" #id du LVS, doit etre unique sur le reseau
keepalived_master: "keepalived1.toto.fr" #fqdn du noeud actif, doit matcher dans l'inventaire ansible
keepalived_alert: true #active les alertes par mail
keepalived_mail: "keepalived@toto.fr" #expediateur des alertes
keepalived_admin: "admin@toto.fr" #destinatire des alertes
keepalived_passwd: "toto" #mot de passe utilise pour la communication entre les noeuds keepalived
keepalived_interface: "eth0" #interface physique ou seront attaches les VIP
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
keepalived_master: "tcgildaplb1.users.interne"
keepalived_backup: "tcgildaplb2.users.interne"
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
  - name: 'ldap1'
    ip: 192.168.1.1
    port: 636
    weight: 100 #ce serveur aura 100 fois plus de requetes que le serveur ldap2
  - name: 'ldap2'
    ip: 192.168.1.2
    port: 636
    weight: 1
  - name: 'ldap3'
    ip: 192.168.1.3
    port: 636
    weight: 0 #ce serveur est passif
```

Dependencies
------------
Voir le fichier default/main.yml pour l'ensemble des variables disponibles.

Pas de depenance, paquet keepalived present dans les repo Red Hat standards. Peut utiliser unicast si le multicast n'est pas autorise sur votre reseau.

License
-------

CECILL-2.1

Author Information
------------------

Gilian GAMBINI @ DSI-CNRS
