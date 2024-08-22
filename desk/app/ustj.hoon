/-  *forum
/+  dbug, sr=sortug, lib=forum, const=constants, seeds, cacher
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
     rout   ~(. router:router [state bowl])
     cache  ~(. cacher [state bowl])
++  on-fail   |~(* `this)
++  on-leave  |~(* `this)
++  on-save   !>(state)
++  on-init  
^-  (quip card _this)
:_  this  init-cards:hd

++  on-load   |=  old=vase 
:_  this(state !<(versioned-state old))
  :: :-  cache-root:cache  cache-static:cache
  ~
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
  ?:  ?=([%ui *] a)  (handle-ui a)
  ?:  ?=([%cache *] a)   (handle-cache +.a)
  ?:  ?=(%test a)  test
  ?:  ?=(%print a)  print
  ?:  ?=(%seed a)   teds:seed
  ?:  ?=(%seed2 a)  coms:seed
  ?:  ?=(%seed3 a)  reps:seed
  ::  admin
  ?:  ?=([%hr @p ?] a)   (handle-hr +.a)
  ?:  ?=([%ban @p ?] a)  (handle-ban +.a)
  ?:  ?=([%del-ted @t] a)  (handle-del .y +.a)
  ?:  ?=([%del-com @t] a)  (handle-del .n +.a)
  ~&  wtf=a
  `this
  ++  handle-del  |=  [is-ted=? uidt=@t]
      =/  uid  (slaw:sr %uw uidt)  ?~  uid  !!
      =/  cued  (cue u.uid)
      =/  pid  %-  (soft pid:tp)  cued
      ?~  pid  !!
    =^  cards  state  
    %+  handle-del:cache  is-ted  u.pid
    [cards this]
  ++  handle-hr  |=  [=ship w=?]
    ?>  .=(src.bowl our.bowl)
    =.  admins  ?:  w  
      (~(put in admins) ship)
      (~(del in admins) ship)
    `this
  ++  handle-ban  |=  [=ship w=?]
    ?>  (~(has in admins) src.bowl)
    =.  blacklist  ?:  w  
      (~(put in blacklist) ship)
      (~(del in blacklist) ship)
    `this
  ++  handle-cache  |=  a=*  :_  this  
    =/  which  ($?(%root %ted %sta %all) a)
    ?-  which
      %root  :~(cache-root:cache)
      %sta   cache-static:cache
      %ted   cache-threads:cache
      %all   cache-all:cache
    ==
  ++  handle-ui  |=  noun=*
    =^  cards  state  (handle-ui:cache noun)
    [cards this]
  ++  test
    =/  teds  (tap:torm threads)
    ~&  teds=(lent teds)
    =/  coms  (tap:gorm:tp comments)
    ~&  coms=(lent coms)
  `this
  ++  print
  ~&  >  state=state
  `this
  ++  seed
    =/  rng  ~(. og eny.bowl)
    |%
    ++  teds
    =.  admins  admins:const
    =/  titles  titles:seeds
    =.  state
    |-  ?~  titles  state
      =^  r1  rng  (rads:rng 100)
      =/  coinflip=?  (lte 50 r1)
      =/  =content  ?:  coinflip
        =/  ind  (rad:rng (lent links:seeds))  
        =/  url  (snag ind links:seeds)
          [%link url]  
        =/  ind  (rad:rng (lent md:seeds))  
        =/  md  (snag ind md:seeds)
        =/  cl  (build-content:lib md)
           [%text cl]
       =/  author  
         =/  ind  (rad:rng (lent authors:seeds))  
         (snag ind authors.seeds)
       =/  date  (sub now.bowl (mul ~h1 (rad:rng 500)))
       =/  ted  (build-thread:lib i.titles author date content)
       =/  tally  (new:si [coinflip (rad:rng 1.000)])
       =.  ted  ted(votes [tally ~])
       =.  threads  (put:torm threads [author date] ted)
      $(titles t.titles)
    :_  this  cache-all:cache
    ++  reps
      =/  coml  (tap:gorm:tp comments)
      =^  r  rng  (rads:rng 100)
      =.  state
      |-  ?~  coml  state
        =/  com=comment:tp  +.i.coml
        =/  ppid  [author.com id.com]
        =^  r0  rng  (rads:rng 300)
        =/  subcoms  (make-seed-comments thread.com ppid)
        =.  state  (save-replies subcoms com)
        $(coml t.coml)
      :_  this  cache-all:cache
    ++  coms
      =/  tedl  (tap:torm threads)
      =^  r  rng  (rads:rng 100)
      =.  state
      |-  ?~  tedl  state
        =/  ted=thread  +.i.tedl
        =^  r0  rng  (rads:rng 30)
        ::  important!! renew the rng before every function call
        =/  coms  (make-seed-comments pid.ted pid.ted)
        =.  state  (save-comments coms ted)
        $(tedl t.tedl)
      :_  this  cache-all:cache
      
  ++  save-replies  |=  [cl=(list comment:tp) par=comment:tp]  ^+  state
    |-  ?~  cl  state
    =/  c  i.cl
    =/  cpid=pid:tp  [author.c id.c]
    =.  comments  (put:gorm:tp comments cpid c)
    =/  nc  (~(put in children.par) cpid)
    =.  par  par(children nc)
    =/  ppid  [author.par id.par]
    =.  comments  (put:gorm:tp comments ppid par)
    $(cl t.cl)

  ++  save-comments  |=  [cl=(list comment:tp) ted=thread]  ^+  state
    |-  ?~  cl  state
    =/  c  i.cl
    =/  cpid=pid:tp  [author.c id.c]
    =.  comments  (put:gorm:tp comments cpid c)
    =/  nr  [cpid replies.ted]
    =/  nted  ted(replies nr)
    =.  threads  (put:torm threads pid.ted nted)
    $(cl t.cl, ted nted)
    
  ++  make-seed-comments  |=  [tpid=pid:tp ppid=pid:tp]
    =|  coms=(list comment:tp)
    =^  r0  rng  (rads:rng 30)
    :: ~&  >>  r0=r0
    =/  l  (gulf 0 r0)
    |-  ?~  l  coms
      =^  r1  rng  (rads:rng 100)
      :: ~&  r1=r1
      =/  coinflip=?  (lte 50 r1)
      =/  content  
        =/  ind  (rad:rng (lent md:seeds))  
        =/  md  (snag ind md:seeds)
        (build-content:lib md)
      =/  author  
        =/  ind  (rad:rng (lent authors:seeds))  
        (snag ind authors.seeds)
      =/  date  (sub now.bowl (mul ~h1 (rad:rng 500)))
      =.  bowl  bowl(src author, now date)
      =/  com  (build-comment:lib content bowl tpid ppid)
      =/  tally  (new:si [coinflip (rad:rng 1.000)])
      =.  com  com(votes [tally ~])
      $(l t.l, coms [com coms])
    --
  ::
  ++  serve
  ^-  (quip card _this)
  =/  order  !<(order:router vase)
  =/  address  address.req.order
  :: ?:  (~(has in banned.admin) address)  `this  
  :: ~&  >>>  malicious-request-alert=req.order  `this
  :_  this  (eyre:rout order)
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
:: ++  static-caches  ^-  (list card)
:: :~  (cache-card '/forum/new-thread' (render:rout '/new-thread'))
::     :: (cache-card '/forum/new-thread')
:: ==
++  root-path-card  ^-  card
  [%pass /root %arvo %e %connect [~ /forum] dap.bowl]
++  init-cards  ^-  (list card)
:~  root-path-card
==
++  schedule-backup-card  ^-  card
  [%pass /backup %arvo %b %wait (add now.bowl ~h6)]
--