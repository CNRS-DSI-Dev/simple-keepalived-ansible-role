Role Name
=========

Pilote un composant keepalived pour faire du failover automatique d'un process local. Necessite deux serveurs avec keepalived, en actif-passif. 
Fonctionnalites :
- Supporte les multiples VIP
- Supporte les alertes par mail
- Supporte unicast et multicast

Requirements
------------

Supporte Red Hat 7 et 8.

Role Variables
--------------

Voir le fichier default/main.yml pour l'ensemble des variables disponibles.

Attention, si unicast actif alors le playbook a besoin des anisble_facts de l'ensemble des serveurs keepalived (a cause des peer address a remplir dans le fichier de conf)

Dependencies
------------

Pas de depenance, paquet keepalived present dans les repo Red Hat standards. Peut utiliser unicast si le multicast n'est pas disponible.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: loadbalancer
      roles:
         - role: simple-keepalived-ansible-role

License
-------

BSD

Author Information
------------------

Gilian GAMBINI @ DSI-CNRS
