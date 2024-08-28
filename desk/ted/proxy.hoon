/-  spider
/+  strandio
=,  strand=strand:spider
=,  dejs-soft:format
=,  strand-fail=strand-fail:libstrand:spider
^-  thread:spider
|=  arg=vase
=/  a  !<  (unit json)  arg 
?~  a  (strand-fail:strand %no-body ~)
?.  ?=(%s -.u.a)  (strand-fail:strand %no-body ~)
=/  url  +.u.a
=/  m  (strand ,vase)
^-  form:m
|^  (retry url 0)
+$  res-t  (each json @t)  ::  for redirects
  ++  retry     |=  [url=@t count=@]
    ;<  r=res-t  bind:m  (send-req url)
    ?-  -.r
      %&  (pure:m !>(p.r))                            
      %|  ?:  (gte count 5)  (pure:m !>(`json`[%s 'error']))
          (retry p.r +(count))
    ==
  ++  send-req  |=  url=@t  
  =/  m  (strand ,res-t)  ^-  form:m
  =/  headers
  :~
    ['connection' 'keep-alive']
    ['Accept-language' 'en-US;en;q=0.9']
    ['Accept' '*/*']
    ['origin' 'https://www.google.com']
    ['referer' 'https://www.google.com/']
    ['DNT' '1']
    ['User-agent' 'facebookexternalhit/1.1']
    :: ['User-agent' 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36']
  ==
  =/  =request:http  [%'GET' url headers ~]
  ;<  ~  bind:m  (send-request:strandio request)
  ;<  res=client-response:iris  bind:m  take-client-response:strandio
  ?.  ?=(%finished -.res)  (strand-fail:strand %no-body ~)
  =/  headers  headers.response-header.res  
  =/  redirect  (get-header:http 'location' headers)
    ?^  redirect  (pure:m [%| u.redirect])  

  ::
  ?~  full-file.res  (strand-fail:strand %no-body ~)
  =/  htmls=@t  q.data.u.full-file.res
  =/  json  [%s htmls]
  (pure:m [%& json])
  --
