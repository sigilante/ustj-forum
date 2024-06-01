/-  sur=forum, tp=post
/+  lib=forum, sr=sortug
/+  server
::
/=  layout   /web/layout
/=  index    /web/pages/index
/=  thread   /web/pages/thread

:: /*  sw  %noun      /web/sw/js
:: /*  manifest  %noun      /web/manifest/json
::  assets
/*  css  %css  /web/assets/style/css
/*  spinner  %noun  /web/assets/spinner/svg
/*  favicon  %noun  /web/assets/favicon/ico
/*  favicon1  %noun  /web/assets/favicon-32x32/png
/*  favicon2  %noun  /web/assets/favicon-16x16/png

|%
+$  order  [id=@ta req=inbound-request:eyre]
++  pbail  
          %-  html-response:gen:server 
          %-  manx-to-octs:server  
              manx-bail
++  manx-bail  ^-  manx  ;div:"404"
++  route
  |=  [=order =state:sur =bowl:gall]  ^-  (list card:agent:gall)
  =/  rl  (parse-request-line:server url.request.req.order)
  =.  site.rl  ?~  site.rl  ~  t.site.rl
  
  =/  met  method.request.req.order
  =/  fpath=(pole knot)  [met site.rl]
  ~&  >  rl=fpath
  =/  bail  %+  give-simple-payload:app:server  id.order  pbail 
  |^
    :: if file extension assume its asset
    ?.  ?=(~ ext.rl)  (serve-assets rl)  
    ?+  fpath  bail
      [%'GET' rest=*]    (serve-get rl(site rest.fpath))
      [%'POST' rest=*]   (serve-post rl(site rest.fpath))
    ==
  ::
  ++  serve-assets
  |=  rl=request-line:server
  ~&  >>  assets=rl
  =/  pl
    ?+  [site ext]:rl  pbail  
    [[%style ~] [~ %css]]  (css-response:gen:server (as-octs:mimes:html css))
  :: [[%spinner ~] [~ %svg]]   [%full (serve-other:kaji %svg spinner)]
  :: [[%sw ~] [~ %js]]          [%mime /text/javascript sw]
  :: [[%manifest ~] [~ %json]]  [%mime /application/json manifest]
    ==
  (give-simple-payload:app:server id.order pl)

  ++  serve-get  
  |=  rl=request-line:server
  =/  pl  %-  html-response:gen:server  %-  manx-to-octs:server
  ^-  manx
    =/  p=(pole knot)  site.rl  ::?.  mob.rl  pat.rl  [%m pat.rl]
    ?:  ?=([%f rest=*] p)  (fragment rest.p)
    %-  layout  ^-  marl  :_  ~  
    ?+  p  manx-bail
      ~        (serve-index '1')
      [%p p=@t ~]  (serve-index p.p)
      [%ted ted=@t ~]  (serve-thread ted.p)
    ==
  (give-simple-payload:app:server id.order pl)
  ++  serve-index  |=  t=@t  ^-  manx
    =/  pag  (slaw %ud t)  ?~  pag  manx-bail
    =/  threads  (get-thread-page:lib u.pag state)
    (index [u.pag threads] bowl)
  ++  serve-thread  |=  uidt=@t  ^-  manx
    =/  uid  (slaw:sr %uw uidt)  ?~  uid  manx-bail
    =/  cued  (cue u.uid)
    =/  pid  %-  (soft pid:tp)  cued
    ?~  pid  manx-bail
    =/  ted  (get-thread:lib u.pid state)
    ?~  ted  manx-bail
    (thread u.ted bowl)
  
  ++  fragment
  |=  p=(pole knot)
    ?+  p  manx-bail
      ~  manx-bail
    ==

  ++  serve-post
  |=  rl=request-line:server  ~
  --
--
