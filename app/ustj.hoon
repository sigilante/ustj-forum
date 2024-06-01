/-  *forum
/+  dbug, lib=forum, const=constants
/=  router     /web/router
|%
++  card  card:agent:gall
+$  versioned-state
  $%  state-0
  ==
--
::  main agent core
%-  agent:dbug
=|  versioned-state
=*  state  -
^-  agent:gall
=<
::
|_  =bowl:gall
 +*  this      .
     hd   ~(. +> [state bowl])
++  on-fail   |~(* `this)
++  on-leave  |~(* `this)
++  on-save   !>(state)
++  on-init  
^-  (quip card _this)
:_  this  init-cards:hd

++  on-load   |=  old=vase 
:_  this(state !<(versioned-state old))  ~
++  on-watch  
|=  =(pole knot)
  ?+  pole  !!
  [%http-response id=@ ~]    `this
  ==
++  on-poke
|=  [=mark =vase]
|^
?+  mark  `this
%handle-http-request  serve
%noun  (on-poke-noun !<(* vase))
==
  ++  on-poke-noun
  |=  a=*
  ?:  ?=(%print a)  print
  ?:  ?=(%seed a)  seed
  `this
  ++  print
  ~&  >  state=state
  `this
  ++  seed
    =/  authors=(list @p)  :~
      ~zod
      ~polwex
      ~lagrev-nocfep
      ~lagrev-nocfep
    ==
    =/  titles=(list @t)
      :~ 
     'Helldivers 2 has caused over 20k Steam accounts to be banned'
     'UI elements with a hand-drawn, sketchy look'
     '60 kHz (2022)'
     'Show HN: Every mountain, building and tree shadow mapped for any date and time'
     'Snowflake breach: Hacker confirms access through infostealer infection'
     'Heroku Postgres is now based on AWS Aurora'
     'Armor from Mycenaean Greece turns out to have been effective'
     'Why is no Laravel/Rails in JavaScript? Will there be one?'
     'Moving Beyond Type Systems'
     'Japanese \'My Number Card\' Digital IDs Coming to Apple\'s Wallet App'
     'How to copy a file from a 30-year-old laptop'
     '(some) good corporate engineering blogs are written'
     'Debian KDE: Right Linux distribution for professional digital painting in 2024'
     'Go: Sentinel errors and errors.Is() slow your code down by 3000%'
     '"Moveable Type" to end 17-year run in The New York Times\'s lobby'
     'London\'s Evening Standard axes daily print edition'
      ==
    =/  rng  ~(. og eny.bowl)
    |-  ?~  titles  `this
      =^  r1  rng  (rads:rng 1)
      ~&  >>  rng=rng
      =/  r  (rad:rng 3)
      =/  =content  ?:  .=(0 r1)
      [%link 'https://urbit.org']  [%text ~]
      =/  author  (snag r authors)
      =/  date  (sub now.bowl (mul ~h1 (rad:rng 500)))
      =/  ted  (build-thread:lib i.titles author date content)
      =/  tally  (new:si [(? r1) (rad:rng 1.000)])
      =.  ted  ted(votes [tally ~])
      =.  threads  (put:torm threads [author date] ted)
      
      $(titles t.titles)
  ::
  ++  serve
  ^-  (quip card _this)
  ~&  eyre-poke=now.bowl
  =/  order  !<(order:router vase)
  =/  address  address.req.order
  :: ?:  (~(has in banned.admin) address)  `this  
  :: ~&  >>>  malicious-request-alert=req.order  `this
  :_  this
  %-  route:router  [order state bowl]
--
++  on-peek   
|=  =(pole knot)  ~
++  on-agent
|=  [=wire =sign:agent:gall]  `this
++  on-arvo
|=  [=(pole knot) =sign-arvo]  `this
--
::  helper
|_  [s=versioned-state =bowl:gall]
++  cache-card  |=  [pathc=@t pl=simple-payload:http]  ^-  card
  =/  entry=cache-entry:eyre  [.n %payload pl]
  [%pass /root %arvo %e %set-response pathc `entry]
++  root-path-card  ^-  card
  [%pass /root %arvo %e %connect [~ /forum] dap.bowl]
++  init-cards  ^-  (list card)
:~  root-path-card
==
++  schedule-backup-card  ^-  card
  [%pass /backup %arvo %b %wait (add now.bowl ~h6)]
--
