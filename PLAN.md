# Inception — 14-Day Plan (Sep 19 → Oct 2, finish before Oct 3 hackathon)

Target: 125% (mandatory + full bonus). Rule that governs the whole order below: **bonus is only evaluated if the mandatory part is perfect.** Nothing bonus-related starts before Day 10's checkpoint passes.

---

## Day 1 — Sep 19 (today)
- [ ] Read: Docker vs VM, images vs containers, layers
- [ ] Read: daemons, PID 1, why `tail -f` / `sleep infinity` entrypoints are forbidden
- [ ] Read: Docker networks, named volumes vs bind mounts, TLSv1.2/1.3 basics
- [ ] VM: install Debian or Alpine (penultimate stable), install Docker + docker-compose
- [ ] Confirm VM can reach the internet and run `docker run hello-world`

## Day 2 — Sep 20
- [ ] Repo skeleton: `Makefile`, `secrets/`, `srcs/`, `srcs/requirements/{mariadb,wordpress,nginx,bonus,tools}`
- [ ] `srcs/.env` + `secrets/*.txt` stubs (git-ignored from the start — add `.gitignore` now, not later)
- [ ] `srcs/docker-compose.yml` skeleton: three empty service blocks, network declared, two named volumes declared with the `/home/<login>/data` device mapping
- [ ] `Makefile` target that calls `docker-compose up --build` on the skeleton

## Day 3 — Sep 21
- [ ] MariaDB `Dockerfile` (Debian/Alpine base, no `latest` tag)
- [ ] Init script: create WordPress DB, create 2 users (one admin — username must NOT contain admin/administrator in any case), no hardcoded passwords, read from env/secrets
- [ ] Run `mysqld` as PID 1 in foreground, no hacky loop
- [ ] Test MariaDB container standalone — connect via `docker exec`, verify both users exist

## Day 4 — Sep 22
- [ ] WordPress `Dockerfile` (php-fpm only, no nginx inside)
- [ ] Install `wp-cli`, script non-interactive `wp-config.php` generation from env vars
- [ ] php-fpm listening on 9000
- [ ] Container starts without a DB yet — confirm no crash loop, just waits/retries cleanly

## Day 5 — Sep 23
- [ ] Connect WordPress → MariaDB over the docker network
- [ ] Non-interactive `wp core install`, create admin user with the compliant username + a second regular user
- [ ] Debug connection issues (this is usually the single worst time sink — budget the whole day)
- [ ] Confirm WordPress files persist under the named volume

## Day 6 — Sep 24
- [ ] NGINX `Dockerfile`
- [ ] Generate self-signed cert (openssl), config restricted to TLSv1.2/1.3 only
- [ ] `fastcgi_pass` to `wordpress:9000`
- [ ] Test NGINX container alone against a dummy backend before wiring to WordPress

## Day 7 — Sep 25
- [ ] Full `docker-compose up` — all three services together
- [ ] Add `<login>.42.fr` to local DNS/hosts pointing at the VM's IP
- [ ] Verify site loads at `https://localhost` and `https://<login>.42.fr`
- [ ] Fix startup-order races (depends_on isn't enough — check actual readiness)

## Day 8 — Sep 26
- [ ] Confirm both named volumes land in `/home/<login>/data` on the host, not just inside Docker's storage
- [ ] `docker compose down && docker compose up` — verify DB + WP files persist
- [ ] Kill a container manually, confirm `restart: on-failure` (or equivalent) brings it back
- [ ] Reboot the VM, confirm everything comes back up cleanly

## Day 9 — Sep 27
- [ ] Security pass: grep the whole repo for any stray password/credential outside `secrets/`
- [ ] Confirm every image is built locally (nothing pulled pre-built except the Alpine/Debian base)
- [ ] Confirm no `network: host`, no `--link`, no `links:`
- [ ] Re-check every container's entrypoint for forbidden infinite-loop patterns

## Day 10 — Sep 28 — MANDATORY FREEZE CHECKPOINT
- [ ] Full teardown → rebuild from zero, time it, confirm it just works
- [ ] Self-defense dry run: explain every Dockerfile line, every compose directive, out loud
- [ ] Ideally: have someone else try to break it (peer review, per the subject's own AI-instructions chapter)
- [ ] **Do not proceed past this day until mandatory is airtight**





## Day 11 — Sep 29 — Bonus: Redis + Adminer
- [ ] Redis cache container, wire into WordPress (plugin or manual config)
- [ ] Adminer container, confirm it can reach MariaDB

## Day 12 — Sep 30 — Bonus: FTP + static site
- [ ] FTP server container pointed at the WordPress volume
- [ ] Static site container (non-PHP language of choice)

## Day 13 — Oct 1 — Bonus: 5th service + integration
- [ ] Pick and justify a 5th service (be ready to defend the choice)
- [ ] Full bonus integration test alongside mandatory — nothing broken by the additions






## Day 14 — Oct 2 — Docs + defense prep
- [ ] `README.md` — italic first line, Description, Instructions, Resources (incl. how AI was used, for which tasks), plus the required VM-vs-Docker / secrets-vs-env / network-vs-host / volumes-vs-bind-mounts comparisons
- [ ] `USER_DOC.md` — services overview, start/stop, access site + admin panel, find credentials, check services are healthy
- [ ] `DEV_DOC.md` — environment setup from scratch, build/launch via Makefile, container/volume commands, where data lives and how it persists
- [ ] Final full rebuild test
- [ ] Rehearse defense answers

**Oct 3 — free for the hackathon.**
