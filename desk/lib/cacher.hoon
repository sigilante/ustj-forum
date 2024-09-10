/-  sur=forum, tp=post
/+  lib=forum, sr=sortug, cons=constants,
    naive, ethereum
/=  router  /web/router
::
|_  [state:sur bowl:gall]
+*  this  .
    rout  ~(. router:router +6)
    state  -.+6
    bowl   +.+6
+$  card  card:agent:gall
++  handle-ui
  |=  noun=*  ^-  [(list card) _state]
  =/  poke  (pokes:sur noun)
  =.  src  ship.poke
  =/  eyre-id  eyre-id.poke
  |^
  ?-  -.p.poke
    %submit-thread   (handle-thread +.p.poke)
    %submit-comment  (handle-comment +.p.poke)
    %submit-reply    (handle-reply +.p.poke)
    %vote            (handle-vote +.p.poke)
    %del             (handle-del +.p.poke)
  ==
  ++  handle-thread
    |=  [title=@t url=@t text=@t]
    =/  =content:sur  ?.  .=('' url)  [%link url]  [%text (build-content:lib text)]
    =/  ted  (build-thread:lib title src now content)
    =.  state  (save-ted ted)
    :_  state  :+
        cache-root
      (cache-ted pid.ted)
    (redirect-ted pid.ted)
  ++  handle-comment
    |=  [ted=thread:sur text=@t]
    =/  cont  (build-content:lib text)
    =/  com  (build-comment:lib cont bowl pid.ted pid.ted)
    =.  state  (save-com com ted)
    :_  state  :+
        cache-root
      (cache-ted pid.ted)
    (redirect-ted pid.ted)
  ++  handle-reply
    |=  [par=comment:tp text=@t]
    =/  cont  (build-content:lib text)
    =/  ppid  [author.par id.par]
    =/  com  (build-comment:lib cont bowl thread.par ppid)
    =/  ted  (get-thread:lib thread.par state)
    ?~  ted  `state
    =.  state  (save-rep com par)
    :_  state  :*
        cache-root
        (cache-ted pid.u.ted)
        (cache-com com)
        (cache-com par)
        (redirect-com par)
    ==
  ++  handle-vote
    |=  [is-ted=? =pid:tp vote=?]
    ?:  is-ted
      (handle-ted-vote pid vote)
    (handle-com-vote pid vote)
  ++  handle-ted-vote
    |=  [=pid:tp vote=?]
    =/  votesi=@si  (new:si vote 1)
    =/  uted  (get-thread:lib pid state)
    ?~  uted  `state
    =/  ted  u.uted
    =/  v  votes.ted
    =/  nv
      ::  have they voted before?
      ?:  (~(has by leger.v) src.bowl)
        ~&  >  'already voted'
        ::  is their vote the same?
        ?:  =((~(got by leger.v) src.bowl) vote)
          ~&  >  'canceling vote'
          ::  yes to both so cancel the vote
          %=  v
            tally  (dif:si tally.v votesi)
            leger  (~(del by leger.v) src.bowl)
          ==
        ~&  >  'reversing vote'
        ::  yes/no so reverse the vote
        %=  v
          tally  (sum:si tally.v (pro:si --2 votesi))
          leger  (~(put by leger.v) src.bowl vote)
        ==
      ~&  >  'new vote'
      ::  no so add the vote
      %=  v
        tally   (sum:si tally.v votesi)
        leger   (~(put by leger.v) src.bowl vote)
      ==
    =.  ted  ted(votes nv)
    =.  state  (save-ted ted)
    =.  state  (save-karma ship.pid.ted vote)
    :_  state  :~
      cache-root
      (cache-ted pid.ted)
      (cache-user ship.pid.ted)
      :: (redirect-ted pid.ted)
    ==
  ++  handle-com-vote
    |=  [=pid:tp vote=?]
    =/  votesi=@si  (new:si vote 1)
    =/  ucom  (get-comment:lib pid state)
    ?~  ucom  `state
    =/  com  u.ucom
    =/  v  votes.com
    =/  nv
      ::  have they voted before?
      ?:  (~(has by leger.v) src.bowl)
        ::  is their vote the same?
        ?:  =((~(got by leger.v) src.bowl) vote)
          ::  yes to both so cancel the vote
          %=  v
            tally  (dif:si tally.v votesi)
            leger  (~(del by leger.v) src.bowl)
          ==
        ::  yes/no so reverse the vote
        %=  v
          tally  (sum:si tally.v (pro:si --2 votesi))
          leger  (~(put by leger.v) src.bowl vote)
        ==
      ::  no so add the vote
      %=  v
        tally   (sum:si tally.v votesi)
        leger   (~(put by leger.v) src.bowl vote)
      ==
    =.  com  com(votes nv)
    =.  comments  (put:gorm:tp comments pid com)
    =.  state  (save-karma author.com vote)
    :_  state  :~
      cache-root
      (cache-com com)
      (cache-user author.com)
      :: (redirect-com com)
    ==
  ::  redirectors
  ++  redirect-root  (redirect:router eyre-id "")
  ++  redirect-ted
    |=  =pid:tp
    =/  link  (scow:sr %uw (jam pid))
    =/  url  "/ted/{link}"
    (redirect:router eyre-id url)
  ++  redirect-com
    |=  com=comment:tp
    =/  link  (scow:sr %uw (jam [author.com id.com]))
    =/  url  "/com/{link}"
    (redirect:router eyre-id url)
  --
::  cache builders
++  cache-root  (cache-card "")
++  cache-ted
  |=  =pid:tp
  =/  link  (scow:sr %uw (jam pid))
  =/  url  "/ted/{link}"
  (cache-card url)
++  cache-com
  |=  com=comment:tp
  =/  link  (scow:sr %uw (jam [author.com id.com]))
  =/  url  "/com/{link}"
  (cache-card url)
++  cache-threads
  ^-  (list card)
  =|  l=(list card)
  ::  threads
  =/  teds  (tap:torm:sur threads)
  =.  l  |-  ?~  teds  l
    =/  ted=thread:sur  +.i.teds
    =/  car  (cache-ted pid.ted)
    $(teds t.teds, l [car l])
  :-  cache-root  l
++  cache-user
  |=  who=@p
  =/  p  (scow %p who)
  (cache-card "/usr/{p}")
++  cache-static
  ^-  (list card)
  :~  (cache-card "/log")
      (cache-card "/add")
      :: (cache-card "/auth")
      :: (cache-card "/metamask")
      (cache-card "/style.css")
      (cache-card "/imgs/favicon.ico")
      (cache-card "/imgs/favicon-16x16.png")
      (cache-card "/imgs/favicon-32x32.png")
      (cache-card "/site.webmanifest")
      (cache-card "/forum")
  ==
++  cache-all
  ^-  (list card)
  =|  l=(list card)
  ::  threads
  =/  teds  (tap:torm:sur threads)
  =.  l  |-  ?~  teds  l
    =/  ted=thread:sur  +.i.teds
    =/  car  (cache-ted pid.ted)
    $(teds t.teds, l [car l])
  =/  coms  (tap:gorm:tp comments)
  =.  l  |-  ?~  coms  l
    =/  com=comment:tp  +.i.coms
    =/  car  (cache-com com)
    $(coms t.coms, l [car l])
  :-  cache-root  (weld cache-static l)

++  wipe  ^-  (list card)
  ^-  (list card)
  =|  l=(list card)
  ::  threads
  =/  teds  (tap:torm:sur threads)
  =.  l  |-  ?~  teds  l
    =/  ted=thread:sur  +.i.teds
    =/  car  
      =/  link  (scow:sr %uw (jam pid.ted))
      =/  url  "/ted/{link}"
      (uncache-card url)
    $(teds t.teds, l [car l])
  =/  coms  (tap:gorm:tp comments)
  =.  l  |-  ?~  coms  l
    =/  com=comment:tp  +.i.coms
    =/  car  
      =/  link  (scow:sr %uw (jam [author.com id.com]))
      =/  url  "/com/{link}"
      (uncache-card url)
    $(coms t.coms, l [car l])
  %+  weld  l
  :~  (uncache-card "/log")
      (uncache-card "/add")
      :: (uncache-card "/auth")
      :: (uncache-card "/metamask")
      (uncache-card "/style.css")
      (uncache-card "/imgs/favicon.ico")
      (uncache-card "/imgs/favicon-16x16.png")
      (uncache-card "/imgs/favicon-32x32.png")
      (uncache-card "/site.webmanifest")
      (uncache-card "/forum")
      (uncache-card "")
  ==
::  state updaters
++  save-ted
  |=  ted=thread:sur
  =.  threads  (put:torm:sur threads pid.ted ted)
  state
::  comments to threads
++  save-com
  |=  [com=comment:tp ted=thread:sur]
  =/  =pid:tp  [author.com id.com]
  =/  nr  [pid replies.ted]
  =.  ted  ted(replies nr)
  =.  threads  (put:torm:sur threads pid.ted ted)
  =.  comments  (put:gorm:tp comments pid com)
  state
::  replies to comments
++  save-rep
  |=  [com=comment:tp par=comment:tp]
  =/  =pid:tp  [author.com id.com]
  =.  comments  (put:gorm:tp comments pid com)
  =/  ppid  [author.par id.par]
  =/  nc  (~(put in children.par) pid)
  =.  par  par(children nc)
  =.  comments  (put:gorm:tp comments ppid par)
  state
++  wipe-coms
  |=  [ted=pid:tp]
  =/  coms  (tap:gorm:tp comments)
  |-  ?~  coms  comments
  =/  com=comment:tp  +.i.coms
  ?.  .=(ted thread.com)  $(coms t.coms)
  =.  comments  +:(del:gorm:tp comments [author.com id.com])
  $(coms t.coms)
++  wipe-reps
  |=  [par=pid:tp]
  =/  coms  (tap:gorm:tp comments)
  |-  ?~  coms  comments
  =/  com=comment:tp  +.i.coms
  ?.  .=(par parent.com)  $(coms t.coms)
  =.  comments  +:(del:gorm:tp comments [author.com id.com])
  $(coms t.coms)
++  save-karma
  |=  [who=@p vote=?]
  =/  curr  (~(get by karma) who)
  =/  cur  ?~  curr  `@sd`0  u.curr
  =/  votesd  (new:si vote 1)
  =/  new  (sum:si cur votesd)
  =.  karma  (~(put by karma) who new)
  state
++  cache-card
::  provisional until we figure out a permanent fix
  uncache-card
:: ++  cache-card
::   |=  path=tape  ^-  card
::   =/  pathc  (crip "{base-url:cons}{path}")
::   ~&  >>  caching=pathc
::   =/  router-path  ?~  path  '/'  pathc
::   =/  pl=simple-payload:http  (render:rout router-path)
::   =/  entry=cache-entry:eyre  [.n %payload pl]
::   [%pass /root %arvo %e %set-response pathc `entry]
++  uncache-card
  |=  path=tape  ^-  card
  =/  pathc  (crip "{base-url:cons}{path}")
  ~&  >>  uncaching=pathc
  =/  router-path  ?~  path  '/'  pathc
  =/  pl=simple-payload:http  (render:rout router-path)
  =/  entry=cache-entry:eyre  [.n %payload pl]
  [%pass /root %arvo %e %set-response pathc ~]
++  handle-del
  |=  [is-ted=? =pid:tp]
  ?:  is-ted
  =/  ted  (get-thread:lib pid state)
  ?~  ted  `state
  =.  threads  +:(del:torm:sur threads pid)
  =.  comments  (wipe-coms pid)
  :_  state  :+
      cache-root
    (cache-ted pid)
  ~
  :: redirect-root
  ::
  =|  l=(list card)
  =/  ucom   (get-comment:lib pid state)
  ?~  ucom  `state  =/  com  u.ucom
  =.  comments  (wipe-reps pid)
  =.  l  [(cache-com com) l]
  =/  upar   (get-comment:lib parent.com state)
  ::  delete from child of parent
  =.  comments  ?~  upar  comments
    =/  par  u.upar
    =/  nc  (~(del in children.par) pid)
    =.  par  par(children nc)
    =.  l  [(cache-com par) l]
    (put:gorm:tp comments [author.par id.par] par)
  ::  delete from reply of thread
  =/  uted  (get-thread:lib thread.com state)
  =.  threads  ?~  uted  threads
    =/  ted  u.uted
    =/  nr  %+  skip  replies.ted  |=  rp=pid:tp  .=(rp pid)
    =.  ted  ted(replies nr)
    =.  l  [(cache-ted pid.ted) l]
    (put:torm:sur threads pid.ted ted)
  :_  state  :-
    cache-root
  l
--
