# github-runner

Installs a [github actions self hosted runner](https://github.com/actions/runner)
and runs it as a service. Works on ubuntu (systemd) and on macos (launchd).

The archive is picked from `ansible_system` / `ansible_architecture`, so the
same role installs `linux-x64` on node-b and `osx-arm64` on the mac mini. Every
download is verified against the sha256 sums in `vars/main.yaml`.

## registration token

`config.sh` needs a registration token and those expire **one hour** after they
are created, so the one in 1password goes stale between runs. That is fine
because the role only registers a runner that is not registered yet: once
`.runner` exists in the installation directory the registration is skipped and
no token is needed.

To register a new runner (or re-register one that was removed in github):

1. open <https://github.com/organizations/circleup-ai/settings/actions/runners>,
   *New runner* and copy the `--token` value out of the instructions
2. update the 1password item
   `op://circleup/circleup Github Organization Self Hosted Runner Token/password`
3. run the playbook within the hour, e.g. `make ansible-node-b -- -t github-runner`

If the runner is not registered and no token is around the role fails with a
message saying so instead of running into an expired token error.

## upgrades

The runner updates itself when github releases a new version, so
`github_runner_version` is mostly the version that gets bootstrapped. Bumping
it re-extracts the archive over the existing installation (the registration in
`.runner` and `.credentials` survives) and restarts the service afterwards. A
bump also needs the matching sha256 sums added to `vars/main.yaml`.

The re-extract writes over the binaries of a running service, which is fine for
an idle runner but not for one in the middle of a job. Stop the service on the
host first if a bump happens during working hours:

```bash
# ubuntu
sudo /opt/actions-runner/svc.sh stop
# macos
cd ~/actions-runner && ./svc.sh stop
```

## variables

| variable | default | description |
| --- | --- | --- |
| `github_runner_url` | `""` | organization or repository url, required |
| `github_runner_token` | `""` | registration token, only needed on first registration |
| `github_runner_version` | `2.337.0` | runner release to bootstrap |
| `github_runner_dir` | `/opt/actions-runner` | installation directory |
| `github_runner_name` | inventory hostname | name shown in the github ui |
| `github_runner_labels` | `[]` | extra `runs-on` labels |
| `github_runner_runner_group` | `""` | github runner group, empty uses the org default |
| `github_runner_work_dir` | `_work` | checkout directory, relative to the installation directory |
| `github_runner_user` | `github-runner` | account the service runs as |
| `github_runner_user_group` | `github-runner` | primary group of that account |
| `github_runner_create_user` | `true` | create the account, false to reuse an existing user |
| `github_runner_docker_access` | `false` | add the account to the docker group |

`github_runner_docker_access` hands the runner the docker socket, which is root
on the host for anything a workflow executes. Only turn it on for a node whose
workflows are trusted.

## macos notes

The launch agent lives in the runner users `~/Library/LaunchAgents` and needs
that user to have a login session, so the runner has to be the auto logged in
console user (`plex` on the mac mini) rather than a dedicated service account.
`github_runner_create_user` is therefore `false` there.

`svc.sh start` only does a `launchctl load -w`. Over ssh that registers the
agent and clears its disabled flag but does not honour `RunAtLoad`, so the role
follows it with an explicit `launchctl kickstart`. Without that the runner is
registered and shows up **offline** in github, which looks like a networking or
token problem but is not.

If the agent does not come up after an ansible run, check it on the host:

```bash
# pid in the first column, - means registered but not running
launchctl list | grep actions.runner
launchctl print gui/$(id -u)/actions.runner.<org>.<name>
tail -f ~/Library/Logs/actions.runner.*/std*.log
```
