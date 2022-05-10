# MMAI831 Watts Team

This is a repository for team collaboration on MMAI831 assignments.
Each assignment gets its own directory.

## A. Avoiding overwriting each other's work

Team members are encouraged to work in their own branches and avoid pushing
directly into branch *main*. Pulls to *main* will be done during meetings.

### A.1 Initial branch creation
```
git checkout -b <your branch name>
<Do work>
git add .
git commit -m'A message on what you did'
git push -u origin <your branch name>
```

### A.2 Subsequent branch work

```
<Do work>
git add .
git commit -m'A message on what you did'
git push
```

## B. Docker

For those wishing to keep their workstations clean of python packages and
virtual environments, Docker containerization is provided.

### B.1 Build

```
docker build -t gmc/mmai831 .
```

### B.2 Run

This fires up a Jupyter Lab server that is accessible to any workstation on the
local network. To access, copy and paste the URL given in the output.
```
./runme.sh
```
