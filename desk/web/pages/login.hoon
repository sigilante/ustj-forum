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
    ==
    ;div.tc.nudge
      ;p:"If you don't have an Urbit ID, click on this link to get one for free."
      ;a.button/"https://redhorizon.com/join/2d55b768-a5f4-45cf-a4e5-a4302e05a1f9":"Get Urbit ID »"
    ==
  ==
++  metamask-script
  ^~
  %-  trip
'''
  
  window.addEventListener("DOMContentLoaded", () => {
    async function fetchSecret() {
        try {
            const response = await fetch('/metamask');
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

                const response = await fetch('/auth', {
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
                    location.reload();
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
