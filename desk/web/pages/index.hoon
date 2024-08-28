/-  sur=forum, tp=post
/+  lib=forum, sr=sortug, cons=constants 
/=  comps  /web/components/components
|_  [thp=thread-page:sur =state:sur =bowl:gall]
++  $
  ^-  manx
  ;main
    ;div#index-top.f.g1
      ;div:"Popular"
      ;div.active:"Latest"
    ==
    ;div.thread-list
      ;*  thread-list
    ==
    ;+  moar
  ==
++  thread-list
  ^-  marl
  =/  tl  threads.thp
  =/  page  -.thp
  =/  init  (mul (dec -.thp) page-size:cons)
  =/  i  +(init)
  =|  res=marl
  |-  ?~  tl  (flop res)
  =/  ted  (thread i i.tl)
  =.  res  [ted res]
  $(i +(i), tl t.tl)
++  thread
  |=  [num=@ud t=thread:sur]
  ^-  manx
  =/  thread-link  (scow:sr %uw (jam pid.t))
  =/  titlet  (trip title.t)
  =/  numt  (scow %ud num)
  =/  descendants  (total-comments:lib t state)
  =/  link  ?.  ?=(%link -.content.t)  ~
            ;+  (link-div +.content.t)
  ;div.thread-preview.f.g2
    ;div.num:"{numt}."
    ;div.preview
      ;div.title.f.g1
        ;a.title-text/"/forum/ted/{thread-link}":"{titlet}"
        ;*  link  
      ==
      ;+  (thread-metadata:comps pid.t now.bowl votes.t descendants)
    ==
  ==
++  link-div
  |=  l=@t
  =/  url  (de-purl:html l)
  =/  dom  ""
  =/  domain  ?~  url  dom
  =/  host  r.p.u.url
  ?.  -.host  dom  
  ?:  ?=(@if +.host)  dom
  =/  parts=(list @t)  +.host
  =/  parts  (flop parts)
  |-  ?~  parts  dom
  =/  el  (trip i.parts)
  =.  dom
  ?:  .=(~ dom)  "{el}"  "{dom}.{el}"
  $(parts t.parts)
  ;a.out-link/"{(trip l)}"(target "_blank")
    ;span:"({domain})"
    ;span.arrow:"↗"
  ==
++  moar
  =/  len  (lent threads.thp)
  ?:  (lth len page-size:cons)  ;span;
  =/  page-num  (add 1 page.thp) 
  ;a.moar/"/forum/p/{(scow %ud page-num)}":"More"
--
