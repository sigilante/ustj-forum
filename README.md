# Urbit Systems Technical Journal Forum

Created by ~polwex for the [Urbit Foundation](https://urbit.org).

##  Command-Line Interface

```hoon
> :ustj|add-link ~rovnys-ricfer 'USTJv1i1 - Eight Years After the Whitepaper' 'https://urbitsystems.tech/article/v01-i01/eight-years-after-the-whitepaper'

:ustj|add-text ~lagrev-nocfep 'The Forum Rules' '1. Be civil. No swearing or vulgarity. This is a professional forum.\0a2. Discussion trend technical and should engage on the merits. No _ad hominem_ or other fallacious reasoning permitted.\0a3. No spamming, brigading, DDOSing, etc. Keep things running smoothly and keep the conversation legible.\0a\0aWe reserve the right to update these rules should behavior merit it.\0a\0aPlease report any bugs to ~lagrev-nocfep on the network.'

> :ustj [%ui ~rovnys-ricfer *@ta %submit-thread title='USTJv1i1 - Eight Years After the Whitepaper' url='https://urbitsystems.tech/article/v01-i01/eight-years-after-the-whitepaper' text='']

> :ustj [%ui ~magbel *@ta %auth ~magbel *@uv "0xae530A3D4bcD3B236F4227A4ADe2f462B802FA25" "0xae530A3D4bcD3B236F4227A4ADe2f462B802FA25"]
```

##  Login

1. Urbit OS login is managed by Eyre's EAuth system.
2. Urbit ID login is provisioned for MetaMask.  Two endpoints are exposed:
  1. `/metamask` to obtain the session secret (via `POST`).
  2. `/auth` to `POST` the authentication attempt.

---

## TODOs ahead of launch

- [~] fix CSS/layout to perfectly match main site
- [x] fix HTTPS on host ship
- [~] redirect from MetaMask login to main forum page when logged in
- [ ] fix 404 on top parent of comment (should return to thread)
- [x] add “Hosted on Urbit” to footer (`/web/layout.hoon`)
- [x] implement CLI generators for pokes
- [x] link from main site
