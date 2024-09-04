/-  sur=forum
=<  |=(=state:sur (html state))
|%
++  html
  |=  =state:sur
  =/  redirect-str  "/forum"
  ;main#login-page.white
    ;h1.tc:"Login"
    ;form#form(action "/~/login", method "POST")
      ;h2.tc: Urbit OS (Azimuth via Arvo)
      ;input.mono(type "text")
        =name  "name"
        =id    "name"
        =placeholder  "~sampel-palnet"
        =required   "true"
        =minlength  "4"
        =maxlength  "14"
        =pattern    "~((([a-z]\{6})\{1,2}-\{0,2})+|[a-z]\{3})";
      ;input(type "hidden", name "redirect", value redirect-str);
      ;button(name "eauth", type "submit"):"Login via Ship »"
    ==
    ;form(id "metamaskLogin")
      ;h2.tc: Urbit ID (MetaMask)
      ;input.mono(type "text")
        =name  "metamask"
        =id    "urbitID"
        =placeholder  "~sampel-palnet"
        =required   "true"
        =minlength  "4"
        =maxlength  "14"
        =pattern    "~((([a-z]\{6})\{1,2}-\{0,2})+|[a-z]\{3})";
      ;input(type "hidden", name "redirect", value redirect-str);
      ;button(name "mauth", type "submit"):"Login via 🦊MetaMask »"
      ;script:"{metamask-script}"
      ;div.tc.nudge
        ;p
          ; After successful Metamask login, click through to the
          ;a/"https://journal.urbitsystems.tech/forum": USTJ Forum
          ; .
        ==
      ==
    ==
    ;h2.tc: Join the Urbit Network
    ;div.tc.nudge
      ;a.button/"https://redhorizon.com/join/2d55b768-a5f4-45cf-a4e5-a4302e05a1f9":"Get Urbit ID »"
      ;p:"If you don't have an Urbit ID, get one for free from Red Horizon."
    ==
  ==
++  metamask-script
  ^~
  %-  trip
'''
  
  window.addEventListener("DOMContentLoaded", () => {
    async function fetchSecret() {
        try {
            const response = await fetch('/forum/metamask');
            if (response.ok) {
                const data = await response.json();
                return data.challenge;
            } else {
                throw new Error('Failed to retrieve secret');
            }
        } catch (error) {
            console.error('Error fetching secret:', error);
        }
    }

    document.getElementById("metamaskLogin").addEventListener("submit", async (event) => {
        event.preventDefault(); // Prevent the form from submitting the default way

        // Fetch the secret from the server
        const secret = await fetchSecret();
        console.log(secret);

        if (typeof window.ethereum !== 'undefined') {
            try {
                const accounts = await window.ethereum.request({ method: "eth_requestAccounts" });
                const account = accounts[0];

                const signature = await window.ethereum.request({
                    method: "personal_sign",
                    params: [secret, account],
                });

                const response = await fetch('/forum/auth', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ 
                        who: document.getElementById("urbitID").value,
                        secret: secret,
                        address: account,
                        signature: signature
                    }),
                });

                if (response.ok) {
                    // location.reload();
                    window.location.replace('/forum');
                } else {
                    alert("Login failed. Please try again.");
                }
            } catch (error) {
                console.error("MetaMask login failed", error);
            }
        } else {
            alert("MetaMask is not installed. Please install it to continue.");
        }
    });
  });
'''
--
          ~&  "no owner"  
          %.n
        ?.  =(addy u.owner)  
        =/  owner  (get-owner who)  ?~  owner  
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
