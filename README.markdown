TeamLog
=======

Features
--------

* Users can create teams
* Team leader adds people via email address
* Users can post status updates
* Users can view a dashboard of each team member's current status

Schema
------

### teams ###

* id
* name

### team users ###

* id
* team id
* user id
* role

### users ###

* id
* email

### messages ###

* id
* user id
* team id
* content
