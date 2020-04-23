#!/bin/bash
set -e
set -x

cd /vagrant

php /vagrant/bin/console SaintCoinachRedisCustomCommand Quest

php /vagrant/bin/console SaintCoinachRedisCustomCommand Transient
php /vagrant/bin/console SaintCoinachRedisCustomCommand Recipe
php /vagrant/bin/console SaintCoinachRedisCustomCommand Achievement
php /vagrant/bin/console SaintCoinachRedisCustomCommand Fate
php /vagrant/bin/console SaintCoinachRedisCustomCommand Icons
php /vagrant/bin/console SaintCoinachRedisCustomCommand InstanceContent
php /vagrant/bin/console SaintCoinachRedisCustomCommand Item
php /vagrant/bin/console SaintCoinachRedisCustomCommand ItemAction
php /vagrant/bin/console SaintCoinachRedisCustomCommand ItemFood
php /vagrant/bin/console SaintCoinachRedisCustomCommand LogMessage
php /vagrant/bin/console SaintCoinachRedisCustomCommand Materia
php /vagrant/bin/console SaintCoinachRedisCustomCommand NPC
php /vagrant/bin/console SaintCoinachRedisCustomCommand Orchestrion
php /vagrant/bin/console SaintCoinachRedisCustomCommand PatchHelper
php /vagrant/bin/console SaintCoinachRedisCustomCommand PlaceName
php /vagrant/bin/console SaintCoinachRedisCustomCommand Servers
php /vagrant/bin/console SaintCoinachRedisCustomCommand Stain
php /vagrant/bin/console SaintCoinachRedisCustomCommand TripleTriadCardDescriptions
php /vagrant/bin/console SaintCoinachRedisCustomCommand Characters
php /vagrant/bin/console SaintCoinachRedisCustomCommand CraftLeve
php /vagrant/bin/console SaintCoinachRedisCustomCommand Leve
php /vagrant/bin/console SaintCoinachRedisCustomCommand UIColor
php /vagrant/bin/console SaintCoinachRedisCustomCommand Links

php /vagrant/bin/console SaintCoinachRedisCustomCommand SkillDescriptions
