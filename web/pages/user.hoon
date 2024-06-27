/-  sur=forum, tp=post
/+  sig=sigil-sigil, sr=sortug
|_  [who=@p tedf=threads:sur gf=gfeed:tp karma=@s]
++  sigil
=/  p  (scow %p who)
  ;div#sigil
    ;h2.tc:"{p}"
    ;div#sigil-img
      ;+  (sig(size 128) who)
    ==
  ==
++  $
  =/  karmas  (scow:sr %s karma)
  =/  teds  (scow %ud (lent (tap:torm:sur tedf)))
  =/  coms  (scow %ud (lent (tap:gorm:tp gf)))
  ;main#user-page.white
    ;div#main
      ;+  sigil
      ;div#stats.tc
        ;div:"Karma: {karmas}"
        ;div:"Threads: {teds}"
        ;div:"Comments: {coms}"
      ==
      ;a#logout.button/"/~/logout?redirect=/forum":"Logout"
    ==
  ==
--
