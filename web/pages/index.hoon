/-  sur=forum, tp=post
/+  lib=forum, sr=sortug 
|_  [thp=thread-page:sur =bowl:gall]
++  $  ^-  manx
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
++  thread-list  ^-  marl
  =/  tl  threads.thp
  =/  i  1
  =|  res=marl
  |-  ?~  tl  (flop res)
    =/  ted  (thread i i.tl)
    =.  res  [ted res]
    $(i +(i), tl t.tl)
    
++  thread  |=  [num=@ud t=thread:sur]  ^-  manx
  =/  thread-link  (scow:sr %uw (jam pid.t))
  =/  titlet  (trip title.t)
  =/  numt  (scow %ud num)
  =/  link  ?.  ?=(%link -.content.t)  ~
            ;+  (link-div +.content.t)
  =/  ago  (post-date-ago:lib id.pid.t now.bowl %yau)
  =/  author  (scow %p ship.pid.t)
  =/  comments  ?~  replies.t  ~  
    ;+  ;div:"{(scow %ud (lent replies.t))} comments"

  
  ;div.thread-preview.f.g2
    ;div.num:"{numt}."
    ;div.preview
      ;div.title.f.g1
        ;a/"/forum/ted/{thread-link}":"{titlet}"
        ;*  link  
      ==
      ;div.meta.f.g2
        ;+  (votes votes.t)
        ;div:"{author}"
        ;div:"{ago} ago"
        ;*  comments
      ==
    ==
  ==
++  votes  |=  v=votes:tp
  =/  old  (old:si tally.v)
  =/  img  ?:  -.old
    ;img@"/up.svg";
    ;img@"/down.svg";
  ;div.f.g0
    ;+  img
    ;div:"{(scow %ud +.old)}"
  ==
++  link-div  |=  l=@t
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
  
;div.out-link
  ;a/"{(trip l)}":"({domain})"
  ;img@"/imgs/outlink.svg";
==
++  moar
  =/  page-num  (add 1 page.thp) 
  ;a/"/forum/p/{(scow %ud page-num)}":"More"
--
