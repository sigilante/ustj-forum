/-  sur=forum, tp=post
/+  lib=forum, sr=sortug, rd=rudder, cons=constants,
    naive, ethereum
/+  server
::  pages and components
/=  layout        /web/layout
/=  navbar        /web/components/navbar
/=  index         /web/pages/index
/=  thread        /web/pages/thread
/=  comment-page  /web/pages/comment
/=  add-comment   /web/pages/add-comment
/=  add-thread    /web/pages/add-thread
/=  login-page    /web/pages/login
/=  user-page     /web/pages/user
::  assets
/*  css       %css    /web/assets/style/css
/*  spinner   %noun   /web/assets/spinner/svg
/*  favicon   %noun   /web/assets/favicon/ico
/*  favicon1  %noun   /web/assets/favicon-32x32/png
/*  favicon2  %noun   /web/assets/favicon-16x16/png
::
|%
+$  order  [id=@ta req=inbound-request:eyre]
++  pbail
  %-  html-response:gen:server
  %-  manx-to-octs:server
      manx-bail
++  manx-bail  ^-  manx  ;div:"404"
++  manx-payload
  |=  =manx
  ^-  simple-payload:http
  %-  html-response:gen:server
  %-  manx-to-octs:server  manx
++  redirect  |=  [eyre-id=@ta path=tape]
  =/  url  (crip "{base-url:cons}{path}")
  =/  pl  (redirect:gen:server url)
  (give-simple-payload:app:server eyre-id pl)
::  main
++  router
  |_  [=state:sur =bowl:gall]
  ++  eyre
    |=  =order
    ^-  (list card:agent:gall)
    =/  rl  (parse-request-line:server url.request.req.order)
    =.  site.rl  ?~  site.rl  ~  t.site.rl
    =/  met  method.request.req.order
    =/  fpath=(pole knot)  [met site.rl]
    |^
    :: if file extension assume its asset
    ?.  ?=(~ ext.rl)     (eyre-give (serve-assets rl))
    ?+    fpath  bail
        [%'GET' %metamask rest=*]  (handle-metamask order)
        [%'GET' rest=*]
      (eyre-manx (serve-get rl(site rest.fpath)))
        [%'POST' rest=*]
      (serve-post id.order rl(site rest.fpath) body.request.req.order)
    ==
    ::
    ++  bail  (eyre-give pbail)
    ++  eyre-give
      |=  pl=simple-payload:http
      ^-  (list card:agent:gall)
      (give-simple-payload:app:server id.order pl)

    ++  eyre-manx
      |=  =manx
      %-  eyre-give
      %-  html-response:gen:server
      %-  manx-to-octs:server  manx
    --
  ::
  ++  render
    |=  url=@t
    ^-  simple-payload:http
    =/  rl  (parse-request-line:server url)
    =.  site.rl  ?~  site.rl  ~
      t.site.rl
    =/  =(pole knot)  [%'GET' site.rl]
    ?.  ?=(~ ext.rl)
      (serve-assets rl)
    %-  manx-payload
    ^-  manx
    ?+    pole  manx-bail
      [%'GET' rest=*]    (serve-get rl(site rest.pole))
      :: [%'POST' rest=*]   (serve-post rl(site rest.pole))
    ==
  ++  serve-assets
    |=  rl=request-line:server
    ?+  [site ext]:rl  pbail
      [[%style ~] [~ %css]]  (css-response:gen:server (as-octs:mimes:html css))
      :: [[%spinner ~] [~ %svg]]   [%full (serve-other:kaji %svg spinner)]
      :: [[%sw ~] [~ %js]]          [%mime /text/javascript sw]
      :: [[%manifest ~] [~ %json]]  [%mime /application/json manifest]
    ==
  ++  serve-get
    |=  rl=request-line:server
    ^-  manx
    =/  p=(pole knot)  site.rl
    ::
    ?:  ?=([%f rest=*] p)  (serve-fragment rest.p)
    %-  add-layout
    ?+  p  manx-bail
      ~                (serve-index '1')
      [~ ~]            (serve-index '1')
      [%p p=@t ~]      (serve-index p.p)
      [%ted ted=@t ~]  (serve-thread ted.p)
      [%com uid=@t ~]  (serve-comment uid.p)
      [%rep uid=@t ~]  (reply-page uid.p)
      [%usr p=@t ~]    (serve-user p.p)
      [%add ~]         (add-thread bowl)
      [%log ~]         (login-page state)
    ==
  ++  add-layout
    |=  m=manx
    %-  layout
    :~  (navbar state bowl)
        m
    ==
  ++  serve-fragment
    |=  =(pole knot)
    ^-  manx
    ?+    pole  !!
        [%sigil ~]
      =/  navb  ~(. navbar [state bowl])
      =/  userdiv  login:navb
      userdiv
    ==
  ++  serve-user
    |=  t=@t
    ^-  manx
    =/  patp  (slaw %p t)  ?~  patp  manx-bail
    =/  teds  (get-user-teds:lib u.patp state)
    =/  coms  (get-user-coms:lib u.patp state)
    =/  karma  (get-user-karma:lib u.patp state)
    (user-page u.patp teds coms karma)
  ++  serve-index
    |=  t=@t
    ^-  manx
    =/  pag  (slaw %ud t)  ?~  pag  manx-bail
    =/  threads
      (get-thread-page:lib u.pag state)
    (index [u.pag threads] state bowl)
  ++  serve-comment
    |=  uidt=@t
    ^-  manx
    =/  uid  (slaw:sr %uw uidt)  ?~  uid  manx-bail
    =/  cued  (cue u.uid)
    =/  pid  ((soft pid:tp) cued)  ?~  pid  manx-bail
    =/  com  (get-comment:lib u.pid state)  ?~  com  (serve-thread uidt)
    =/  ted  (get-thread:lib thread.u.com state)  ?~  ted  manx-bail
    =/  fn  (node-to-full:lib u.com comments.state)
    (comment-page u.ted fn bowl)
  ++  reply-page
    |=  uidt=@t
    ^-  manx
    =/  uid  (slaw:sr %uw uidt)  ?~  uid  manx-bail
    =/  cued  (cue u.uid)
    =/  pid  ((soft pid:tp) cued)  ?~  pid  manx-bail
    =/  com  (get-comment:lib u.pid state)  ?~  com  manx-bail
    =/  ted  (get-thread:lib thread.u.com state)
    ?~  ted  manx-bail
    (add-comment u.ted u.com bowl)
  ++  serve-thread
    |=  uidt=@t
    ^-  manx
    =/  uid  (slaw:sr %uw uidt)  ?~  uid  manx-bail
    =/  cued  (cue u.uid)
    =/  pid  ((soft pid:tp) cued)  ?~  pid  manx-bail
    =/  ted  (get-thread:lib u.pid state)  
    ?~  ted  manx-bail
    =/  fg  (get-comment-list:lib u.ted comments.state)
    (thread u.ted fg bowl)
    ::
    ++  handle-metamask  |=  =order
      ::  special-case MetaMask auth handling
      =/  new-challenge  (sham [now eny]:bowl)
      %+  weld  (self-poke [%meta new-challenge])
      %+  give-simple-payload:app:server
        id.order
      ^-  simple-payload:http
      :-  :-  200
          ~[['Content-Type' 'application/json']]
      `(as-octs:mimes:html (en:json:html (enjs-challenge new-challenge)))
      ::
    
  ++  serve-post
    |=  [eyre-id=@ta rl=request-line:server body=(unit octs)]
    |^
    =/  p=(pole knot)  site.rl
    ?+  p  ~
      [%reply ~]       (handle-reply .n)
      [%comment ~]     (handle-reply .y)
      [%new-thread ~]  handle-thread
      [%vote %ted uid=@t vote=@t ~]  (handle-vote .y uid.p vote.p)
      [%vote %com uid=@t vote=@t ~]  (handle-vote .n uid.p vote.p)
      ::  admin
      [%del-ted uid=@t ~]  (del .y uid.p)
      [%del-com uid=@t ~]  (del .n uid.p)
      ::  metamask auth request?
      [%auth ~]  (handle-auth eyre-id body)
    ==
    ++  del
      |=  [is-ted=? uidt=@t]
      =/  uid  (slaw:sr %uw uidt)
      ?~  uid  ~
      =/  cued  (cue u.uid)
      =/  pid  ((soft pid:tp) cued)  ?~  pid  ~
      ?:  is-ted
        =/  ted  (get-thread:lib u.pid state)
        ?~  ted  ~
        (self-poke [%ui (~(got by sessions.state) src.bowl) eyre-id %del is-ted u.ted])
      =/  com  (get-comment:lib u.pid state)
      ?~  com  ~
      (self-poke [%ui (~(got by sessions.state) src.bowl) eyre-id %del is-ted u.com])
    ++  handle-vote
      |=  [is-ted=? uidt=@t vote=@t]
      =/  vot=?  .=(vote 'gud')
      =/  uid  (slaw:sr %uw uidt)  ?~  uid  ~
      =/  cued  (cue u.uid)
      =/  pid  %-  (soft pid:tp)  cued  ?~  pid  ~
      (self-poke [%ui (~(got by sessions.state) src.bowl) eyre-id %vote is-ted u.pid vot])
    ++  handle-thread
      ?~  body  ~
      =/  bod  (frisk:rd q.u.body)
      =/  md  (~(get by bod) 'text')  ?~  md  ~
      =/  title  (~(get by bod) 'title')  ?~  title  ~
      =/  url  (~(get by bod) 'url')  ?~  url  ~
      (self-poke [%ui (~(got by sessions.state) src.bowl) eyre-id %submit-thread u.title u.url u.md])
    ++  handle-reply
      |=  top=?
      ?~  body  ~
      =/  bod  (frisk:rd q.u.body)
      =/  pars  (~(get by bod) 'parent')  ?~  pars  ~
      =/  uid  (slaw:sr %uw u.pars)  ?~  uid  ~
      =/  cued  (cue u.uid)
      =/  pid  ((soft pid:tp) cued)  ?~  pid  ~
      =/  md  (~(get by bod) 'text')  ?~  md  ~
      ?:  top
        =/  ted  (get-thread:lib u.pid state)  ?~  ted  ~
        (self-poke [%ui (~(got by sessions.state) src.bowl) eyre-id %submit-comment u.ted u.md])
      =/  com  (get-comment:lib u.pid state)  ?~  com  ~
      (self-poke [%ui (~(got by sessions.state) src.bowl) eyre-id %submit-reply u.com u.md])
    ::  MetaMask authentication request; others go via EAuth.
    ::  Modified from ~rabsef-bicrym's %mask by ~hanfel-dovned.
    ++  handle-auth
      |=  [order-id=@t octs=(unit octs)]
      ^-  (list card:agent:gall)
      |^
      ?~  octs  ~|(%empty-auth-request !!)
      :: ?.  =('auth' (cut 3 [0 4] q.u.octs))
      ::   *(list card:agent:gall)
      =/  jon  (de:json:html q.u.octs)
      ?~  jon  ~|(%empty-auth-json !!)
      =/  body=json  u.jon
      =/  axn  (dejs-action body)
      =/  is-valid  (validate who.axn secret.axn adr.axn sig.axn)
      ~&  >>  signature-valid=[is-valid who.axn secret.axn adr.axn sig.axn]
      ?.  is-valid  ~|(%bad-metamask-signature !!)
      %+  weld
      (self-poke [%auth who.axn src.bowl secret.axn])
      %+  give-simple-payload:app:server
        order-id
      ^-  simple-payload:http
      :-  :-  200
          ~[['Content-Type' 'application/json']]
      =/  obj=json  %-  pairs:enjs:format  :~([%login-ok [%b .y]])
      `(as-octs:mimes:html (en:json:html obj))
      
      ++  validate
        |=  [who=@p challenge=secret:sur address=tape hancock=tape]
        ^-  ?
        =/  addy  (from-tape address)
        =/  cock  (from-tape hancock)
        =/  owner  (get-owner who)  ?~  owner  
          ~&  "no owner"  
          %.n
        ?.  =(addy u.owner)  
          ~&  "wrong owner"  
          %.n
        ?.  (~(has in challenges.state) challenge)  
          ~&  "bad challenge"  
          %.n
        =/  note=@uvI
          =+  octs=(as-octs:mimes:html (scot %uv challenge))
          %-  keccak-256:keccak:crypto
          %-  as-octs:mimes:html
          ;:  (cury cat 3)
            '\19Ethereum Signed Message:\0a'
            (crip (a-co:co p.octs))
            q.octs
          ==
        ?.  &(=(20 (met 3 addy)) =(65 (met 3 cock)))  
          ~&  "addy != cock"  
          %.n
        =/  r  (cut 3 [33 32] cock)
        =/  s  (cut 3 [1 32] cock)
        =/  v=@
          =+  v=(cut 3 [0 1] cock)
          ?+  v  99
            %0   0
            %1   1
            %27  0
            %28  1
          ==
        ?.  |(=(0 v) =(1 v))  
          ~&  "wrong v"
          %.n
        =/  xy
          (ecdsa-raw-recover:secp256k1:secp:crypto note v r s)
        =/  pub  :((cury cat 3) y.xy x.xy 0x4)
        =/  add  (address-from-pub:key:ethereum pub)
        =(addy add)
      ::
      ++  from-tape
        |=(h=tape ^-(@ux (scan h ;~(pfix (jest '0x') hex))))
      ::
      ++  get-owner
        |=  who=@p
        ^-  (unit @ux)
        =-  ?~  pin=`(unit point:naive)`-
              ~
            ?.  |(?=(%l1 dominion.u.pin) ?=(%l2 dominion.u.pin))
              ~
            `address.owner.own.u.pin
        .^  (unit point:naive)
          %gx
          %+  en-beam
            [our.bowl %azimuth [%da now.bowl]]
          /point/(scot %p who)/noun
        ==
      ++  dejs-action
        |=  jon=json
        ^-  authorization:sur
        =,  dejs:format
        %.  jon
        %-  ot
        :~  [%who (se %p)]
            [%secret (se %uv)]
            [%address sa]
            [%signature sa]
        ==
      --
    --
  ::
  ++  enjs-challenge
    =,  enjs:format
    |=  chal=@
    ^-  json
    %-  pairs
    :~  [%challenge [%s (scot %uv chal)]]
    ==
  ::
  ++  self-poke
    |=  noun=*
    ^-  (list card:agent:gall)
    :~  [%pass /gib %agent [our.bowl dap.bowl] %poke %noun !>(noun)]
    ==
  --
--
