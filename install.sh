#!/bin/bash
set -ex

CWD=$(pwd)

find "$CWD" -maxdepth 1 -type f ! -name install.sh -exec ln -sf {} ~/ \;

# Symlink files from each subdirectory into the matching ~/.<dir>
for dir in "$CWD"/.*; do
    [ -d "$dir" ] || continue
    name=$(basename "$dir")
    [[ "$name" == "." || "$name" == ".." || "$name" == ".git" ]] && continue
    mkdir -p ~/"$name"
    find "$dir" -maxdepth 1 -type f -exec ln -sf {} ~/"$name"/ \;
done

crontab ~/.crontab

sudo apt -y install emacs zile mosh nfs-common

# ---------------------------------------------------------------------------
# System bootstrap: root-owned state that does not live in $HOME and so does
# not survive an OS-disk swap. Every step is idempotent; safe to re-run.
# ---------------------------------------------------------------------------

# Per-user memory cap via systemd-oomd: a runaway build/test gets OOM-killed
# instead of locking up the box (and taking tmux with it).
# MemoryMax is sized to (total RAM - 2G) so it adapts to whatever machine this
# runs on, leaving a couple GB for the kernel.
sudo apt -y install systemd-oomd
mem_max_g=$(( $(free -g | awk '/Mem:/{print $2}') - 2 ))
sudo mkdir -p /etc/systemd/system/user.slice.d
sudo tee /etc/systemd/system/user.slice.d/limits.conf >/dev/null <<EOF
[Slice]
MemoryAccounting=true
MemoryMax=${mem_max_g}G
ManagedOOMMemoryPressure=kill
ManagedOOMMemoryPressureDurationSec=1
EOF
sudo systemctl daemon-reload

# NFS mounts. The rest of /etc/fstab is written by cloud-init (comment=cloudconfig);
# only these two lines are hand-added, so append them idempotently.
for nfs_line in \
    "gravytrain:/ /mnt/gravytrain/ nfs rw 0 0" \
    "iss:/ /mnt/iss/ nfs rw 0 0"; do
    grep -qF "$nfs_line" /etc/fstab || echo "$nfs_line" | sudo tee -a /etc/fstab >/dev/null
done
sudo mkdir -p /mnt/gravytrain /mnt/iss
sudo mount -a || true

# kubectl: only the binary is lost on a swap (~/.kube/config and ~/.krew are in
# $HOME). Keep the version within one minor of the cluster (see the internal
# k8s onboarding doc for the current cluster version).
KUBECTL_VERSION=v1.29.0
if ! command -v kubectl >/dev/null 2>&1; then
    kube_tmp=$(mktemp -d)
    curl -Lo "$kube_tmp/kubectl" "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 "$kube_tmp/kubectl" /usr/local/bin/kubectl
    rm -rf "$kube_tmp"
fi

# wemux (terminal sharing). Cloned from upstream; the config is tracked in this
# repo (system/wemux.conf carries the host_list customization).
if [ ! -e /usr/local/share/wemux ]; then
    sudo git clone https://github.com/zolrath/wemux.git /usr/local/share/wemux
    sudo ln -sf /usr/local/share/wemux/wemux /usr/local/bin/wemux
fi
sudo install -m 0644 "$CWD/system/wemux.conf" /usr/local/etc/wemux.conf

echo
echo ">>> Done. REBOOT required for the user.slice memory limit to take effect."
